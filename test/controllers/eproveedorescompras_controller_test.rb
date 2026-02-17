require 'test_helper'

class EproveedorescomprasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @eproveedorescompra = eproveedorescompras(:one)
  end

  test "should get index" do
    get eproveedorescompras_url
    assert_response :success
  end

  test "should get new" do
    get new_eproveedorescompra_url
    assert_response :success
  end

  test "should create eproveedorescompra" do
    assert_difference('Eproveedorescompra.count') do
      post eproveedorescompras_url, params: { eproveedorescompra: { centroscosto_id: @eproveedorescompra.centroscosto_id, descuento: @eproveedorescompra.descuento, eproveedor_id: @eproveedorescompra.eproveedor_id, estado: @eproveedorescompra.estado, fecha: @eproveedorescompra.fecha, nro_factura: @eproveedorescompra.nro_factura, observacion: @eproveedorescompra.observacion, saldo: @eproveedorescompra.saldo, subtotal: @eproveedorescompra.subtotal, total: @eproveedorescompra.total, user_id: @eproveedorescompra.user_id, valor: @eproveedorescompra.valor } }
    end

    assert_redirected_to eproveedorescompra_url(Eproveedorescompra.last)
  end

  test "should show eproveedorescompra" do
    get eproveedorescompra_url(@eproveedorescompra)
    assert_response :success
  end

  test "should get edit" do
    get edit_eproveedorescompra_url(@eproveedorescompra)
    assert_response :success
  end

  test "should update eproveedorescompra" do
    patch eproveedorescompra_url(@eproveedorescompra), params: { eproveedorescompra: { centroscosto_id: @eproveedorescompra.centroscosto_id, descuento: @eproveedorescompra.descuento, eproveedor_id: @eproveedorescompra.eproveedor_id, estado: @eproveedorescompra.estado, fecha: @eproveedorescompra.fecha, nro_factura: @eproveedorescompra.nro_factura, observacion: @eproveedorescompra.observacion, saldo: @eproveedorescompra.saldo, subtotal: @eproveedorescompra.subtotal, total: @eproveedorescompra.total, user_id: @eproveedorescompra.user_id, valor: @eproveedorescompra.valor } }
    assert_redirected_to eproveedorescompra_url(@eproveedorescompra)
  end

  test "should destroy eproveedorescompra" do
    assert_difference('Eproveedorescompra.count', -1) do
      delete eproveedorescompra_url(@eproveedorescompra)
    end

    assert_redirected_to eproveedorescompras_url
  end
end
