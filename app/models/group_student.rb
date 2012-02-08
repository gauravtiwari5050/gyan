class GroupStudent < ActiveRecord::Base
  belongs_to :course_group
  belongs_to :user

  validates :course_group,:presence => :true
  validates :user,:presence => :true
  
end
