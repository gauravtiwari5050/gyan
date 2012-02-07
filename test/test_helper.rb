ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def get_new_department(institute_id,name,about)
    department = Department.new
    department.name = name
    department.about = about
    department.institute_id =  institute_id
    return department
  end

  def get_new_program(department_id,term_type,total_terms,branch,degree)
    program = Program.new
    program.department_id = department_id
    program.term_type = term_type
    program.total_terms = total_terms
    program.branch = branch
    program.degree =  degree
    return program
  end

  def get_new_student_program_detail(student_id,program_id,term)
    student_program_detail = StudentProgramDetail.new
    student_program_detail.student_id = student_id
    student_program_detail.program_id = program_id
    student_program_detail.term = term
    return student_program_detail
  end

  def get_new_course_allocation(course_id,program_id,term,user)
    course_allocation = CourseAllocation.new
    course_allocation.course_id = course_id
    course_allocation.program_id = program_id
    course_allocation.term = term
    course_allocation.user_id = user
    return course_allocation
  end

  def get_new_course(institute_id,name,about,code)
    course = Course.new
    course.institute_id = institute_id
    course.name = name
    course.code = code
    course.about = about
    return course
  end

  def get_new_user(institute_id,username,email,password_crypt,user_type)
    user = User.new
    user.institute_id = institute_id
    user.username = username
    user.password_crypt = password_crypt
    user.user_type = user_type
    user.email = email
    return user
  end

  def get_new_contact_detail(user_id,address_1,address_2,address_3,city,state,phone)
    contact_detail = ContactDetail.new
    contact_detail.user_id = user_id
    contact_detail.address_1 = address_1
    contact_detail.address_2 = address_2
    contact_detail.address_3 = address_3
    contact_detail.city = city
    contact_detail.state = state
    contact_detail.phone = phone
    return contact_detail
  end
end
