class InstituteUrl < ActiveRecord::Base
  belongs_to :institute

  validates :institute_id ,:presence => true
  validates :url , :presence => true
  validates :institute ,:presence => true
end
