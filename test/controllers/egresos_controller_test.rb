require 'test_helper'

class EgresosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @egreso = egresos(:one)
  end

  test "should get index" do
    get egresos_url
    assert_response :success
  end

  test "should get new" do
    get new_egreso_url
    assert_response :success
  end

  test "should create egreso" do
    assert_difference('Egreso.count') do
      post egresos_url, params: { egreso: { centroscosto_id: @egreso.centroscosto_id, cuenta_id: @egreso.cuenta_id, descuento: @egreso.descuento, eproveedor_id: @egreso.eproveedor_id, eproveedorescompra_id: @egreso.eproveedorescompra_id, estado: @egreso.estado, fecha: @egreso.fecha, forma_pago: @egreso.forma_pago, iva: @egreso.iva, nro_cheque: @egreso.nro_cheque, nro_egreso: @egreso.nro_egreso, retecre: @egreso.retecre, saldo: @egreso.saldo, subtotal: @egreso.subtotal, total: @egreso.total, total_final: @egreso.total_final, user_anula: @egreso.user_anula, user_id: @egreso.user_id } }
    end

    assert_redirected_to egreso_url(Egreso.last)
  end

  test "should show egreso" do
    get egreso_url(@egreso)
    assert_response :success
  end

  test "should get edit" do
    get edit_egreso_url(@egreso)
    assert_response :success
  end

  test "should update egreso" do
    patch egreso_url(@egreso), params: { egreso: { centroscosto_id: @egreso.centroscosto_id, cuenta_id: @egreso.cuenta_id, descuento: @egreso.descuento, eproveedor_id: @egreso.eproveedor_id, eproveedorescompra_id: @egreso.eproveedorescompra_id, estado: @egreso.estado, fecha: @egreso.fecha, forma_pago: @egreso.forma_pago, iva: @egreso.iva, nro_cheque: @egreso.nro_cheque, nro_egreso: @egreso.nro_egreso, retecre: @egreso.retecre, saldo: @egreso.saldo, subtotal: @egreso.subtotal, total: @egreso.total, total_final: @egreso.total_final, user_anula: @egreso.user_anula, user_id: @egreso.user_id } }
    assert_redirected_to egreso_url(@egreso)
  end

  test "should destroy egreso" do
    assert_difference('Egreso.count', -1) do
      delete egreso_url(@egreso)
    end

    assert_redirected_to egresos_url
  end
end
