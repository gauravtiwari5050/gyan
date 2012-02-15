class Department < ActiveRecord::Base
  has_many :programs ,:dependent => :restrict
  belongs_to :institute
  has_many :announcements,:as => :announcable ,:dependent => :destroy

  validates :institute ,:presence => true
  validates :name ,:presence => true
  validates :about ,:presence => true

end
