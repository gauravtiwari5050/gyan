class S3Object < ActiveRecord::Base
  attr_accessible :key,:url,:bucket
  belongs_to :s3able ,:polymorphic => true
end
