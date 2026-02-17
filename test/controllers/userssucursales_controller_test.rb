require 'test_helper'

class UserssucursalesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @userssucursal = userssucursales(:one)
  end

  test "should get index" do
    get userssucursales_url
    assert_response :success
  end

  test "should get new" do
    get new_userssucursal_url
    assert_response :success
  end

  test "should create userssucursal" do
    assert_difference('Userssucursal.count') do
      post userssucursales_url, params: { userssucursal: { portafoliossucursal_id: @userssucursal.portafoliossucursal_id, user_id: @userssucursal.user_id } }
    end

    assert_redirected_to userssucursal_url(Userssucursal.last)
  end

  test "should show userssucursal" do
    get userssucursal_url(@userssucursal)
    assert_response :success
  end

  test "should get edit" do
    get edit_userssucursal_url(@userssucursal)
    assert_response :success
  end

  test "should update userssucursal" do
    patch userssucursal_url(@userssucursal), params: { userssucursal: { portafoliossucursal_id: @userssucursal.portafoliossucursal_id, user_id: @userssucursal.user_id } }
    assert_redirected_to userssucursal_url(@userssucursal)
  end

  test "should destroy userssucursal" do
    assert_difference('Userssucursal.count', -1) do
      delete userssucursal_url(@userssucursal)
    end

    assert_redirected_to userssucursales_url
  end
end
