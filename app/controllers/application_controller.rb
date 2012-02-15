class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :correct_safari_and_ie_accept_headers
  after_filter :set_xhr_flash
  def set_xhr_flash
    flash.discard if request.xhr?
  end

  def correct_safari_and_ie_accept_headers
    ajax_request_types = ['text/javascript', 'application/json', 'text/xml']
    request.accepts.sort! { |x, y| ajax_request_types.include?(y.to_s) ? 1 : -1 } if request.xhr?
  end

  helper_method :get_all_courses_for_institute,:get_all_courses_for_teacher,:get_all_courses_for_user,:get_home_for_user,:get_user_type,:get_programs_hash_for_institute,:join_channel,:join_collaboration,:current_user,:get_current_institute,:get_user_by_user_id

  def md5_hash(content)
  require 'digest/md5'
    digest = Digest::MD5.hexdigest(content) 
    return digest
  end

  def unique_id(prefix)
  require 'uuidtools'
    return  prefix.to_s + UUIDTools::UUID.timestamp_create.to_s
  end

  def create_vanilla_user(email,user_type)
    user = User.new
    user.institute_id = get_institute_id
    user.email = email
    user.user_type = user_type
    user.one_time_login = unique_id('')
    user.is_validated = false
    return user
  end

  def validate_institute_url
    # add another function to validate url for logged in user
    current_host = request.host
    if !Rails.env.production?
     #current_host += ':' + request.port.to_s TODO ?? 3000 hard code why ?
      current_host += ':' + 3000.to_s
    end
    institute_url = InstituteUrl.find_by_url(current_host)
    if institute_url.nil?
      redirect_to (GyanV1::Application.config.landing_page.to_s)
    end

  end

  def validate_logged_in_status
    if !is_logged_in
      redirect_to (GyanV1::Application.config.landing_page.to_s)
    end
  end

  def get_user_type
    return session[:user_type]
  end

  def get_home_for_user
   if session[:user_type] == 'ADMIN'
      return '/admin' 
   elsif session[:user_type] == 'STUDENT'
      return '/student'
   elsif session[:user_type] == 'TEACHER'
      return '/teacher'
   end
   return '/bad'
  end

  def get_institute_id
    current_host = request.host
    if !Rails.env.production?
      #current_host += ':' + request.port.to_s TODO 3000hardcoding why?
      current_host += ':' + 3000.to_s
    end
    institute_url = InstituteUrl.find_by_url(current_host)
    if institute_url.nil?
      logger.info 'institute url is nil,redirecting'
      redirect_to (GyanV1::Application.config.landing_page.to_s)
    end
    return institute_url.institute_id
  end

  def get_current_institute
    #assuming that get_institute_id would redirect this to home page if the current url does not exists
    institute_id = get_institute_id
    #using find instead of find_by_id because this is supposed to throw exception
    institute = Institute.find(institute_id)
  end

  def get_teachers_for_institute
    teachers = []
    users = User.find(:all ,:conditions => {:institute_id => get_institute_id,:user_type => 'TEACHER'})
    logger.info users.inspect
    for user in users
      tmp = []
      tmp.push(user.email)
      tmp.push(user.id)
      teachers.push(tmp) 
    end
    logger.info teachers.inspect
    return teachers
  end

  def get_programs_hash_for_institute
    programs = []
    departments = Department.find(:all,:conditions => {:institute_id => get_institute_id})
    if !departments.nil?
      for department in departments
        
        if !department.programs.nil?
          for program in department.programs
            tmp = []
            program_description = department.name
            program_description += '-' + program.degree + '-' + program.branch
            tmp.push(program_description)
            tmp.push(program.id)

            programs.push(tmp)
          end
        end

      end
    end
    return programs
  end

  def get_all_courses_for_institute
    courses = Course.find(:all,:conditions => {:institute_id => get_institute_id})
    return courses
  end

  def get_all_courses_for_teacher
    teacher_id = session[:user_id]
    course_allocations = CourseAllocation.find(:all ,:conditions =>{:user_id => teacher_id})
    course_ids = []
    for course_allocation in course_allocations
      course_ids.push(course_allocation.course_id)
    end

    courses = Course.find(:all ,:conditions => {:id => course_ids})
    return courses
  end

  def get_all_courses_for_student
    courses = []
    student_program_detail =  StudentProgramDetail.find_by_student_id(session[:user_id])
    if !student_program_detail.nil?
      course_allocations = CourseAllocation.find(:all ,:conditions => {:program_id => student_program_detail.program_id,:term => student_program_detail.term})
      if !course_allocations.nil?
        course_ids = []
        for course_allocation in course_allocations
          course_ids.push(course_allocation.course_id)
        end
        courses = Course.find(:all,:conditions => {:id => course_ids})
        if courses.nil?
          courses = []
        end
      end
    end
    return  courses
  end

  def get_all_courses_for_user
    if session[:user_type] == 'ADMIN'
      return get_all_courses_for_institute
    elsif session[:user_type] == 'TEACHER'
      return get_all_courses_for_teacher
    elsif session[:user_type] == 'STUDENT'
      return get_all_courses_for_student
    end
  end

  def login_user(user)
    session[:user_institute_id] = user.institute_id
    session[:user_name] = user.username
    session[:user_type] = user.user_type
    session[:is_logged_in] = true
    session[:user_id] = user.id
  end

  def logout_user
    session[:user_institute_id] = nil
    session[:user_name] = nil
    session[:user_type] = nil
    session[:is_logged_in] = false
  end

  def is_logged_in
    if defined? session[:is_logged_in]
      return session[:is_logged_in]
    else
      session[:is_logged_in] = false 
      return session[:is_logged_in]
    end
  end

  def current_user
    return User.find(session[:user_id])
  end
  
  def upload_to_scribd(content_url)
    puts 'uploading to scribd'
    puts content_url
    require 'rubygems'
    require 'rscribd'

    # Use your API key / secret here
 
    api_key = '4txwgemkqbmavpeam3eas'
    api_secret = 'sec-46jrulbuqetj2squ1046miv9sg'
    # Create a scribd object
    Scribd::API.instance.key = api_key
    Scribd::API.instance.secret = api_secret
    url = 'public/' + content_url.to_s
    Scribd::User.login 'gauravtiwari5050', 'harekrsna1!'
    # Upload the document from a file
    puts "Uploading a document ... "

    doc = Scribd::Document.upload(:file => url)
    puts "Done doc_id=#{doc.id}, doc_access_key=#{doc.access_key}"

    # Poll API until conversion is complete
    #while (doc.conversion_status == 'PROCESSING')
    #  puts "Document conversion is processing"
    #  sleep(2) # Very important to sleep to prevent a runaway loop that will get your app blocked
    #end
    puts "Document conversion is complete"

    # Edit various options of the document
    # Note you can also edit options before your doc is done converting
    doc.title = 'This is a test doc!'
    doc.description = "final"
    doc.access = 'private'
    doc.language = 'en'
    doc.license = 'c'
    doc.tags = 'test,api'
    doc.show_ads = true
    doc.save
    return doc.id,doc.access_key
  rescue
    puts "couldnt upload to scribd"
    return nil,nil
  end

  #gets ids from an array of model objects
  def get_ids (model_objects)
    ids = []
    if !model_objects.nil?
      
      for model_object in model_objects
        ids.push(model_object.id)
      end
    end
    return ids

  end

  #validation of roles,also checks if user has logged in or not
  def validate_role(type)
  validation_success = false

  if defined? session[:user_type]
    if session[:user_type] == type
      validation_success = true
    end
  end

  if validation_success == false
      redirect_to (GyanV1::Application.config.landing_page.to_s)
  end
  end

  #validation of course access
  def validate_course_access(course_id)
  logger.info 'validating ' + course_id.to_s
  validation_success = false
  courses = get_ids(get_all_courses_for_user)
  logger.info 'courses are' + courses.inspect
  validation_success  = courses.include?(Integer(course_id))
  if validation_success == false
      redirect_to (GyanV1::Application.config.landing_page.to_s)
  end

  end
  
  def join_channel(bbb)
    username =  session[:user_name]
    type = session[:user_type]
    params = 'fullName='+username.delete(' ')
    params += '&'
    params += 'meetingID='+bbb.meeting_id
    params += '&'
    if type == 'STUDENT'
      params += 'password='+bbb.attendee_pw
    else
      params += 'password='+bbb.moderator_pw
    end

    logger.info 'JOIN CHANNEL PARAMS - ' + params

    checksum_input = 'join' + params + '77d3ed90b49520239acf9eb2dccd0a04'
    logger.info 'JOIN CHANNEL CHECKSUM INPUT - ' + checksum_input
    checksum = Digest::SHA1.hexdigest checksum_input
    logger.info 'JOIN CHANNEL CHECKSUM - ' + checksum
    join_url ='http://178.79.183.87/bigbluebutton/api/join?'+params+'&checksum='+checksum
    logger.info 'JOIN CHANNEL JOIN URL - ' + join_url
    return join_url
  end

  def join_collaboration(etherpad)
    url = 'http://'+etherpad.server+'/p/'+etherpad.name
    return url
  end
  
  def get_students_for_course(course_id)
   student_ids = []
   course_allocations = CourseAllocation.find(:all,:conditions =>{:course_id =>course_id})
   if !course_allocations.nil? 
    for course_allocation in course_allocations
      student_program_details = StudentProgramDetail.find(:all,:conditions => {:program_id => course_allocation.program_id,:term => course_allocation.term})

      if !student_program_details.nil?
        for student_program_detail in student_program_details
          student_ids.push(student_program_detail.student_id)
        end
      end

    end
   end

   users = User.find(:all,:conditions => {:id => student_ids})
   return users

  end

  def get_unassigned_students_for_course(course_id)
   unassigned_students = []
   students = get_students_for_course(course_id)
   if !students.nil?
    for student in students
      groups = student.course_groups
      if !groups.nil?
        #loops through all the student groups to find out whether ant groups exist for the given course
        exists = false
        for group in groups
          if group.course_id == course_id
            exists = true
            break
          end
        end
        
        if exists == false
          unassigned_students.push(student)
        end


      end
    end
   end

   return unassigned_students
   
  end

  def group_unassigned_students(course,unassigned_students,group_name)
    if !unassigned_students.nil?  
          course_group = CourseGroup.new
          course_group.course_id = course.id
          course_group.group_name = course.name + ' ' + (course.course_groups.count + 1).to_s
          if !group_name.nil?
            course_group.group_name = group_name
          end
          course_group.save

      for student in unassigned_students
          group_student = GroupStudent.new
          group_student.course_group_id = course_group.id
          group_student.user_id = student.id
          group_student.save
      end
    end
  end

  def group_unassigned_students_by_course_id(course_id)
    unassigned_students = get_unassigned_students_for_course(course_id)
    if !unassigned_students.nil?
      for student in unassigned_students
        assign_group_to_student(course_id,student) 
      end
    end 
  end

  def assign_group_to_student(course_id,student)

  course = Course.find(course_id)
  if course.nil?
    raise 'couldnt find a course with that id'
  end
  course_group = nil
  if !course.course_groups.nil?
    for group in course.course_groups
      if group.users.count < 5
        course_group = group
        break
      end
    end
  end

  if course_group.nil?
    course_group = CourseGroup.new
    course_group.course_id = course.id
    course_group.group_name = course.name + ' ' + (course.course_groups.count + 1).to_s
    course_group.save
  end

  group_student = GroupStudent.new
  group_student.course_group_id = course_group.id
  group_student.user_id = student.id
  group_student.save


  end

  def validate_program_access
    success =  false
    program = Program.find_by_id(params[:id])
    if !program.nil?
      department = program.department

      if !department.nil?
        if !department.institute_id.nil? && (department.institute_id == get_institute_id)
          success = true
        end
      end
    end

    if success == false
      logger.info 'Access denied to program'
      redirect_to (GyanV1::Application.config.landing_page.to_s)
    end
    
  end
  def get_user_by_user_id(user_id)
   user = User.find_by_id(user_id)
   return user
  end

  def get_students_for_department(department_id)
    department = Department.find(department_id)
    user_ids = []
    programs = department.programs
    if !programs.nil?
      for program in programs
       student_program_details = program.student_program_details
       if !student_program_details.nil? 
          for student_program_detail in student_program_details 
            user_ids.push(student_program_detail.student_id)
          end
       end
      
      end
    end

    students = User.find(:all,:conditions => {:id => user_ids})
    return students
  end

  def bulk_message(users,from_user)
    bulk_message_subj = params[:subject]
    bulk_message = params[:message]
    is_email = params[:email]
    is_sms = params[:sms]
    is_fb = params[:faceboook]
    is_twitter = params[:twitter]
    task =  create_new_task('BULK_MESSAGE','sending message to users',from_user.id,true)
    bulk_messaging_job = BulkMessagingJob.new(task,users,from_user,bulk_message_subj,bulk_message,is_email,is_sms,is_fb,is_twitter)
    Delayed::Job.enqueue(bulk_messaging_job)
    
  end
end
