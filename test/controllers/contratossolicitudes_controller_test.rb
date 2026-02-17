require 'test_helper'

class ContratossolicitudesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratossolicitud = contratossolicitudes(:one)
  end

  test "should get index" do
    get contratossolicitudes_url
    assert_response :success
  end

  test "should get new" do
    get new_contratossolicitud_url
    assert_response :success
  end

  test "should create contratossolicitud" do
    assert_difference('Contratossolicitud.count') do
      post contratossolicitudes_url, params: { contratossolicitud: { contrato_id: @contratossolicitud.contrato_id, estado: @contratossolicitud.estado, user_id: @contratossolicitud.user_id } }
    end

    assert_redirected_to contratossolicitud_url(Contratossolicitud.last)
  end

  test "should show contratossolicitud" do
    get contratossolicitud_url(@contratossolicitud)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratossolicitud_url(@contratossolicitud)
    assert_response :success
  end

  test "should update contratossolicitud" do
    patch contratossolicitud_url(@contratossolicitud), params: { contratossolicitud: { contrato_id: @contratossolicitud.contrato_id, estado: @contratossolicitud.estado, user_id: @contratossolicitud.user_id } }
    assert_redirected_to contratossolicitud_url(@contratossolicitud)
  end

  test "should destroy contratossolicitud" do
    assert_difference('Contratossolicitud.count', -1) do
      delete contratossolicitud_url(@contratossolicitud)
    end

    assert_redirected_to contratossolicitudes_url
  end
end
