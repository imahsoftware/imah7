require 'test_helper'

class CapacitacionevaluacionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @capacitacionevaluacion = capacitacionevaluaciones(:one)
  end

  test "should get index" do
    get capacitacionevaluaciones_url
    assert_response :success
  end

  test "should get new" do
    get new_capacitacionevaluacion_url
    assert_response :success
  end

  test "should create capacitacionevaluacion" do
    assert_difference('Capacitacionevaluacion.count') do
      post capacitacionevaluaciones_url, params: { capacitacionevaluacion: { capacitacion_doc: @capacitacionevaluacion.capacitacion_doc, capacitacion_id: @capacitacionevaluacion.capacitacion_id, pregunta: @capacitacionevaluacion.pregunta } }
    end

    assert_redirected_to capacitacionevaluacion_url(Capacitacionevaluacion.last)
  end

  test "should show capacitacionevaluacion" do
    get capacitacionevaluacion_url(@capacitacionevaluacion)
    assert_response :success
  end

  test "should get edit" do
    get edit_capacitacionevaluacion_url(@capacitacionevaluacion)
    assert_response :success
  end

  test "should update capacitacionevaluacion" do
    patch capacitacionevaluacion_url(@capacitacionevaluacion), params: { capacitacionevaluacion: { capacitacion_doc: @capacitacionevaluacion.capacitacion_doc, capacitacion_id: @capacitacionevaluacion.capacitacion_id, pregunta: @capacitacionevaluacion.pregunta } }
    assert_redirected_to capacitacionevaluacion_url(@capacitacionevaluacion)
  end

  test "should destroy capacitacionevaluacion" do
    assert_difference('Capacitacionevaluacion.count', -1) do
      delete capacitacionevaluacion_url(@capacitacionevaluacion)
    end

    assert_redirected_to capacitacionevaluaciones_url
  end
end
