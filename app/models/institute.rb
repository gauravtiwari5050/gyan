class Institute < ActiveRecord::Base
  has_many :users
  has_many :courses
  has_one :institute_url
  has_one :ivrs_info
end
