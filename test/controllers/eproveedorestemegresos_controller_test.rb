require 'test_helper'

class EproveedorestemegresosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @eproveedorestemegreso = eproveedorestemegresos(:one)
  end

  test "should get index" do
    get eproveedorestemegresos_url
    assert_response :success
  end

  test "should get new" do
    get new_eproveedorestemegreso_url
    assert_response :success
  end

  test "should create eproveedorestemegreso" do
    assert_difference('Eproveedorestemegreso.count') do
      post eproveedorestemegresos_url, params: { eproveedorestemegreso: { centroscosto_id: @eproveedorestemegreso.centroscosto_id, concepto: @eproveedorestemegreso.concepto, cuenta_id: @eproveedorestemegreso.cuenta_id, eproveedor_id: @eproveedorestemegreso.eproveedor_id, fecha: @eproveedorestemegreso.fecha, forma_pago: @eproveedorestemegreso.forma_pago, nro_cheque: @eproveedorestemegreso.nro_cheque, total: @eproveedorestemegreso.total, user_id: @eproveedorestemegreso.user_id } }
    end

    assert_redirected_to eproveedorestemegreso_url(Eproveedorestemegreso.last)
  end

  test "should show eproveedorestemegreso" do
    get eproveedorestemegreso_url(@eproveedorestemegreso)
    assert_response :success
  end

  test "should get edit" do
    get edit_eproveedorestemegreso_url(@eproveedorestemegreso)
    assert_response :success
  end

  test "should update eproveedorestemegreso" do
    patch eproveedorestemegreso_url(@eproveedorestemegreso), params: { eproveedorestemegreso: { centroscosto_id: @eproveedorestemegreso.centroscosto_id, concepto: @eproveedorestemegreso.concepto, cuenta_id: @eproveedorestemegreso.cuenta_id, eproveedor_id: @eproveedorestemegreso.eproveedor_id, fecha: @eproveedorestemegreso.fecha, forma_pago: @eproveedorestemegreso.forma_pago, nro_cheque: @eproveedorestemegreso.nro_cheque, total: @eproveedorestemegreso.total, user_id: @eproveedorestemegreso.user_id } }
    assert_redirected_to eproveedorestemegreso_url(@eproveedorestemegreso)
  end

  test "should destroy eproveedorestemegreso" do
    assert_difference('Eproveedorestemegreso.count', -1) do
      delete eproveedorestemegreso_url(@eproveedorestemegreso)
    end

    assert_redirected_to eproveedorestemegresos_url
  end
end
