require 'test_helper'

class ContratosmodificacionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosmodificacion = contratosmodificaciones(:one)
  end

  test "should get index" do
    get contratosmodificaciones_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosmodificacion_url
    assert_response :success
  end

  test "should create contratosmodificacion" do
    assert_difference('Contratosmodificacion.count') do
      post contratosmodificaciones_url, params: { contratosmodificacion: { contrato_id: @contratosmodificacion.contrato_id, fecha_modificacion: @contratosmodificacion.fecha_modificacion, observacion: @contratosmodificacion.observacion, plazo_dia: @contratosmodificacion.plazo_dia, plazo_mes: @contratosmodificacion.plazo_mes, tipo_modificacion: @contratosmodificacion.tipo_modificacion, user_id: @contratosmodificacion.user_id, valor: @contratosmodificacion.valor } }
    end

    assert_redirected_to contratosmodificacion_url(Contratosmodificacion.last)
  end

  test "should show contratosmodificacion" do
    get contratosmodificacion_url(@contratosmodificacion)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosmodificacion_url(@contratosmodificacion)
    assert_response :success
  end

  test "should update contratosmodificacion" do
    patch contratosmodificacion_url(@contratosmodificacion), params: { contratosmodificacion: { contrato_id: @contratosmodificacion.contrato_id, fecha_modificacion: @contratosmodificacion.fecha_modificacion, observacion: @contratosmodificacion.observacion, plazo_dia: @contratosmodificacion.plazo_dia, plazo_mes: @contratosmodificacion.plazo_mes, tipo_modificacion: @contratosmodificacion.tipo_modificacion, user_id: @contratosmodificacion.user_id, valor: @contratosmodificacion.valor } }
    assert_redirected_to contratosmodificacion_url(@contratosmodificacion)
  end

  test "should destroy contratosmodificacion" do
    assert_difference('Contratosmodificacion.count', -1) do
      delete contratosmodificacion_url(@contratosmodificacion)
    end

    assert_redirected_to contratosmodificaciones_url
  end
end
