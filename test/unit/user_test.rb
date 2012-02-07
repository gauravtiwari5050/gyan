require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "shoud not allow blank department to be saved" do
    user  = User.new
    assert !user.save
  end


  test "should check the presence of corresponding institute" do
    user = get_new_user(999,"username","random@random.com","pass_crypt","STUDENT")
    assert !user.save,user.inspect
  end
  
  test "validate user type" do
    user = get_new_user(institutes(:one).id,"username","random@random.com","pass_crypt","BAD_TYPE")
    assert !user.save,user.inspect
    user.user_type = 'ADMIN'
    assert user.save,user.inspect
  end

  test "uniquness of email" do
    user = get_new_user(institutes(:one).id,"username",users(:one).email,"pass_crypt","ADMIN")
    assert_raise(ActiveRecord::StatementInvalid) {
      user.save
    }
  end

  test "disallow user deletion if dependent objects are present" do
    #validates dependency before destruction only for contact details
    user = get_new_user(institutes(:one).id,"username","random@random.com","pass_crypt","ADMIN")
    assert user.save
    
    contact_detail = get_new_contact_detail(user.id,"address1","address2","address3","city","state",12345)
    assert contact_detail.save

    assert_raise(ActiveRecord::DeleteRestrictionError) {
      user.destroy 
    }
    
    #deleting contact detail is not working somehow ? TODO
    #assert user.contact_detail.destroy

    #assert user.contact_detail.nil?,user.inspect + ' ,\n ' + user.contact_detail.inspect  

    #assert user.destroy
    
  end


end
