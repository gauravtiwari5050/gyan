class Forum < ActiveRecord::Base
  belongs_to :course
  has_many :topics,:dependent => :restrict
  validates :course,:presence => :true
  validates :name ,:presence => :true
  validates :description,:presence => :true
end
