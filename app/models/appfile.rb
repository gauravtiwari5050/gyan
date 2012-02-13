class Appfile < ActiveRecord::Base
  before_save :default_values
  def default_values
    self.status = 'UPLOADING' unless self.status
  end 
  attr_accessible :appfileable_id,:name,:content
  belongs_to :appfileable,:polymorphic => :true
  mount_uploader :content, FileUploader
  has_one :s3_object ,:as => :s3able,:dependent => :restrict
  has_one :scribd_file

  def as_json(options = {})
  {
   :id => self.id,
   :name => self.name,
   :content => self.content,
   :status => self.status || "",
   :scribd => self.scribd_file,
   :s3_object => self.s3_object
  }

  end
end
