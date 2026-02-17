require 'test_helper'

class EproveedoresrecibosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @eproveedoresrecibo = eproveedoresrecibos(:one)
  end

  test "should get index" do
    get eproveedoresrecibos_url
    assert_response :success
  end

  test "should get new" do
    get new_eproveedoresrecibo_url
    assert_response :success
  end

  test "should create eproveedoresrecibo" do
    assert_difference('Eproveedoresrecibo.count') do
      post eproveedoresrecibos_url, params: { eproveedoresrecibo: { centroscosto_id: @eproveedoresrecibo.centroscosto_id, concepto: @eproveedoresrecibo.concepto, consecutivo: @eproveedoresrecibo.consecutivo, cuenta_id: @eproveedoresrecibo.cuenta_id, eproveedor_id: @eproveedoresrecibo.eproveedor_id, fecha: @eproveedoresrecibo.fecha, forma_pago: @eproveedoresrecibo.forma_pago, nro_cheque: @eproveedoresrecibo.nro_cheque, total: @eproveedoresrecibo.total, user_id: @eproveedoresrecibo.user_id } }
    end

    assert_redirected_to eproveedoresrecibo_url(Eproveedoresrecibo.last)
  end

  test "should show eproveedoresrecibo" do
    get eproveedoresrecibo_url(@eproveedoresrecibo)
    assert_response :success
  end

  test "should get edit" do
    get edit_eproveedoresrecibo_url(@eproveedoresrecibo)
    assert_response :success
  end

  test "should update eproveedoresrecibo" do
    patch eproveedoresrecibo_url(@eproveedoresrecibo), params: { eproveedoresrecibo: { centroscosto_id: @eproveedoresrecibo.centroscosto_id, concepto: @eproveedoresrecibo.concepto, consecutivo: @eproveedoresrecibo.consecutivo, cuenta_id: @eproveedoresrecibo.cuenta_id, eproveedor_id: @eproveedoresrecibo.eproveedor_id, fecha: @eproveedoresrecibo.fecha, forma_pago: @eproveedoresrecibo.forma_pago, nro_cheque: @eproveedoresrecibo.nro_cheque, total: @eproveedoresrecibo.total, user_id: @eproveedoresrecibo.user_id } }
    assert_redirected_to eproveedoresrecibo_url(@eproveedoresrecibo)
  end

  test "should destroy eproveedoresrecibo" do
    assert_difference('Eproveedoresrecibo.count', -1) do
      delete eproveedoresrecibo_url(@eproveedoresrecibo)
    end

    assert_redirected_to eproveedoresrecibos_url
  end
end
