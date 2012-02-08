class IvrsInfo < ActiveRecord::Base
  belongs_to :institute
  validates :institute,:presence => :true
  validates :message,:presence => :true
end
