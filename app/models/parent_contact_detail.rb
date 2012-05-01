class ParentContactDetail < ActiveRecord::Base
  belongs_to :user
  validates :user,:presence => true
  validates :phone,:presence => true,:numericality=> true,:length => {:is => 10}

end
