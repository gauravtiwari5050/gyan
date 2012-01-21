class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :get_all_courses_for_institute,:get_all_courses_for_teacher,:get_all_courses_for_user,:get_home_for_user,:get_user_type,:get_programs_hash_for_institute

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
    # TODO remove dependency on request port
    # add another function to validate url for logged in user
    current_host = request.host
    if !Rails.env.production?
      current_host += ':' + request.port.to_s
    end
    institute_url = InstituteUrl.find_by_url(current_host)
    if institute_url.nil?
      redirect_to (GyanV1::Application.config.landing_page.to_s)
    end

  end
  def get_user_type
    return session[:user_type]
  end

  def get_home_for_user
    #TODO what if user type is something else
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
    #will throw excpetion if institute url is null
    #should be called only if url is valid
    #bad TODO change this 
    institute_url = InstituteUrl.find_by_url(request.host+':'+request.port.to_s)
    return institute_url.institute_id
  end

  def get_teachers_for_institute
    teachers = []
    users = User.find(:all ,:conditions => {:institute_id => get_institute_id,:user_type => 'TEACHER'})
    for user in users
      tmp = []
      tmp.push(user.email)
      tmp.push(user.id)
      teachers.push(tmp) 
    end
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
    #TODO add stuff for student user here
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

end
