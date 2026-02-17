require 'test_helper'

class IparametrosusersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @iparametrosuser = iparametrosusers(:one)
  end

  test "should get index" do
    get iparametrosusers_url
    assert_response :success
  end

  test "should get new" do
    get new_iparametrosuser_url
    assert_response :success
  end

  test "should create iparametrosuser" do
    assert_difference('Iparametrosuser.count') do
      post iparametrosusers_url, params: { iparametrosuser: { iparametro_id: @iparametrosuser.iparametro_id, user_id: @iparametrosuser.user_id } }
    end

    assert_redirected_to iparametrosuser_url(Iparametrosuser.last)
  end

  test "should show iparametrosuser" do
    get iparametrosuser_url(@iparametrosuser)
    assert_response :success
  end

  test "should get edit" do
    get edit_iparametrosuser_url(@iparametrosuser)
    assert_response :success
  end

  test "should update iparametrosuser" do
    patch iparametrosuser_url(@iparametrosuser), params: { iparametrosuser: { iparametro_id: @iparametrosuser.iparametro_id, user_id: @iparametrosuser.user_id } }
    assert_redirected_to iparametrosuser_url(@iparametrosuser)
  end

  test "should destroy iparametrosuser" do
    assert_difference('Iparametrosuser.count', -1) do
      delete iparametrosuser_url(@iparametrosuser)
    end

    assert_redirected_to iparametrosusers_url
  end
end
