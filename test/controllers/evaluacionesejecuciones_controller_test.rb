require 'test_helper'

class EvaluacionesejecucionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @evaluacionesejecucion = evaluacionesejecuciones(:one)
  end

  test "should get index" do
    get evaluacionesejecuciones_url
    assert_response :success
  end

  test "should get new" do
    get new_evaluacionesejecucion_url
    assert_response :success
  end

  test "should create evaluacionesejecucion" do
    assert_difference('Evaluacionesejecucion.count') do
      post evaluacionesejecuciones_url, params: { evaluacionesejecucion: { estado: @evaluacionesejecucion.estado, evalacionesdetalle_id: @evaluacionesejecucion.evalacionesdetalle_id, evaluacion_id: @evaluacionesejecucion.evaluacion_id, evaluacionescontrato_id: @evaluacionesejecucion.evaluacionescontrato_id, resultado: @evaluacionesejecucion.resultado, user_id: @evaluacionesejecucion.user_id } }
    end

    assert_redirected_to evaluacionesejecucion_url(Evaluacionesejecucion.last)
  end

  test "should show evaluacionesejecucion" do
    get evaluacionesejecucion_url(@evaluacionesejecucion)
    assert_response :success
  end

  test "should get edit" do
    get edit_evaluacionesejecucion_url(@evaluacionesejecucion)
    assert_response :success
  end

  test "should update evaluacionesejecucion" do
    patch evaluacionesejecucion_url(@evaluacionesejecucion), params: { evaluacionesejecucion: { estado: @evaluacionesejecucion.estado, evalacionesdetalle_id: @evaluacionesejecucion.evalacionesdetalle_id, evaluacion_id: @evaluacionesejecucion.evaluacion_id, evaluacionescontrato_id: @evaluacionesejecucion.evaluacionescontrato_id, resultado: @evaluacionesejecucion.resultado, user_id: @evaluacionesejecucion.user_id } }
    assert_redirected_to evaluacionesejecucion_url(@evaluacionesejecucion)
  end

  test "should destroy evaluacionesejecucion" do
    assert_difference('Evaluacionesejecucion.count', -1) do
      delete evaluacionesejecucion_url(@evaluacionesejecucion)
    end

    assert_redirected_to evaluacionesejecuciones_url
  end
end
