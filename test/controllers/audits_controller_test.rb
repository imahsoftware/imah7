require 'test_helper'

class AuditsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get audits_index_url
    assert_response :success
  end

  test "should get show" do
    get audits_show_url
    assert_response :success
  end

end
