class Assignment < ActiveRecord::Base
  attr_accessible :course_id,:title,:detail,:total_marks,:assignment_file,:deadline
  belongs_to :course
  mount_uploader :assignment_file, FileUploader
  has_many :assignment_solutions ,:dependent => :restrict
  has_one :s3object ,:as => :s3able ,:dependent => :restrict

  validates :course,:presence => :true
  validates :title ,:presence => :true
  validates :total_marks ,:presence => :true,:numericality => true
  validates :deadline ,:presence => true
end
