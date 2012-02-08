class Message < ActiveRecord::Base
  validates :unique_id ,:presence => :true
  validates :subject,:presence => :true
  validates :content,:presence => :true
  validates :from_user,:presence => :true,:numericality => :true
  validates :to_user,:presence => :true,:numericality => :true
end
