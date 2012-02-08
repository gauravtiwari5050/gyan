class S3Object < ActiveRecord::Base
  #TODO polymorphic validates existence
  attr_accessible :key,:url,:bucket
  belongs_to :s3able ,:polymorphic => true
  validates :bucket ,:presence => true
  validates :key ,:presence => true
  validates :url ,:presence => true

end
