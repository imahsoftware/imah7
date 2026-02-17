require 'test_helper'

class ContratossoleppsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratossolepp = contratossolepps(:one)
  end

  test "should get index" do
    get contratossolepps_url
    assert_response :success
  end

  test "should get new" do
    get new_contratossolepp_url
    assert_response :success
  end

  test "should create contratossolepp" do
    assert_difference('Contratossolepp.count') do
      post contratossolepps_url, params: { contratossolepp: { contrato_id: @contratossolepp.contrato_id, estado: @contratossolepp.estado, user_id: @contratossolepp.user_id } }
    end

    assert_redirected_to contratossolepp_url(Contratossolepp.last)
  end

  test "should show contratossolepp" do
    get contratossolepp_url(@contratossolepp)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratossolepp_url(@contratossolepp)
    assert_response :success
  end

  test "should update contratossolepp" do
    patch contratossolepp_url(@contratossolepp), params: { contratossolepp: { contrato_id: @contratossolepp.contrato_id, estado: @contratossolepp.estado, user_id: @contratossolepp.user_id } }
    assert_redirected_to contratossolepp_url(@contratossolepp)
  end

  test "should destroy contratossolepp" do
    assert_difference('Contratossolepp.count', -1) do
      delete contratossolepp_url(@contratossolepp)
    end

    assert_redirected_to contratossolepps_url
  end
end
