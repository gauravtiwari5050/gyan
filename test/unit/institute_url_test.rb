require 'test_helper'

class InstituteUrlTest < ActiveSupport::TestCase
  
  test "should not save a blank institute url" do
    institute_url =  InstituteUrl.new
    assert !institute_url.save
  end

  test "uniqueness of url should be satisfied" do
    institute_url = InstituteUrl.new
    institute = institutes(:one)
    institute_url.institute_id = institute.id
    institute_url.url = "url"
    assert institute_url.save

    institute_url_1 = InstituteUrl.new
    institute_url_1.institute_id = institute.id
    institute_url_1.url = "url"
    
    assert_raise(ActiveRecord::StatementInvalid) {
      institute_url_1.save
    }
  end

  test "validates presence of corresponding institute" do
    institute_url = InstituteUrl.new
    institute_url.institute_id = 999
    institute_url.url = "url_999"
    assert !institute_url.save
  end


end
