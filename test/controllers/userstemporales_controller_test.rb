require 'test_helper'

class UserstemporalesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @userstemporal = userstemporales(:one)
  end

  test "should get index" do
    get userstemporales_url
    assert_response :success
  end

  test "should get new" do
    get new_userstemporal_url
    assert_response :success
  end

  test "should create userstemporal" do
    assert_difference('Userstemporal.count') do
      post userstemporales_url, params: { userstemporal: { celular: @userstemporal.celular, email: @userstemporal.email, identificacion: @userstemporal.identificacion, nombre: @userstemporal.nombre, user_id: @userstemporal.user_id } }
    end

    assert_redirected_to userstemporal_url(Userstemporal.last)
  end

  test "should show userstemporal" do
    get userstemporal_url(@userstemporal)
    assert_response :success
  end

  test "should get edit" do
    get edit_userstemporal_url(@userstemporal)
    assert_response :success
  end

  test "should update userstemporal" do
    patch userstemporal_url(@userstemporal), params: { userstemporal: { celular: @userstemporal.celular, email: @userstemporal.email, identificacion: @userstemporal.identificacion, nombre: @userstemporal.nombre, user_id: @userstemporal.user_id } }
    assert_redirected_to userstemporal_url(@userstemporal)
  end

  test "should destroy userstemporal" do
    assert_difference('Userstemporal.count', -1) do
      delete userstemporal_url(@userstemporal)
    end

    assert_redirected_to userstemporales_url
  end
end
