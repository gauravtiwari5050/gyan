require 'test_helper'

class CalendarControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
  end

end
