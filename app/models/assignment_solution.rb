class AssignmentSolution < ActiveRecord::Base
  attr_accessible :assignment_id,:user_id,:content,:file,:marks,:appfile_attributes
  mount_uploader :file, FileUploader
  has_one :appfile ,:as => :appfileable ,:dependent => :restrict
  belongs_to :assignment
  belongs_to :user
  validates :assignment ,:presence => true
  validates :user,:presence => true
  validates :content,:presence => true,:length => {:minimum => 2}
  accepts_nested_attributes_for :appfile   
end
