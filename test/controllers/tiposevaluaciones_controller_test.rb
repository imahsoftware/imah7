require 'test_helper'

class TiposevaluacionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tiposevaluacion = tiposevaluaciones(:one)
  end

  test "should get index" do
    get tiposevaluaciones_url
    assert_response :success
  end

  test "should get new" do
    get new_tiposevaluacion_url
    assert_response :success
  end

  test "should create tiposevaluacion" do
    assert_difference('Tiposevaluacion.count') do
      post tiposevaluaciones_url, params: { tiposevaluacion: { descripcion: @tiposevaluacion.descripcion, detalle: @tiposevaluacion.detalle, tipo: @tiposevaluacion.tipo } }
    end

    assert_redirected_to tiposevaluacion_url(Tiposevaluacion.last)
  end

  test "should show tiposevaluacion" do
    get tiposevaluacion_url(@tiposevaluacion)
    assert_response :success
  end

  test "should get edit" do
    get edit_tiposevaluacion_url(@tiposevaluacion)
    assert_response :success
  end

  test "should update tiposevaluacion" do
    patch tiposevaluacion_url(@tiposevaluacion), params: { tiposevaluacion: { descripcion: @tiposevaluacion.descripcion, detalle: @tiposevaluacion.detalle, tipo: @tiposevaluacion.tipo } }
    assert_redirected_to tiposevaluacion_url(@tiposevaluacion)
  end

  test "should destroy tiposevaluacion" do
    assert_difference('Tiposevaluacion.count', -1) do
      delete tiposevaluacion_url(@tiposevaluacion)
    end

    assert_redirected_to tiposevaluaciones_url
  end
end
