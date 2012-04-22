class SchoolController < ApplicationController
  before_filter :validate_institute_url,:validate_logged_in_status
  def home
  end

  def users_index
  end

  def manage_classes
    institute_id = get_institute_id
    @institute = Institute.find_by_id(institute_id)
  end

  def class_new
    @sc_class = ScClass.new
    3.times { @sc_class.sc_sections.build }
  end

  def class_create
    
   logger.info params[:sc_class]
   sc_class =  ScClass.new(params[:sc_class])
   sc_class.institute_id = get_institute_id
   sc_class.save
   respond_to do |format|
    format.html{redirect_to '/school/manage/classes'}
   end
  end

end
