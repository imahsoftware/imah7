require 'test_helper'

class CapacitacionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @capacitacion = capacitaciones(:one)
  end

  test "should get index" do
    get capacitaciones_url
    assert_response :success
  end

  test "should get new" do
    get new_capacitacion_url
    assert_response :success
  end

  test "should create capacitacion" do
    assert_difference('Capacitacion.count') do
      post capacitaciones_url, params: { capacitacion: { descripcion: @capacitacion.descripcion, estado: @capacitacion.estado, objetivo: @capacitacion.objetivo, temas: @capacitacion.temas, user_id: @capacitacion.user_id, valor_aprobado: @capacitacion.valor_aprobado } }
    end

    assert_redirected_to capacitacion_url(Capacitacion.last)
  end

  test "should show capacitacion" do
    get capacitacion_url(@capacitacion)
    assert_response :success
  end

  test "should get edit" do
    get edit_capacitacion_url(@capacitacion)
    assert_response :success
  end

  test "should update capacitacion" do
    patch capacitacion_url(@capacitacion), params: { capacitacion: { descripcion: @capacitacion.descripcion, estado: @capacitacion.estado, objetivo: @capacitacion.objetivo, temas: @capacitacion.temas, user_id: @capacitacion.user_id, valor_aprobado: @capacitacion.valor_aprobado } }
    assert_redirected_to capacitacion_url(@capacitacion)
  end

  test "should destroy capacitacion" do
    assert_difference('Capacitacion.count', -1) do
      delete capacitacion_url(@capacitacion)
    end

    assert_redirected_to capacitaciones_url
  end
end
