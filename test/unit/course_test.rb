require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "disallow blank object creation" do
    course = Course.new
    assert !course.save
  end

  test "presence of corresponding institute" do
    course = get_new_course(999,"course","about course","code_999")  
    assert !course.save
  end

  test "uniqueness of code" do
    course = get_new_course(institutes(:one).id,"course","about course",courses(:one).code)  
    assert_raise(ActiveRecord::StatementInvalid) {
      course.save
    }
  end

  test "disallow object deletion if dependents are present" do
    #TODO tests only with dependency to course allocation,add others also here
    course = get_new_course(institutes(:one).id,"course","about course","code new")  
    assert course.save,course.inspect
    
    course_allocation = get_new_course_allocation(course.id,programs(:one).id,4,users(:one).id)
    assert course_allocation.save, course_allocation.inspect

    assert_raise(ActiveRecord::DeleteRestrictionError) {
      course.destroy 
    }

    assert course_allocation.destroy
    
    assert course.destroy
    
  end
end
