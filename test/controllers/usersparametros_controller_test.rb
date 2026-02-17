require 'test_helper'

class UsersparametrosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @usersparametro = usersparametros(:one)
  end

  test "should get index" do
    get usersparametros_url
    assert_response :success
  end

  test "should get new" do
    get new_usersparametro_url
    assert_response :success
  end

  test "should create usersparametro" do
    assert_difference('Usersparametro.count') do
      post usersparametros_url, params: { usersparametro: { campo: @usersparametro.campo, user_id: @usersparametro.user_id } }
    end

    assert_redirected_to usersparametro_url(Usersparametro.last)
  end

  test "should show usersparametro" do
    get usersparametro_url(@usersparametro)
    assert_response :success
  end

  test "should get edit" do
    get edit_usersparametro_url(@usersparametro)
    assert_response :success
  end

  test "should update usersparametro" do
    patch usersparametro_url(@usersparametro), params: { usersparametro: { campo: @usersparametro.campo, user_id: @usersparametro.user_id } }
    assert_redirected_to usersparametro_url(@usersparametro)
  end

  test "should destroy usersparametro" do
    assert_difference('Usersparametro.count', -1) do
      delete usersparametro_url(@usersparametro)
    end

    assert_redirected_to usersparametros_url
  end
end
