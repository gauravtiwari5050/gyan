class Topic < ActiveRecord::Base
  belongs_to :forum
  belongs_to :user
  has_many :posts,:dependent => :restrict
  validates :forum,:presence => :true
  validates :user,:presence => :true
  validates :title,:presence => :true
  validates :description,:presence => :true
end
