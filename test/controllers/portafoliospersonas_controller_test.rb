require 'test_helper'

class PortafoliospersonasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @portafoliospersona = portafoliospersonas(:one)
  end

  test "should get index" do
    get portafoliospersonas_url
    assert_response :success
  end

  test "should get new" do
    get new_portafoliospersona_url
    assert_response :success
  end

  test "should create portafoliospersona" do
    assert_difference('Portafoliospersona.count') do
      post portafoliospersonas_url, params: { portafoliospersona: { persona_id: @portafoliospersona.persona_id, portafolio_id: @portafoliospersona.portafolio_id, user_id: @portafoliospersona.user_id } }
    end

    assert_redirected_to portafoliospersona_url(Portafoliospersona.last)
  end

  test "should show portafoliospersona" do
    get portafoliospersona_url(@portafoliospersona)
    assert_response :success
  end

  test "should get edit" do
    get edit_portafoliospersona_url(@portafoliospersona)
    assert_response :success
  end

  test "should update portafoliospersona" do
    patch portafoliospersona_url(@portafoliospersona), params: { portafoliospersona: { persona_id: @portafoliospersona.persona_id, portafolio_id: @portafoliospersona.portafolio_id, user_id: @portafoliospersona.user_id } }
    assert_redirected_to portafoliospersona_url(@portafoliospersona)
  end

  test "should destroy portafoliospersona" do
    assert_difference('Portafoliospersona.count', -1) do
      delete portafoliospersona_url(@portafoliospersona)
    end

    assert_redirected_to portafoliospersonas_url
  end
end
