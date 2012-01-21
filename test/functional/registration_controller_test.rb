require 'test_helper'

class RegistrationControllerTest < ActionController::TestCase
  test "should get teacher_new" do
    get :teacher_new
    assert_response :success
  end

end
