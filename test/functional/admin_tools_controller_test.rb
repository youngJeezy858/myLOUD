require 'test_helper'

class AdminToolsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
