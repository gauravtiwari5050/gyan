class CourseGroup < ActiveRecord::Base
  belongs_to :course
  has_many :group_students ,:dependent => :destroy
  has_many :users, :through => :group_students ,:dependent => :destroy
  has_one :etherpad,:dependent => :destroy

  validates :course ,:presence => true
  validates :group_name ,:presence => true
end
