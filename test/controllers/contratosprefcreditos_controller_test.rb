require 'test_helper'

class ContratosprefcreditosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosprefcredito = contratosprefcreditos(:one)
  end

  test "should get index" do
    get contratosprefcreditos_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosprefcredito_url
    assert_response :success
  end

  test "should create contratosprefcredito" do
    assert_difference('Contratosprefcredito.count') do
      post contratosprefcreditos_url, params: { contratosprefcredito: { contrato_id: @contratosprefcredito.contrato_id, contratosprefactura_id: @contratosprefcredito.contratosprefactura_id, fecha: @contratosprefcredito.fecha, observacion: @contratosprefcredito.observacion, user_id: @contratosprefcredito.user_id, valor: @contratosprefcredito.valor } }
    end

    assert_redirected_to contratosprefcredito_url(Contratosprefcredito.last)
  end

  test "should show contratosprefcredito" do
    get contratosprefcredito_url(@contratosprefcredito)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosprefcredito_url(@contratosprefcredito)
    assert_response :success
  end

  test "should update contratosprefcredito" do
    patch contratosprefcredito_url(@contratosprefcredito), params: { contratosprefcredito: { contrato_id: @contratosprefcredito.contrato_id, contratosprefactura_id: @contratosprefcredito.contratosprefactura_id, fecha: @contratosprefcredito.fecha, observacion: @contratosprefcredito.observacion, user_id: @contratosprefcredito.user_id, valor: @contratosprefcredito.valor } }
    assert_redirected_to contratosprefcredito_url(@contratosprefcredito)
  end

  test "should destroy contratosprefcredito" do
    assert_difference('Contratosprefcredito.count', -1) do
      delete contratosprefcredito_url(@contratosprefcredito)
    end

    assert_redirected_to contratosprefcreditos_url
  end
end
