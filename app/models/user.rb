class User < ActiveRecord::Base
  belongs_to :institute
  has_many :assignment_solutions
  has_many :group_students
  has_many :course_groups , :through => :group_students
  has_many :topics
  has_one :contact_detail
end
