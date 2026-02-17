require 'test_helper'

class EproveedorestempcomprasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @eproveedorestempcompra = eproveedorestempcompras(:one)
  end

  test "should get index" do
    get eproveedorestempcompras_url
    assert_response :success
  end

  test "should get new" do
    get new_eproveedorestempcompra_url
    assert_response :success
  end

  test "should create eproveedorestempcompra" do
    assert_difference('Eproveedorestempcompra.count') do
      post eproveedorestempcompras_url, params: { eproveedorestempcompra: { centroscosto_id: @eproveedorestempcompra.centroscosto_id, concepto: @eproveedorestempcompra.concepto, cuenta_cobrar: @eproveedorestempcompra.cuenta_cobrar, ecuenta_id: @eproveedorestempcompra.ecuenta_id, eproveedor_id: @eproveedorestempcompra.eproveedor_id, eproveedorescompra_id: @eproveedorestempcompra.eproveedorescompra_id, fecha: @eproveedorestempcompra.fecha, forma_pago: @eproveedorestempcompra.forma_pago, nro_cheque: @eproveedorestempcompra.nro_cheque, total: @eproveedorestempcompra.total, user_id: @eproveedorestempcompra.user_id } }
    end

    assert_redirected_to eproveedorestempcompra_url(Eproveedorestempcompra.last)
  end

  test "should show eproveedorestempcompra" do
    get eproveedorestempcompra_url(@eproveedorestempcompra)
    assert_response :success
  end

  test "should get edit" do
    get edit_eproveedorestempcompra_url(@eproveedorestempcompra)
    assert_response :success
  end

  test "should update eproveedorestempcompra" do
    patch eproveedorestempcompra_url(@eproveedorestempcompra), params: { eproveedorestempcompra: { centroscosto_id: @eproveedorestempcompra.centroscosto_id, concepto: @eproveedorestempcompra.concepto, cuenta_cobrar: @eproveedorestempcompra.cuenta_cobrar, ecuenta_id: @eproveedorestempcompra.ecuenta_id, eproveedor_id: @eproveedorestempcompra.eproveedor_id, eproveedorescompra_id: @eproveedorestempcompra.eproveedorescompra_id, fecha: @eproveedorestempcompra.fecha, forma_pago: @eproveedorestempcompra.forma_pago, nro_cheque: @eproveedorestempcompra.nro_cheque, total: @eproveedorestempcompra.total, user_id: @eproveedorestempcompra.user_id } }
    assert_redirected_to eproveedorestempcompra_url(@eproveedorestempcompra)
  end

  test "should destroy eproveedorestempcompra" do
    assert_difference('Eproveedorestempcompra.count', -1) do
      delete eproveedorestempcompra_url(@eproveedorestempcompra)
    end

    assert_redirected_to eproveedorestempcompras_url
  end
end
