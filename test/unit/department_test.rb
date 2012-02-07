require 'test_helper'

class DepartmentTest < ActiveSupport::TestCase
  
  test "shoud not allow blank department to be saved" do
    department  = Department.new
    assert !department.save
  end
  
  test "should check the presence of corresponding institute" do
    department = get_new_department(1,"department","about")
    department.institute_id = 999 #no existent institute
    assert !department.save
  end

  test "destroy department should fail if dependent object is present" do 
    department =  get_new_department(institutes(:one).id,"department","about")
    assert department.save
    program =  get_new_program(department.id,"SEMESTER",8,"Computer Science and Engineering","Bachelor of Technology")
    assert program.save

    assert_raise(ActiveRecord::DeleteRestrictionError) {
      department.destroy 
    }
  end

end
