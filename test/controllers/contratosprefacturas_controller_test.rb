require 'test_helper'

class ContratosprefacturasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosprefactura = contratosprefacturas(:one)
  end

  test "should get index" do
    get contratosprefacturas_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosprefactura_url
    assert_response :success
  end

  test "should create contratosprefactura" do
    assert_difference('Contratosprefactura.count') do
      post contratosprefacturas_url, params: { contratosprefactura: { ayu: @contratosprefactura.ayu, contrato_id: @contratosprefactura.contrato_id, iva: @contratosprefactura.iva, siigo_id: @contratosprefactura.siigo_id, siigo_nro: @contratosprefactura.siigo_nro, subtotal: @contratosprefactura.subtotal, total: @contratosprefactura.total, user_id: @contratosprefactura.user_id } }
    end

    assert_redirected_to contratosprefactura_url(Contratosprefactura.last)
  end

  test "should show contratosprefactura" do
    get contratosprefactura_url(@contratosprefactura)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosprefactura_url(@contratosprefactura)
    assert_response :success
  end

  test "should update contratosprefactura" do
    patch contratosprefactura_url(@contratosprefactura), params: { contratosprefactura: { ayu: @contratosprefactura.ayu, contrato_id: @contratosprefactura.contrato_id, iva: @contratosprefactura.iva, siigo_id: @contratosprefactura.siigo_id, siigo_nro: @contratosprefactura.siigo_nro, subtotal: @contratosprefactura.subtotal, total: @contratosprefactura.total, user_id: @contratosprefactura.user_id } }
    assert_redirected_to contratosprefactura_url(@contratosprefactura)
  end

  test "should destroy contratosprefactura" do
    assert_difference('Contratosprefactura.count', -1) do
      delete contratosprefactura_url(@contratosprefactura)
    end

    assert_redirected_to contratosprefacturas_url
  end
end
