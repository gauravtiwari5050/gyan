class ContactDetail < ActiveRecord::Base
  belongs_to :user
  validates :user,:presence => true
  validates :address_1,:presence => true
  validates :city,:presence => true
  validates :state,:presence => true
  validates :phone,:presence => true,:numericality=> true,:length => {:is => 10}
end
