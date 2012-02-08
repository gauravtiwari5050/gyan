class CourseAnnouncement < ActiveRecord::Base
  belongs_to :course
  validates :course,:presence => true
  validates :title,:presence => true
  validates :details,:presence => true
end
