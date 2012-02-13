class Assignment < ActiveRecord::Base
  attr_accessible :course_id,:title,:detail,:total_marks,:assignment_file,:deadline,:appfile_attributes
  belongs_to :course
  mount_uploader :assignment_file, FileUploader
  has_many :assignment_solutions ,:dependent => :restrict
  has_one :appfile ,:as => :appfileable ,:dependent => :restrict

  validates :course,:presence => :true
  validates :title ,:presence => :true
  validates :total_marks ,:presence => :true,:numericality => true
  validates :deadline ,:presence => true

  accepts_nested_attributes_for :appfile   
end
