require 'test_helper'

class PeriodosliquidacionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @periodosliquidacion = periodosliquidaciones(:one)
  end

  test "should get index" do
    get periodosliquidaciones_url
    assert_response :success
  end

  test "should get new" do
    get new_periodosliquidacion_url
    assert_response :success
  end

  test "should create periodosliquidacion" do
    assert_difference('Periodosliquidacion.count') do
      post periodosliquidaciones_url, params: { periodosliquidacion: { estado: @periodosliquidacion.estado, fin: @periodosliquidacion.fin, inicio: @periodosliquidacion.inicio } }
    end

    assert_redirected_to periodosliquidacion_url(Periodosliquidacion.last)
  end

  test "should show periodosliquidacion" do
    get periodosliquidacion_url(@periodosliquidacion)
    assert_response :success
  end

  test "should get edit" do
    get edit_periodosliquidacion_url(@periodosliquidacion)
    assert_response :success
  end

  test "should update periodosliquidacion" do
    patch periodosliquidacion_url(@periodosliquidacion), params: { periodosliquidacion: { estado: @periodosliquidacion.estado, fin: @periodosliquidacion.fin, inicio: @periodosliquidacion.inicio } }
    assert_redirected_to periodosliquidacion_url(@periodosliquidacion)
  end

  test "should destroy periodosliquidacion" do
    assert_difference('Periodosliquidacion.count', -1) do
      delete periodosliquidacion_url(@periodosliquidacion)
    end

    assert_redirected_to periodosliquidaciones_url
  end
end
