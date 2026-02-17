require 'test_helper'

class ContratossecusersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratossecuser = contratossecusers(:one)
  end

  test "should get index" do
    get contratossecusers_url
    assert_response :success
  end

  test "should get new" do
    get new_contratossecuser_url
    assert_response :success
  end

  test "should create contratossecuser" do
    assert_difference('Contratossecuser.count') do
      post contratossecusers_url, params: { contratossecuser: { contratosseccion_id: @contratossecuser.contratosseccion_id, user_id: @contratossecuser.user_id } }
    end

    assert_redirected_to contratossecuser_url(Contratossecuser.last)
  end

  test "should show contratossecuser" do
    get contratossecuser_url(@contratossecuser)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratossecuser_url(@contratossecuser)
    assert_response :success
  end

  test "should update contratossecuser" do
    patch contratossecuser_url(@contratossecuser), params: { contratossecuser: { contratosseccion_id: @contratossecuser.contratosseccion_id, user_id: @contratossecuser.user_id } }
    assert_redirected_to contratossecuser_url(@contratossecuser)
  end

  test "should destroy contratossecuser" do
    assert_difference('Contratossecuser.count', -1) do
      delete contratossecuser_url(@contratossecuser)
    end

    assert_redirected_to contratossecusers_url
  end
end
