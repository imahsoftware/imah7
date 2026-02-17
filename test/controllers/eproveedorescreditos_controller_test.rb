require 'test_helper'

class EproveedorescreditosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @eproveedorescredito = eproveedorescreditos(:one)
  end

  test "should get index" do
    get eproveedorescreditos_url
    assert_response :success
  end

  test "should get new" do
    get new_eproveedorescredito_url
    assert_response :success
  end

  test "should create eproveedorescredito" do
    assert_difference('Eproveedorescredito.count') do
      post eproveedorescreditos_url, params: { eproveedorescredito: { consecutivo: @eproveedorescredito.consecutivo, eproveedor_id: @eproveedorescredito.eproveedor_id, eproveedorescompra_id: @eproveedorescredito.eproveedorescompra_id, estado: @eproveedorescredito.estado, observaciones: @eproveedorescredito.observaciones, saldo: @eproveedorescredito.saldo, user_id: @eproveedorescredito.user_id, valor: @eproveedorescredito.valor } }
    end

    assert_redirected_to eproveedorescredito_url(Eproveedorescredito.last)
  end

  test "should show eproveedorescredito" do
    get eproveedorescredito_url(@eproveedorescredito)
    assert_response :success
  end

  test "should get edit" do
    get edit_eproveedorescredito_url(@eproveedorescredito)
    assert_response :success
  end

  test "should update eproveedorescredito" do
    patch eproveedorescredito_url(@eproveedorescredito), params: { eproveedorescredito: { consecutivo: @eproveedorescredito.consecutivo, eproveedor_id: @eproveedorescredito.eproveedor_id, eproveedorescompra_id: @eproveedorescredito.eproveedorescompra_id, estado: @eproveedorescredito.estado, observaciones: @eproveedorescredito.observaciones, saldo: @eproveedorescredito.saldo, user_id: @eproveedorescredito.user_id, valor: @eproveedorescredito.valor } }
    assert_redirected_to eproveedorescredito_url(@eproveedorescredito)
  end

  test "should destroy eproveedorescredito" do
    assert_difference('Eproveedorescredito.count', -1) do
      delete eproveedorescredito_url(@eproveedorescredito)
    end

    assert_redirected_to eproveedorescreditos_url
  end
end
