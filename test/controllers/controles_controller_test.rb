require 'test_helper'

class ControlesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get controles_index_url
    assert_response :success
  end

end
