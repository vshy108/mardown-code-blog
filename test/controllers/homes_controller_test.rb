require 'test_helper'

class HomesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_0 = users(:user_0)
  end

  test "should get index" do
    sign_in @user_0
    get homes_index_url
    assert_response :success
  end
end
