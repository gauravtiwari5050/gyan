require 'test_helper'

class ProgramTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "disallow blank program" do
    program = Program.new
    assert !program.save
  end
  
  test "validate term type" do
    program =  get_new_program(departments(:one).id,"BAD_TYPE",8,"Computer Science","BTech")
    assert !program.save
  end

  test "validate total terms" do
    program =  get_new_program(departments(:one).id,"SEMESTER",9,"Computer Science","BTech")
    assert !program.save
    program.total_terms = 0
    assert !program.save
    program.total_terms = 7
    assert program.save
  end

  test "presence of corresponding department" do
    program =  get_new_program(999,"SEMESTER",5,"Computer Science","BTech")
    assert !program.save
    program.department_id = departments(:one).id
    assert program.save
  end

  test "disallow object deletion if dependents are present" do
    program =  get_new_program(departments(:one).id,"SEMESTER",5,"Computer Science","BTech")
    assert program.save

    student_program_detail = get_new_student_program_detail(1,program.id,4)
    assert student_program_detail.save

    course_allocation = get_new_course_allocation(courses(:one).id,program.id,4,1)
    assert course_allocation.save


    assert_raise(ActiveRecord::DeleteRestrictionError) {
      program.destroy 
    }

    assert student_program_detail.destroy
    
    assert_raise(ActiveRecord::DeleteRestrictionError) {
      program.destroy 
    }

    assert course_allocation.destroy

    assert program.destroy

  end


end
