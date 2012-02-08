class Etherpad < ActiveRecord::Base
  belongs_to :course_group
  validates :course_group ,:presence => :true
  validates :name ,:presence => :true
  validates :server ,:presence => :true
end
