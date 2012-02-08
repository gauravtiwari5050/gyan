require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase
  test "disallow blank object creation" do
    assignment = Assignment.new
    assert !assignment.save
  end
end
