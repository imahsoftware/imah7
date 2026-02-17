require 'test_helper'

class ContratosinsumosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosinsumo = contratosinsumos(:one)
  end

  test "should get index" do
    get contratosinsumos_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosinsumo_url
    assert_response :success
  end

  test "should create contratosinsumo" do
    assert_difference('Contratosinsumo.count') do
      post contratosinsumos_url, params: { contratosinsumo: { cantidad: @contratosinsumo.cantidad, contrato_id: @contratosinsumo.contrato_id, insumo_id: @contratosinsumo.insumo_id, user_act: @contratosinsumo.user_act, user_id: @contratosinsumo.user_id, valor: @contratosinsumo.valor } }
    end

    assert_redirected_to contratosinsumo_url(Contratosinsumo.last)
  end

  test "should show contratosinsumo" do
    get contratosinsumo_url(@contratosinsumo)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosinsumo_url(@contratosinsumo)
    assert_response :success
  end

  test "should update contratosinsumo" do
    patch contratosinsumo_url(@contratosinsumo), params: { contratosinsumo: { cantidad: @contratosinsumo.cantidad, contrato_id: @contratosinsumo.contrato_id, insumo_id: @contratosinsumo.insumo_id, user_act: @contratosinsumo.user_act, user_id: @contratosinsumo.user_id, valor: @contratosinsumo.valor } }
    assert_redirected_to contratosinsumo_url(@contratosinsumo)
  end

  test "should destroy contratosinsumo" do
    assert_difference('Contratosinsumo.count', -1) do
      delete contratosinsumo_url(@contratosinsumo)
    end

    assert_redirected_to contratosinsumos_url
  end
end
