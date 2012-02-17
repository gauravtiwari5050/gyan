class User < ActiveRecord::Base
  USER_TYPE_OPTIONS = %w(ADMIN TEACHER STUDENT)
  belongs_to :institute
  has_many :assignment_solutions,:dependent => :restrict
  has_many :group_students,:dependent => :restrict
  has_many :course_groups , :through => :group_students ,:dependent => :restrict
  has_many :topics,:dependent => :restrict
  has_one :contact_detail,:dependent => :restrict

  validates :institute,:presence => true
  validates :email ,:presence => true
  validates :user_type ,:presence => true,:inclusion => {:in => USER_TYPE_OPTIONS}
  validates_format_of :email, :with => /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i

  before_save :default_values

  def default_values
    self.username =  self.email unless self.username
  end

end
