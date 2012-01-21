class Institute < ActiveRecord::Base
  has_many :institute_urls
  has_many :users
  has_many :courses
end
