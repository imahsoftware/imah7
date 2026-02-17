require 'test_helper'

class UsersreportesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @usersreporte = usersreportes(:one)
  end

  test "should get index" do
    get usersreportes_url
    assert_response :success
  end

  test "should get new" do
    get new_usersreporte_url
    assert_response :success
  end

  test "should create usersreporte" do
    assert_difference('Usersreporte.count') do
      post usersreportes_url, params: { usersreporte: { infgrupo_id: @usersreporte.infgrupo_id, user_id: @usersreporte.user_id } }
    end

    assert_redirected_to usersreporte_url(Usersreporte.last)
  end

  test "should show usersreporte" do
    get usersreporte_url(@usersreporte)
    assert_response :success
  end

  test "should get edit" do
    get edit_usersreporte_url(@usersreporte)
    assert_response :success
  end

  test "should update usersreporte" do
    patch usersreporte_url(@usersreporte), params: { usersreporte: { infgrupo_id: @usersreporte.infgrupo_id, user_id: @usersreporte.user_id } }
    assert_redirected_to usersreporte_url(@usersreporte)
  end

  test "should destroy usersreporte" do
    assert_difference('Usersreporte.count', -1) do
      delete usersreporte_url(@usersreporte)
    end

    assert_redirected_to usersreportes_url
  end
end
