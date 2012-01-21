class CourseFile < ActiveRecord::Base
  attr_accessible :course_id,:name,:content
  belongs_to :course
  mount_uploader :content, FileUploader
end
