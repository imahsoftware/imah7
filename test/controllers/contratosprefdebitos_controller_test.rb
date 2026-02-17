require 'test_helper'

class ContratosprefdebitosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosprefdebito = contratosprefdebitos(:one)
  end

  test "should get index" do
    get contratosprefdebitos_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosprefdebito_url
    assert_response :success
  end

  test "should create contratosprefdebito" do
    assert_difference('Contratosprefdebito.count') do
      post contratosprefdebitos_url, params: { contratosprefdebito: { contrato_id: @contratosprefdebito.contrato_id, contratosprefactura_id: @contratosprefdebito.contratosprefactura_id, fecha: @contratosprefdebito.fecha, observacion: @contratosprefdebito.observacion, user_id: @contratosprefdebito.user_id, valor: @contratosprefdebito.valor } }
    end

    assert_redirected_to contratosprefdebito_url(Contratosprefdebito.last)
  end

  test "should show contratosprefdebito" do
    get contratosprefdebito_url(@contratosprefdebito)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosprefdebito_url(@contratosprefdebito)
    assert_response :success
  end

  test "should update contratosprefdebito" do
    patch contratosprefdebito_url(@contratosprefdebito), params: { contratosprefdebito: { contrato_id: @contratosprefdebito.contrato_id, contratosprefactura_id: @contratosprefdebito.contratosprefactura_id, fecha: @contratosprefdebito.fecha, observacion: @contratosprefdebito.observacion, user_id: @contratosprefdebito.user_id, valor: @contratosprefdebito.valor } }
    assert_redirected_to contratosprefdebito_url(@contratosprefdebito)
  end

  test "should destroy contratosprefdebito" do
    assert_difference('Contratosprefdebito.count', -1) do
      delete contratosprefdebito_url(@contratosprefdebito)
    end

    assert_redirected_to contratosprefdebitos_url
  end
end
