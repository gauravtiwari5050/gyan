class CourseGroup < ActiveRecord::Base
  belongs_to :course
  has_many :group_students ,:dependent => :restrict
  has_many :users, :through => :group_students ,:dependent => :restrict
  has_one :etherpad,:dependent => :restrict

  validates :course ,:presence => true
  validates :group_name ,:presence => true
end
