require 'test_helper'

class TiposmevaluacionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tiposmevaluacion = tiposmevaluaciones(:one)
  end

  test "should get index" do
    get tiposmevaluaciones_url
    assert_response :success
  end

  test "should get new" do
    get new_tiposmevaluacion_url
    assert_response :success
  end

  test "should create tiposmevaluacion" do
    assert_difference('Tiposmevaluacion.count') do
      post tiposmevaluaciones_url, params: { tiposmevaluacion: { clase: @tiposmevaluacion.clase, descripcion: @tiposmevaluacion.descripcion, detalle: @tiposmevaluacion.detalle, tipo: @tiposmevaluacion.tipo, valor1: @tiposmevaluacion.valor1, valor2: @tiposmevaluacion.valor2, valor3: @tiposmevaluacion.valor3 } }
    end

    assert_redirected_to tiposmevaluacion_url(Tiposmevaluacion.last)
  end

  test "should show tiposmevaluacion" do
    get tiposmevaluacion_url(@tiposmevaluacion)
    assert_response :success
  end

  test "should get edit" do
    get edit_tiposmevaluacion_url(@tiposmevaluacion)
    assert_response :success
  end

  test "should update tiposmevaluacion" do
    patch tiposmevaluacion_url(@tiposmevaluacion), params: { tiposmevaluacion: { clase: @tiposmevaluacion.clase, descripcion: @tiposmevaluacion.descripcion, detalle: @tiposmevaluacion.detalle, tipo: @tiposmevaluacion.tipo, valor1: @tiposmevaluacion.valor1, valor2: @tiposmevaluacion.valor2, valor3: @tiposmevaluacion.valor3 } }
    assert_redirected_to tiposmevaluacion_url(@tiposmevaluacion)
  end

  test "should destroy tiposmevaluacion" do
    assert_difference('Tiposmevaluacion.count', -1) do
      delete tiposmevaluacion_url(@tiposmevaluacion)
    end

    assert_redirected_to tiposmevaluaciones_url
  end
end
