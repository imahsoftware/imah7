require 'test_helper'

class EvaluacionesdetallesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @evaluacionesdetalle = evaluacionesdetalles(:one)
  end

  test "should get index" do
    get evaluacionesdetalles_url
    assert_response :success
  end

  test "should get new" do
    get new_evaluacionesdetalle_url
    assert_response :success
  end

  test "should create evaluacionesdetalle" do
    assert_difference('Evaluacionesdetalle.count') do
      post evaluacionesdetalles_url, params: { evaluacionesdetalle: { actividad: @evaluacionesdetalle.actividad, clase: @evaluacionesdetalle.clase, evaluacion_id: @evaluacionesdetalle.evaluacion_id, requieredoc: @evaluacionesdetalle.requieredoc } }
    end

    assert_redirected_to evaluacionesdetalle_url(Evaluacionesdetalle.last)
  end

  test "should show evaluacionesdetalle" do
    get evaluacionesdetalle_url(@evaluacionesdetalle)
    assert_response :success
  end

  test "should get edit" do
    get edit_evaluacionesdetalle_url(@evaluacionesdetalle)
    assert_response :success
  end

  test "should update evaluacionesdetalle" do
    patch evaluacionesdetalle_url(@evaluacionesdetalle), params: { evaluacionesdetalle: { actividad: @evaluacionesdetalle.actividad, clase: @evaluacionesdetalle.clase, evaluacion_id: @evaluacionesdetalle.evaluacion_id, requieredoc: @evaluacionesdetalle.requieredoc } }
    assert_redirected_to evaluacionesdetalle_url(@evaluacionesdetalle)
  end

  test "should destroy evaluacionesdetalle" do
    assert_difference('Evaluacionesdetalle.count', -1) do
      delete evaluacionesdetalle_url(@evaluacionesdetalle)
    end

    assert_redirected_to evaluacionesdetalles_url
  end
end
