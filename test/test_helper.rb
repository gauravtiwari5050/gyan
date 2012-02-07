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
end
