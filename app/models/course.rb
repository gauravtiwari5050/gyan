class Course < ActiveRecord::Base
  belongs_to :institute
  has_many :course_announcements,:dependent => :restrict
  has_many :assignments,:dependent => :restrict
  has_many :course_files,:dependent => :restrict
  has_one :bbb,:dependent => :restrict
  has_many :course_groups,:dependent => :restrict
  has_one :forum,:dependent => :restrict
  has_many :course_allocations ,:dependent => :restrict

  validates :institute,:presence => true
  validates :name,:presence => true
  validates :code,:presence => true

end
