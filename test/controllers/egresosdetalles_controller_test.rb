require 'test_helper'

class EgresosdetallesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @egresosdetalle = egresosdetalles(:one)
  end

  test "should get index" do
    get egresosdetalles_url
    assert_response :success
  end

  test "should get new" do
    get new_egresosdetalle_url
    assert_response :success
  end

  test "should create egresosdetalle" do
    assert_difference('Egresosdetalle.count') do
      post egresosdetalles_url, params: { egresosdetalle: { cantidad: @egresosdetalle.cantidad, centroscosto_id: @egresosdetalle.centroscosto_id, claseretencion: @egresosdetalle.claseretencion, concepto: @egresosdetalle.concepto, egreso_id: @egresosdetalle.egreso_id, eproveedorescompra_id: @egresosdetalle.eproveedorescompra_id, iva: @egresosdetalle.iva, retecre: @egresosdetalle.retecre, retencion: @egresosdetalle.retencion, subtotal: @egresosdetalle.subtotal, total: @egresosdetalle.total, user_id: @egresosdetalle.user_id, valor_iva: @egresosdetalle.valor_iva, valor_unitario: @egresosdetalle.valor_unitario } }
    end

    assert_redirected_to egresosdetalle_url(Egresosdetalle.last)
  end

  test "should show egresosdetalle" do
    get egresosdetalle_url(@egresosdetalle)
    assert_response :success
  end

  test "should get edit" do
    get edit_egresosdetalle_url(@egresosdetalle)
    assert_response :success
  end

  test "should update egresosdetalle" do
    patch egresosdetalle_url(@egresosdetalle), params: { egresosdetalle: { cantidad: @egresosdetalle.cantidad, centroscosto_id: @egresosdetalle.centroscosto_id, claseretencion: @egresosdetalle.claseretencion, concepto: @egresosdetalle.concepto, egreso_id: @egresosdetalle.egreso_id, eproveedorescompra_id: @egresosdetalle.eproveedorescompra_id, iva: @egresosdetalle.iva, retecre: @egresosdetalle.retecre, retencion: @egresosdetalle.retencion, subtotal: @egresosdetalle.subtotal, total: @egresosdetalle.total, user_id: @egresosdetalle.user_id, valor_iva: @egresosdetalle.valor_iva, valor_unitario: @egresosdetalle.valor_unitario } }
    assert_redirected_to egresosdetalle_url(@egresosdetalle)
  end

  test "should destroy egresosdetalle" do
    assert_difference('Egresosdetalle.count', -1) do
      delete egresosdetalle_url(@egresosdetalle)
    end

    assert_redirected_to egresosdetalles_url
  end
end
