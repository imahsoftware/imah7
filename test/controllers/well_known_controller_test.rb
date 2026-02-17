require 'test_helper'

class WellKnownControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get well_known_index_url
    assert_response :success
  end

end
