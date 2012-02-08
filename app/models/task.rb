class Task < ActiveRecord::Base
  belongs_to :user
  validates :user ,:presence => :true
  validates :task_type ,:presence => :true
end
