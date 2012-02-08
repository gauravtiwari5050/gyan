class Bbb < ActiveRecord::Base
  STATUS_TYPE_OPTIONS = %w(NOT_CREATED,RUNNING,OFFLINE)
  belongs_to :course
  validates :course,:presence => true
  validates :name ,:presence => true
  validates :meeting_id,:presence => true
  validates :attendee_pw,:presence => true
  validates :moderator_pw,:presence => true
  validates :status,:presence => true ,:inclusion => {:in => STATUS_TYPE_OPTIONS}
end
