class Assignment < ActiveRecord::Base
  attr_accessible :course_id,:title,:detail,:total_marks,:assignment_file,:deadline
  belongs_to :course
  mount_uploader :assignment_file, FileUploader
  has_many :assignment_solutions
  has_one :s3object ,:as => :s3able
end
