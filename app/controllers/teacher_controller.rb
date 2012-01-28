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

end
