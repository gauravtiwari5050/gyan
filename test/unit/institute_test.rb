require 'test_helper'

class InstituteTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "should not save a blank institute" do
    institute = Institute.new
    assert !institute.save

    institute.code = "code"
    assert !institute.save

    institute.name = "name"
    assert institute.save

  end

  test "should throw an exception if code is repeated" do
    institute = Institute.new
    institute.code = "code1"
    institute.name = "name1"

    institute.save
    
    institute_1 = Institute.new
    institute_1.code = "code1"
    institute_1.name = "name2"
    
    assert_raise(ActiveRecord::StatementInvalid) {
      institute_1.save
    }

  end

  test "should not allow a institute to be deleted if dependent entities are present" do
    institute = Institute.new
    institute.code = "code1"
    institute.name = "name1"
    institute.save

    #create one dependent entity institute url in this case
    institute_url = InstituteUrl.new
    institute_url.institute_id = institute.id
    institute_url.url = "random url"

    institute_url.save

    #we should not be able to destroy institute_url
    assert_raise(ActiveRecord::DeleteRestrictionError) { 
      institute.destroy
    }


    
  end
end
