require 'test_helper'

class ContratosperliquidacionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosperliquidacion = contratosperliquidaciones(:one)
  end

  test "should get index" do
    get contratosperliquidaciones_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosperliquidacion_url
    assert_response :success
  end

  test "should create contratosperliquidacion" do
    assert_difference('Contratosperliquidacion.count') do
      post contratosperliquidaciones_url, params: { contratosperliquidacion: { autobuscar: @contratosperliquidacion.autobuscar, auxilio: @contratosperliquidacion.auxilio, cesantias: @contratosperliquidacion.cesantias, contratosperfecha_id: @contratosperliquidacion.contratosperfecha_id, dias: @contratosperliquidacion.dias, estado: @contratosperliquidacion.estado, int_cesantias: @contratosperliquidacion.int_cesantias, liquidacionimagen: @contratosperliquidacion.liquidacionimagen, novedades: @contratosperliquidacion.novedades, prima: @contratosperliquidacion.prima, salario_mes: @contratosperliquidacion.salario_mes, subtotal: @contratosperliquidacion.subtotal, total: @contratosperliquidacion.total, vacaciones: @contratosperliquidacion.vacaciones } }
    end

    assert_redirected_to contratosperliquidacion_url(Contratosperliquidacion.last)
  end

  test "should show contratosperliquidacion" do
    get contratosperliquidacion_url(@contratosperliquidacion)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosperliquidacion_url(@contratosperliquidacion)
    assert_response :success
  end

  test "should update contratosperliquidacion" do
    patch contratosperliquidacion_url(@contratosperliquidacion), params: { contratosperliquidacion: { autobuscar: @contratosperliquidacion.autobuscar, auxilio: @contratosperliquidacion.auxilio, cesantias: @contratosperliquidacion.cesantias, contratosperfecha_id: @contratosperliquidacion.contratosperfecha_id, dias: @contratosperliquidacion.dias, estado: @contratosperliquidacion.estado, int_cesantias: @contratosperliquidacion.int_cesantias, liquidacionimagen: @contratosperliquidacion.liquidacionimagen, novedades: @contratosperliquidacion.novedades, prima: @contratosperliquidacion.prima, salario_mes: @contratosperliquidacion.salario_mes, subtotal: @contratosperliquidacion.subtotal, total: @contratosperliquidacion.total, vacaciones: @contratosperliquidacion.vacaciones } }
    assert_redirected_to contratosperliquidacion_url(@contratosperliquidacion)
  end

  test "should destroy contratosperliquidacion" do
    assert_difference('Contratosperliquidacion.count', -1) do
      delete contratosperliquidacion_url(@contratosperliquidacion)
    end

    assert_redirected_to contratosperliquidaciones_url
  end
end
