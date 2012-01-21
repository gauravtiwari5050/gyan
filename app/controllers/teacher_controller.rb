class TeacherController < ApplicationController
  before_filter :validate_institute_url
  before_filter {|role| role.validate_role 'TEACHER'}
  
  def home
  end

end
