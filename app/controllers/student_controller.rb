class StudentController < ApplicationController
  before_filter :validate_institute_url
  before_filter {|role| role.validate_role 'STUDENT'}
  def home
  end
  def profile_edit
  end

  def profile_update
    user_id = session[:user_id]
    student_program_detail = StudentProgramDetail.find_by_student_id(user_id)
    persist_success = true
    if student_program_detail.nil?
      logger.info 'no student exists creating new'
      #no entry for student exists in the student program detail table
      #create a new one
      student_program_detail = StudentProgramDetail.new
      student_program_detail.student_id = user_id
      #why twice i dont know
      student_program_detail.program_id = params[:program][:program]
      student_program_detail.term = params[:term][:term]
      begin
        student_program_detail.save
      rescue Exception => e
        logger.error e.message
        persist_success = false
      end
    else
      #why twice i dont know
      begin
         student_program_detail.update_attributes(:program_id => params[:program][:program],:term => params[:term][:term])
      rescue Exception => e
        logger.error e.message
        persist_success = false
      end
     end
    
    respond_to do |format|
      if persist_success
        format.html {redirect_to('/student')}
      else
        format.html {render :action => 'profile_edit'}
      end
    end

  end

end
