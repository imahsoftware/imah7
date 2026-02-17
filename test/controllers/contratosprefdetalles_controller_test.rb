require 'test_helper'

class ContratosprefdetallesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosprefdetall = contratosprefdetalles(:one)
  end

  test "should get index" do
    get contratosprefdetalles_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosprefdetall_url
    assert_response :success
  end

  test "should create contratosprefdetall" do
    assert_difference('Contratosprefdetalle.count') do
      post contratosprefdetalles_url, params: { contratosprefdetall: { ayu: @contratosprefdetall.ayu, cantidad: @contratosprefdetall.cantidad, contratosprefactura_id: @contratosprefdetall.contratosprefactura_id, detalle: @contratosprefdetall.detalle, iva: @contratosprefdetall.iva, subtotal: @contratosprefdetall.subtotal, total: @contratosprefdetall.total, valor_unitario: @contratosprefdetall.valor_unitario } }
    end

    assert_redirected_to contratosprefdetall_url(Contratosprefdetalle.last)
  end

  test "should show contratosprefdetall" do
    get contratosprefdetall_url(@contratosprefdetall)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosprefdetall_url(@contratosprefdetall)
    assert_response :success
  end

  test "should update contratosprefdetall" do
    patch contratosprefdetall_url(@contratosprefdetall), params: { contratosprefdetall: { ayu: @contratosprefdetall.ayu, cantidad: @contratosprefdetall.cantidad, contratosprefactura_id: @contratosprefdetall.contratosprefactura_id, detalle: @contratosprefdetall.detalle, iva: @contratosprefdetall.iva, subtotal: @contratosprefdetall.subtotal, total: @contratosprefdetall.total, valor_unitario: @contratosprefdetall.valor_unitario } }
    assert_redirected_to contratosprefdetall_url(@contratosprefdetall)
  end

  test "should destroy contratosprefdetall" do
    assert_difference('Contratosprefdetalle.count', -1) do
      delete contratosprefdetall_url(@contratosprefdetall)
    end

    assert_redirected_to contratosprefdetalles_url
  end
end
