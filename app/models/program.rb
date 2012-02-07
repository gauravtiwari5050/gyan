class Program < ActiveRecord::Base
  TERM_TYPE_OPTIONS = %w(SEMESTER YEAR)
  belongs_to :department
  has_many :student_program_details ,:dependent => :restrict
  validates :department ,:presence => true
  validates :term_type ,:presence => true, :inclusion => {:in => TERM_TYPE_OPTIONS}
  validates :total_terms ,:presence => true,:numericality => {:only_integer => true,:greater_than => 0, :less_than_or_equal_to => 8}
end
