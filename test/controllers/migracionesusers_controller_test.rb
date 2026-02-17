require 'test_helper'

class MigracionesusersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @migracionesuser = migracionesusers(:one)
  end

  test "should get index" do
    get migracionesusers_url
    assert_response :success
  end

  test "should get new" do
    get new_migracionesuser_url
    assert_response :success
  end

  test "should create migracionesuser" do
    assert_difference('Migracionesuser.count') do
      post migracionesusers_url, params: { migracionesuser: { migracion_id: @migracionesuser.migracion_id, user_id: @migracionesuser.user_id } }
    end

    assert_redirected_to migracionesuser_url(Migracionesuser.last)
  end

  test "should show migracionesuser" do
    get migracionesuser_url(@migracionesuser)
    assert_response :success
  end

  test "should get edit" do
    get edit_migracionesuser_url(@migracionesuser)
    assert_response :success
  end

  test "should update migracionesuser" do
    patch migracionesuser_url(@migracionesuser), params: { migracionesuser: { migracion_id: @migracionesuser.migracion_id, user_id: @migracionesuser.user_id } }
    assert_redirected_to migracionesuser_url(@migracionesuser)
  end

  test "should destroy migracionesuser" do
    assert_difference('Migracionesuser.count', -1) do
      delete migracionesuser_url(@migracionesuser)
    end

    assert_redirected_to migracionesusers_url
  end
end
