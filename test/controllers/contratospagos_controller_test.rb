require 'test_helper'

class ContratospagosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratospago = contratospagos(:one)
  end

  test "should get index" do
    get contratospagos_url
    assert_response :success
  end

  test "should get new" do
    get new_contratospago_url
    assert_response :success
  end

  test "should create contratospago" do
    assert_difference('Contratospago.count') do
      post contratospagos_url, params: { contratospago: { contrato_id: @contratospago.contrato_id, fecha_cuenta: @contratospago.fecha_cuenta, fecha_pago: @contratospago.fecha_pago, tiposcuenta_id: @contratospago.tiposcuenta_id, user_id: @contratospago.user_id, valor: @contratospago.valor } }
    end

    assert_redirected_to contratospago_url(Contratospago.last)
  end

  test "should show contratospago" do
    get contratospago_url(@contratospago)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratospago_url(@contratospago)
    assert_response :success
  end

  test "should update contratospago" do
    patch contratospago_url(@contratospago), params: { contratospago: { contrato_id: @contratospago.contrato_id, fecha_cuenta: @contratospago.fecha_cuenta, fecha_pago: @contratospago.fecha_pago, tiposcuenta_id: @contratospago.tiposcuenta_id, user_id: @contratospago.user_id, valor: @contratospago.valor } }
    assert_redirected_to contratospago_url(@contratospago)
  end

  test "should destroy contratospago" do
    assert_difference('Contratospago.count', -1) do
      delete contratospago_url(@contratospago)
    end

    assert_redirected_to contratospagos_url
  end
end
