require 'test_helper'

class UsersvehiculosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @usersvehiculo = usersvehiculos(:one)
  end

  test "should get index" do
    get usersvehiculos_url
    assert_response :success
  end

  test "should get new" do
    get new_usersvehiculo_url
    assert_response :success
  end

  test "should create usersvehiculo" do
    assert_difference('Usersvehiculo.count') do
      post usersvehiculos_url, params: { usersvehiculo: { portafoliosvehiculo_id: @usersvehiculo.portafoliosvehiculo_id, user_id: @usersvehiculo.user_id } }
    end

    assert_redirected_to usersvehiculo_url(Usersvehiculo.last)
  end

  test "should show usersvehiculo" do
    get usersvehiculo_url(@usersvehiculo)
    assert_response :success
  end

  test "should get edit" do
    get edit_usersvehiculo_url(@usersvehiculo)
    assert_response :success
  end

  test "should update usersvehiculo" do
    patch usersvehiculo_url(@usersvehiculo), params: { usersvehiculo: { portafoliosvehiculo_id: @usersvehiculo.portafoliosvehiculo_id, user_id: @usersvehiculo.user_id } }
    assert_redirected_to usersvehiculo_url(@usersvehiculo)
  end

  test "should destroy usersvehiculo" do
    assert_difference('Usersvehiculo.count', -1) do
      delete usersvehiculo_url(@usersvehiculo)
    end

    assert_redirected_to usersvehiculos_url
  end
end
