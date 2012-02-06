include Util
class TeacherController < ApplicationController
  before_filter :validate_institute_url
  before_filter {|role| role.validate_role 'TEACHER'}
  
  def home
  end
  def course_index
    @courses = get_all_courses_for_user
  end
  
  def users_index
  end
  
  def department_index
    @departments = Department.find(:all,:conditions => {:institute_id => get_institute_id})
  end

  def students_new
  end
  def students_new_bulk
  @helper_file = HelperFile.new
  end


  def students_bulk_add
   success =  true
   status_message = ''
   if !params[:user_list].nil?
    #bulk add users using the list sent in text
    success,status_message = add_users_from_list('STUDENT',params[:user_list])
   elsif !params[:helper_file].nil?
     success,status_message = add_users_from_file('STUDENT',params[:helper_file])
   else
     success = false
     status_message = 'Please upload a file or give a list of emails in the box'
   end
  
   respond_to do |format|
    if success == true
      flash[:notice] =  status_message
    else
      flash[:alert] =  status_message
    end
    format.html {redirect_to('/teacher/students/bulk/new')}
   end
  end
  def students_add
   user_email = params[:user_email]
   user_dob = params[:user_dob]
   user_name = params[:user_name]
   success =  true
   status_message = 'User created successfuly,an email has been sent to the user to complete registration'
   if user_email.nil? || user_email.length == 0
    success = false
    status_message = 'Email cannot be blank'
   end

   if success == true
    user = create_vanilla_user(user_email,'STUDENT')
    begin
      if !user_dob.nil? && user_dob.length > 0
        #TODO add date of birth field to the user
      end
      if !user_name.nil? && user_name.length > 0
        user.username = user_name
      end
      user.save
      
      student_program_detail = StudentProgramDetail.new
      student_program_detail.student_id = user.id
      #why twice i dont know
      program_id = params[:user_program][:user_program]
      if !program_id.nil?
        student_program_detail.program_id = program_id
      end
      term = params[:user_term][:user_term]
      if !term.nil?
        student_program_detail.term = term
      end
      student_program_detail.save

      Delayed::Job.enqueue(MailingJob.new(user.id))
    rescue Exception => e
      success =  false
      status_message = 'Error creating user,the email id should be unique'
      logger.info e.message
    end
    
   end
   
   respond_to do |format|
    if success == true
      flash[:notice] =  status_message
    else
      flash[:alert] =  status_message
    end
    format.html{redirect_to('/teacher/students/new')}
   end
    
  end
  def manage_students
    #TODO get students for only teachers courses
    @users = User.find(:all,:conditions => {:user_type => 'STUDENT',:institute_id => get_institute_id })
  end
  def connect_students_new
  end
  def connect_users_create(user_type)
  #TODO only connect with students for his courses
    users = User.find(:all ,:conditions => {:institute_id => get_institute_id,:user_type => user_type })
    logger.info "HYD ->" + users.class.to_s
    from_user = current_user
    bulk_message_subj = params[:subject]
    bulk_message = params[:message]
    is_email = params[:email]
    is_sms = params[:sms]
    is_fb = params[:faceboook]
    is_twitter = params[:twitter]
    #TODO validate above booleans ?
    task =  create_new_task('BULK_MESSAGE','sending message to users',current_user.id,true)
    bulk_messaging_job = BulkMessagingJob.new(task,users,from_user,bulk_message_subj,bulk_message,is_email,is_sms,is_fb,is_twitter)
    Delayed::Job.enqueue(bulk_messaging_job)
  end

  def connect_students_create
    connect_users_create("STUDENT")
    respond_to do |format|
      format.html{ redirect_to('/teacher/connect/students/new')}
    end
  end

end
