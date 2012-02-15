class Announcement < ActiveRecord::Base
  attr_accessible :announcable_id,:title,:content
  belongs_to :announcable ,:polymorphic => :true
  belongs_to :user
  validates :title ,:presence => :true
  validates :content,:presence => :true
  validates :announcable_id ,:presence => :true
  validates :announcable_type ,:presence => :true

end
