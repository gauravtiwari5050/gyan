class CourseGroup < ActiveRecord::Base
  belongs_to :course
  has_many :group_students
  has_many :users, :through => :group_students
  has_one :etherpad
end
