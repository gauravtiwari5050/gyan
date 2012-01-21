class User < ActiveRecord::Base
  belongs_to :institute
  has_many :assignment_solutions
end
