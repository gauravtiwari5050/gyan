class Bbb < ActiveRecord::Base
  STATUS_TYPE_OPTIONS = %w(CREATING,RUNNING,OFFLINE)
  belongs_to :course
  validates :course,:presence => true
  validates :name ,:presence => true
  validates :meeting_id,:presence => true
  validates :attendee_pw,:presence => true
  validates :moderator_pw,:presence => true
end
