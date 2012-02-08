class CourseAllocation < ActiveRecord::Base
  belongs_to :course
  belongs_to :program

  validates :course ,:presence => :true
  validates :program ,:presence => :true
  validates :term ,:presence => :true ,:numericality => :true
end
