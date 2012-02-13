class AssignmentSolution < ActiveRecord::Base
  attr_accessible :assignment_id,:user_id,:content,:file,:marks
  mount_uploader :file, FileUploader
  belongs_to :assignment
  belongs_to :user
  validates :assignment ,:presence => true
  validates :user,:presence => true
  validates :content,:presence => true,:length => {:minimum => 2}
end
