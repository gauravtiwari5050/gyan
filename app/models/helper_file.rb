class HelperFile < ActiveRecord::Base
  attr_accessible :file
  mount_uploader :file, FileUploader
  validates :file,:presence => :true
end
