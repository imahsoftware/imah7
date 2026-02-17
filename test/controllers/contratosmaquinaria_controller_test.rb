require 'test_helper'

class ContratosmaquinariaControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosmaquinaria = contratosmaquinaria(:one)
  end

  test "should get index" do
    get contratosmaquinaria_index_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosmaquinaria_url
    assert_response :success
  end

  test "should create contratosmaquinaria" do
    assert_difference('Contratosmaquinaria.count') do
      post contratosmaquinaria_index_url, params: { contratosmaquinaria: { cantidad_mensual: @contratosmaquinaria.cantidad_mensual, contrato_id: @contratosmaquinaria.contrato_id, descuento: @contratosmaquinaria.descuento, insumo_id: @contratosmaquinaria.insumo_id, precio_condescuento: @contratosmaquinaria.precio_condescuento, precio_unitario: @contratosmaquinaria.precio_unitario, total: @contratosmaquinaria.total, user_act: @contratosmaquinaria.user_act, user_id: @contratosmaquinaria.user_id } }
    end

    assert_redirected_to contratosmaquinaria_url(Contratosmaquinaria.last)
  end

  test "should show contratosmaquinaria" do
    get contratosmaquinaria_url(@contratosmaquinaria)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosmaquinaria_url(@contratosmaquinaria)
    assert_response :success
  end

  test "should update contratosmaquinaria" do
    patch contratosmaquinaria_url(@contratosmaquinaria), params: { contratosmaquinaria: { cantidad_mensual: @contratosmaquinaria.cantidad_mensual, contrato_id: @contratosmaquinaria.contrato_id, descuento: @contratosmaquinaria.descuento, insumo_id: @contratosmaquinaria.insumo_id, precio_condescuento: @contratosmaquinaria.precio_condescuento, precio_unitario: @contratosmaquinaria.precio_unitario, total: @contratosmaquinaria.total, user_act: @contratosmaquinaria.user_act, user_id: @contratosmaquinaria.user_id } }
    assert_redirected_to contratosmaquinaria_url(@contratosmaquinaria)
  end

  test "should destroy contratosmaquinaria" do
    assert_difference('Contratosmaquinaria.count', -1) do
      delete contratosmaquinaria_url(@contratosmaquinaria)
    end

    assert_redirected_to contratosmaquinaria_index_url
  end
end
