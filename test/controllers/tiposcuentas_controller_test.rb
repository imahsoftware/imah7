require 'test_helper'

class TiposcuentasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tiposcuenta = tiposcuentas(:one)
  end

  test "should get index" do
    get tiposcuentas_url
    assert_response :success
  end

  test "should get new" do
    get new_tiposcuenta_url
    assert_response :success
  end

  test "should create tiposcuenta" do
    assert_difference('Tiposcuenta.count') do
      post tiposcuentas_url, params: { tiposcuenta: { entidad: @tiposcuenta.entidad, nro_cuenta: @tiposcuenta.nro_cuenta, tipo: @tiposcuenta.tipo } }
    end

    assert_redirected_to tiposcuenta_url(Tiposcuenta.last)
  end

  test "should show tiposcuenta" do
    get tiposcuenta_url(@tiposcuenta)
    assert_response :success
  end

  test "should get edit" do
    get edit_tiposcuenta_url(@tiposcuenta)
    assert_response :success
  end

  test "should update tiposcuenta" do
    patch tiposcuenta_url(@tiposcuenta), params: { tiposcuenta: { entidad: @tiposcuenta.entidad, nro_cuenta: @tiposcuenta.nro_cuenta, tipo: @tiposcuenta.tipo } }
    assert_redirected_to tiposcuenta_url(@tiposcuenta)
  end

  test "should destroy tiposcuenta" do
    assert_difference('Tiposcuenta.count', -1) do
      delete tiposcuenta_url(@tiposcuenta)
    end

    assert_redirected_to tiposcuentas_url
  end
end
