require 'test_helper'

class PortafoliosconfiguracionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @portafoliosconfiguracion = portafoliosconfiguraciones(:one)
  end

  test "should get index" do
    get portafoliosconfiguraciones_url
    assert_response :success
  end

  test "should get new" do
    get new_portafoliosconfiguracion_url
    assert_response :success
  end

  test "should create portafoliosconfiguracion" do
    assert_difference('Portafoliosconfiguracion.count') do
      post portafoliosconfiguraciones_url, params: { portafoliosconfiguracion: { descripcion: @portafoliosconfiguracion.descripcion, portafolio_id: @portafoliosconfiguracion.portafolio_id, valor: @portafoliosconfiguracion.valor } }
    end

    assert_redirected_to portafoliosconfiguracion_url(Portafoliosconfiguracion.last)
  end

  test "should show portafoliosconfiguracion" do
    get portafoliosconfiguracion_url(@portafoliosconfiguracion)
    assert_response :success
  end

  test "should get edit" do
    get edit_portafoliosconfiguracion_url(@portafoliosconfiguracion)
    assert_response :success
  end

  test "should update portafoliosconfiguracion" do
    patch portafoliosconfiguracion_url(@portafoliosconfiguracion), params: { portafoliosconfiguracion: { descripcion: @portafoliosconfiguracion.descripcion, portafolio_id: @portafoliosconfiguracion.portafolio_id, valor: @portafoliosconfiguracion.valor } }
    assert_redirected_to portafoliosconfiguracion_url(@portafoliosconfiguracion)
  end

  test "should destroy portafoliosconfiguracion" do
    assert_difference('Portafoliosconfiguracion.count', -1) do
      delete portafoliosconfiguracion_url(@portafoliosconfiguracion)
    end

    assert_redirected_to portafoliosconfiguraciones_url
  end
end
