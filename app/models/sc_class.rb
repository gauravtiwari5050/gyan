class ScClass < ActiveRecord::Base
  belongs_to :institute
  has_many :sc_sections,:dependent => :destroy
  accepts_nested_attributes_for :sc_sections,:reject_if => lambda { |a| a[:name].blank? }
end
