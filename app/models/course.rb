class Course < ActiveRecord::Base
  belongs_to :institute
  has_many :course_announcements
  has_many :assignments
  has_many :course_files
  has_one :bbb
  has_many :course_groups
end
