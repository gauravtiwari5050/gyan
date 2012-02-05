class IvrsController < ApplicationController
  def home
    logger.info 'HYD -> logging'
    logger.info 'HYD ->' + params.inspect
    current_stage =  get_current_stage
    @kookoo_xml = process_stage(current_stage)
    next_stage =  get_next_stage
    next_stage_input =  collect_input(next_stage)
    if next_stage_input.nil?
      @kookoo_xml += process_stage(next_stage)
      @kookoo_xml += process_end
    else
      @kookoo_xml += next_stage_input
    end

    session[:current_stage] = next_stage
  end
  def get_current_stage
    if params[:event] == 'NewCall'
      session[:current_stage] = 'NEWCALL'
    end
    return session[:current_stage]  
  end
  def get_next_stage
    stage_changes = {}
    stage_changes["NEWCALL"] = "INSTITUTE_HOME"
    stage_changes["INSTITUTE_HOME"] = "OPTIONS"
    stage_changes["OPTIONS_1"] = "NOTICE"
    stage_changes["OPTIONS_2"] = "RESULT"
    stage_changes["NOTICE"] = "END"
    stage_changes["RESULT"] = "END"

    logger.info "next stage is" + stage_changes[session[:current_stage]]

    return stage_changes[session[:current_stage]]
  end
  def process_stage(stage)
    if stage == 'NEWCALL'
      return process_newcall
    elsif stage == 'INSTITUTE_HOME'
      return process_institute_home
    elsif stage == "OPTIONS"
      return process_options
    elsif stage == "OPTIONS_1"
      return process_options_1
    elsif stage == "OPTIONS_2"
      return process_options_2
    elsif stage == "NOTICE"
      return process_notice
    elsif stage == "RESULT"
      return process_result
    else
      return process_end
    end
  end

  def collect_input(stage)
    inputs = {}
    inputs["INSTITUTE_HOME"] =  collect_dtmf("Please enter your institute I D")
    inputs["OPTIONS"] = collect_dtmf("Select 1 for notices and 2 for results")
    inputs["RESULT"] = collect_dtmf("Please enter your rollnumber")

    input_str = inputs[stage]
    return input_str
  end

  def process_notice
    logger.info session.inspect
    institute = Institute.find_by_id(session[:ivrs_institute_id])
    success = false
    message  = "No notices for your institute as of now"
    if !institute.nil?
     ivrs_info = institute.ivrs_info
     if !ivrs_info.nil?
      message =  ivrs_info.message
      success =  true
     end
    end
    return play_text(message)
  end

  def process_newcall
    return play_text("Welcome to CloudClass Interactive Voice Response System")
  end

  def process_institute_home
    institute_name = get_institute_name_from_id(params[:data])
    kookoo_xml = ""
   if institute_name.nil?
      kookoo_xml += play_text("Sorry. The institute I D was incorrect. Please try again later." )
      kookoo_xml += hangup
   else
      kookoo_xml += play_text("Welcome to " +  institute_name)
   end
   return kookoo_xml
  end

  def process_options
   option =  params[:data]
   text = "You have selected  option "
   if option == "1"
    session[:current_stage] = "OPTIONS_1"
    text += option
   elsif option == "2"
    session[:current_stage] = "OPTIONS_2"
    text += option
   else
    session[:current_stage] = "BAD"
    return play_text("Unrecognized option. Please try again later")
   end

   return play_text(text)
  end

  def process_options_1
    return play_text("No notices for your institute")
  end

  def process_options_2
    return play_text("Results portal")
  end

  def process_result
   roll_number = params[:data]
   user =  get_user_from_roll_number(params[:data])
   kookoo_xml = ""
   if user.nil?
      kookoo_xml += play_text("Sorry. The roll number is incorrect.Please try again later" )
   else
      kookoo_xml += play_text("The results for " +  user + " are  ninety nine percent")
   end
   return kookoo_xml
  end

  def process_end
    return play_text("Thankyou for using cloud class.") + hangup
  end

  def get_institute_name_from_id(institute_id)
    institute =  Institute.find_by_id(institute_id)
    session[:ivrs_institute_id] = institute_id
    return institute.name
  end
  
  def get_user_from_roll_number(roll_number)
    if roll_number == '123456'
      return 'gaurav tiwari'
    else
      return nil
    end
 end

  def play_text(text)
   return '<playtext>' +  text + '</playtext>'
  end

  def collect_dtmf(text)
   return '<collectdtmf>' +  play_text(text) + '</collectdtmf>'
  end
  def hangup
    return '<hangup></hangup>'
  end


end
