class AssignmentController < ApplicationController
  before_filter :validate_institute_url,:validate_logged_in_status
  #validate access to this assignment TODO
  def home
    
  end

end
