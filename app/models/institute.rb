class Institute < ActiveRecord::Base
  has_many :users
  has_many :courses
  has_one :institute_url
end
