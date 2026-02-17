require 'test_helper'

class VeriserviciosusersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @veriserviciosuser = veriserviciosusers(:one)
  end

  test "should get index" do
    get veriserviciosusers_url
    assert_response :success
  end

  test "should get new" do
    get new_veriserviciosuser_url
    assert_response :success
  end

  test "should create veriserviciosuser" do
    assert_difference('Veriserviciosuser.count') do
      post veriserviciosusers_url, params: { veriserviciosuser: { user_id: @veriserviciosuser.user_id, veriservicio_id: @veriserviciosuser.veriservicio_id } }
    end

    assert_redirected_to veriserviciosuser_url(Veriserviciosuser.last)
  end

  test "should show veriserviciosuser" do
    get veriserviciosuser_url(@veriserviciosuser)
    assert_response :success
  end

  test "should get edit" do
    get edit_veriserviciosuser_url(@veriserviciosuser)
    assert_response :success
  end

  test "should update veriserviciosuser" do
    patch veriserviciosuser_url(@veriserviciosuser), params: { veriserviciosuser: { user_id: @veriserviciosuser.user_id, veriservicio_id: @veriserviciosuser.veriservicio_id } }
    assert_redirected_to veriserviciosuser_url(@veriserviciosuser)
  end

  test "should destroy veriserviciosuser" do
    assert_difference('Veriserviciosuser.count', -1) do
      delete veriserviciosuser_url(@veriserviciosuser)
    end

    assert_redirected_to veriserviciosusers_url
  end
end
