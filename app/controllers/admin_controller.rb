class AdminController < ApplicationController
  before_filter :validate_institute_url
  before_filter {|role| role.validate_role 'ADMIN'}
  def home
    
  end

  def department_index
    @departments = Department.find(:all,:conditions => {:institute_id => get_institute_id})
  end

  def programs_new
    @departments = Department.find(:all,:conditions => {:institute_id => get_institute_id})
  end

  ##functions to add teachers,students
  def teachers_new
  end
  def students_new
  end
  def teachers_new_bulk
  @helper_file = HelperFile.new
  end
  def students_new_bulk
  @helper_file = HelperFile.new
  end

  def teachers_add
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
    user = create_vanilla_user(user_email,'TEACHER')
    begin
      if !user_dob.nil? && user_dob.length > 0
        #TODO add date of birth field to the user
      end
      if !user_name.nil? && user_name.length > 0
        user.username = user_name
      end
      user.save

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
    format.html{redirect_to('/admin/teachers/new')}
   end

  end

  def add_users_from_list(user_type,user_list)
   if user_list.nil? || user_list.length == 0
    return false,'the list of email you provided is not valid'
   end
   user_emails = user_list.split(/[\n ,]+/)
   for email in user_emails
    email = email.strip! || email
    user = create_vanilla_user(email,user_type)
    begin
      
      user.save
      Delayed::Job.enqueue(MailingJob.new(user.id))
    rescue Exception => e
      logger.info e.message
    end
   end

   return true,'The list of users has been queued for processing.Emails will be sent out to the users soon'
    
  end

  def add_users_from_file(user_type,helper_file)
    if helper_file.nil?
      return false,'No file added'
    end
    @helper_file = HelperFile.new(helper_file)
    file_url = 'public' + @helper_file.file.url.to_s;
    logger.info  file_url
    task = Task.new
    task.task_type = 'CREATE_USER_FROM_FILE'
    task.description = 'creates users from uploaded file'
    task.completion_status = 'RUNNING'
    task.execution_status = 'PENDING'
    task.output = ''
    task.user_id = current_user.id
    task.save

    Delayed::Job.enqueue(CreateUserFromFileJob.new(file_url,task.id,user_type,get_institute_id))
  end

  def teachers_bulk_add
   success =  true
   status_message = ''
   if !params[:user_list].nil?
    #bulk add users using the list sent in text
    success,status_message = add_users_from_list('TEACHER',params[:user_list])
   elsif !params[:helper_file].nil?
     success,status_message = add_users_from_file('TEACHER',params[:helper_file])
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
    format.html {redirect_to('/admin/teachers/bulk/new')}
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
    format.html{redirect_to('/admin/students/new')}
   end
    
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
    format.html {redirect_to('/admin/students/bulk/new')}
   end
  end

  def users_index

  end

  def course_index
    @courses = get_all_courses_for_user
  end

  def manage_students
    @users = User.find(:all,:conditions => {:user_type => 'STUDENT',:institute_id => get_institute_id })
  end
  
  def manage_teachers
    @users = User.find(:all,:conditions => {:user_type => 'TEACHER',:institute_id => get_institute_id })
  end
  
  def manage_programs
    @departments = Department.find(:all,:conditions => {:institute_id => get_institute_id})
  end

  def report_traffic
    @page_views = Hash.new  
    sections = ['%','Program','Course','Department','CourseGroup']
    institute_id = get_institute_id
    for section in sections 
      for i in 0..4
        date = (Date.today-i).to_s
        count = Impression.where('DATE(updated_at) = ? and institute_id = ? and impressionable_type like ?',Date.today-i,institute_id,section).count
        if @page_views[section].nil?
          @page_views[section] = Hash.new
        end
        @page_views[section][date] = count
      end
    end
    logger.info @page_views.inspect
  end

end
