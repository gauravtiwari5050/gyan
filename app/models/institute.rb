class Institute < ActiveRecord::Base
  #relations
  has_many :users ,:dependent => :restrict
  has_many :courses,:dependent => :restrict
  has_many :sc_classes ,:dependent => :destroy
  has_one :institute_url , :dependent => :restrict
  has_one :ivrs_info , :dependent => :restrict

  #validations
  validates :code ,:presence => true
  validates :name ,:presence => true
end
