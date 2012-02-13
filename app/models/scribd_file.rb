class ScribdFile < ActiveRecord::Base
  belongs_to :appfile
  validates :appfile ,:presence => true
  validates :scribd_id,:presence => true
  validates :scribd_key,:presence => true
end
