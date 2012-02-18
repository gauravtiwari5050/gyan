include Util

class AdminController < ApplicationController
  before_filter :validate_institute_url
  before_filter {|role| role.validate_role 'ADMIN'}
  def home
    
  end
  def department_new
    @department = Department.new
  end
  
  def department_create
    @department = Department.new(params[:department])
    @department.institute_id = get_institute_id
    if @department.save
      respond_to  do |format|
        format.html {redirect_to('/departments/' + @department.id.to_s)}
      end
    else
      respond_to  do |format|
        format.html {render :action => "department_new" }
      end
    end

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
      if !user.save
        raise 'Error saving user'
      end

      Delayed::Job.enqueue(MailingJob.new(user.id))
    rescue Exception => e
      success =  false
      status_message = 'Error creating user,the email id should be unique and of the form name@xyz.com'
      logger.info e.message
    end
    
   end
   
   respond_to do |format|
    if success == true
      flash[:notice] =  status_message
      format.html{redirect_to('/admin/teachers/new')}
      format.js  { render :json => user }
    else
      flash[:alert] =  status_message
      format.html{redirect_to('/admin/teachers/new')}
    end
   end

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
      if !user.save
        raise 'Error creating user'
      end
      #TODO bad hack
      if !params[:user_program].nil? && !params[:user_program][:user_program].nil?
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
     end
      Delayed::Job.enqueue(MailingJob.new(user.id))
    rescue Exception => e
      success =  false
      status_message = 'Error creating user,the email id should be unique and of the form nam@xyz.com'
      logger.info e.message
    end
    
   end
   
   respond_to do |format|
    if success == true
      flash[:notice] =  status_message
      format.js  { render :json => user }
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

  def task_show
    @task = Task.find(params[:task_id])
  end

  def connect_students_new
  end

  

  def connect_users_create(user_type)
    users = User.find(:all ,:conditions => {:institute_id => get_institute_id,:user_type => user_type })
    logger.info "HYD ->" + users.class.to_s
    from_user = current_user
    bulk_message_subj = params[:subject]
    bulk_message = params[:message]
    is_email = params[:email]
    is_sms = params[:sms]
    is_fb = params[:faceboook]
    is_twitter = params[:twitter]
    task =  create_new_task('BULK_MESSAGE','sending message to users',current_user.id,true)
    bulk_messaging_job = BulkMessagingJob.new(task,users,from_user,bulk_message_subj,bulk_message,is_email,is_sms,is_fb,is_twitter)
    Delayed::Job.enqueue(bulk_messaging_job)

    
  end

  def connect_students_create
    connect_users_create("STUDENT")
    respond_to do |format|
      format.html{ redirect_to('/admin/connect/students/new')}
    end
  end

  def connect_teachers_create
    connect_users_create("TEACHER")
    respond_to do |format|
      format.html{ redirect_to('/admin/connect/teachers/new')}
    end
    
  end

  def connect_teachers_new
    
  end

  def connect_departments_select
    @departments = Department.find(:all,:conditions => {:institute_id => get_institute_id})
  end

  def connect_department_new
    @department = Department.find(params[:department_id])
  end

  def connect_department_create
    students = get_students_for_department(params[:department_id])
    bulk_message(students,current_user)
    respond_to do |format|
      format.html{ redirect_to('/admin/departments/'+params[:department_id]+'/connect/new')}
    end

  end

  def ivrs_edit
    @helper_file = HelperFile.new  
    institute = Institute.find(get_institute_id)
    @ivrs_info = institute.ivrs_info
    if @ivrs_info.nil?
      @ivrs_info = IvrsInfo.new
      @ivrs_info.institute_id = get_institute_id
      @ivrs_info.message  = "No notice available currently"
      @ivrs_info.save
    end
  end

  def ivrs_update
    @helper_file = HelperFile.new  
    institute = Institute.find(get_institute_id)
    @ivrs_info = institute.ivrs_info
    respond_to do |format|
      if @ivrs_info.update_attributes(params[:ivrs_info])
        format.html { redirect_to('/admin/ivrs/edit', :notice => 'Your IVRS message was successfully updated') }
      else
        format.html { render :action => "ivrs_edit" }
      end
    end
     
  end

  def ivrs_result_upload
    institute = Institute.find(get_institute_id)
    @ivrs_info = institute.ivrs_info
    @helper_file = HelperFile.new(params[:helper_file])
    file_url = 'public' + @helper_file.file.url.to_s;
    logger.info  file_url
    task = Task.new
    task.task_type = 'CREATE_IVRS_RESULTS_FROM_FILE'
    task.description = 'creating results to be accessed using IVRS system'
    task.completion_status = 'RUNNING'
    task.execution_status = 'PENDING'
    task.output = ''
    task.user_id = current_user.id
    task.save

    Delayed::Job.enqueue(CreateIvrsResultsFromFileJob.new(file_url,task.id,@ivrs_info.id))

    respond_to do |format|
      format.html { redirect_to('/admin/ivrs/edit') }
    end
  end

end
