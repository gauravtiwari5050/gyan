class User < ActiveRecord::Base
  USER_TYPE_OPTIONS = %w(ADMIN TEACHER STUDENT)
  belongs_to :institute
  has_many :assignment_solutions,:dependent => :restrict
  has_many :group_students,:dependent => :restrict
  has_many :course_groups , :through => :group_students ,:dependent => :restrict
  has_many :topics,:dependent => :restrict
  has_one :contact_detail,:dependent => :restrict

  validates :institute,:presence => true
  validates :username ,:presence => true
  validates :email ,:presence => true
  validates :user_type ,:presence => true,:inclusion => {:in => USER_TYPE_OPTIONS}

end
