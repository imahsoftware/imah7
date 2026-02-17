require 'test_helper'

class UsersvisitasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @usersvisita = usersvisitas(:one)
  end

  test "should get index" do
    get usersvisitas_url
    assert_response :success
  end

  test "should get new" do
    get new_usersvisita_url
    assert_response :success
  end

  test "should create usersvisita" do
    assert_difference('Usersvisita.count') do
      post usersvisitas_url, params: { usersvisita: { user_asignado: @usersvisita.user_asignado, user_id: @usersvisita.user_id } }
    end

    assert_redirected_to usersvisita_url(Usersvisita.last)
  end

  test "should show usersvisita" do
    get usersvisita_url(@usersvisita)
    assert_response :success
  end

  test "should get edit" do
    get edit_usersvisita_url(@usersvisita)
    assert_response :success
  end

  test "should update usersvisita" do
    patch usersvisita_url(@usersvisita), params: { usersvisita: { user_asignado: @usersvisita.user_asignado, user_id: @usersvisita.user_id } }
    assert_redirected_to usersvisita_url(@usersvisita)
  end

  test "should destroy usersvisita" do
    assert_difference('Usersvisita.count', -1) do
      delete usersvisita_url(@usersvisita)
    end

    assert_redirected_to usersvisitas_url
  end
end
