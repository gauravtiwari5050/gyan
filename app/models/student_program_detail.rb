class StudentProgramDetail < ActiveRecord::Base
  #TODO rename student_id with user_id
  belongs_to :program
  validates :program,:presence => :true
  validates :term,:presence => :true,:numericality => :true
  
end
