require 'test_helper'

class UsersactivosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get usersactivos_index_url
    assert_response :success
  end

end
