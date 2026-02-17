require 'test_helper'

class MigracionesinsumosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @migracionesinsumo = migracionesinsumos(:one)
  end

  test "should get index" do
    get migracionesinsumos_url
    assert_response :success
  end

  test "should get new" do
    get new_migracionesinsumo_url
    assert_response :success
  end

  test "should create migracionesinsumo" do
    assert_difference('Migracionesinsumo.count') do
      post migracionesinsumos_url, params: { migracionesinsumo: { archivo_id: @migracionesinsumo.archivo_id, cantidad_mensual: @migracionesinsumo.cantidad_mensual, contrato_id: @migracionesinsumo.contrato_id, descuento: @migracionesinsumo.descuento, estado: @migracionesinsumo.estado, insumo_id: @migracionesinsumo.insumo_id, precio_condescuento: @migracionesinsumo.precio_condescuento, precio_unitario: @migracionesinsumo.precio_unitario, total: @migracionesinsumo.total, user_id: @migracionesinsumo.user_id } }
    end

    assert_redirected_to migracionesinsumo_url(Migracionesinsumo.last)
  end

  test "should show migracionesinsumo" do
    get migracionesinsumo_url(@migracionesinsumo)
    assert_response :success
  end

  test "should get edit" do
    get edit_migracionesinsumo_url(@migracionesinsumo)
    assert_response :success
  end

  test "should update migracionesinsumo" do
    patch migracionesinsumo_url(@migracionesinsumo), params: { migracionesinsumo: { archivo_id: @migracionesinsumo.archivo_id, cantidad_mensual: @migracionesinsumo.cantidad_mensual, contrato_id: @migracionesinsumo.contrato_id, descuento: @migracionesinsumo.descuento, estado: @migracionesinsumo.estado, insumo_id: @migracionesinsumo.insumo_id, precio_condescuento: @migracionesinsumo.precio_condescuento, precio_unitario: @migracionesinsumo.precio_unitario, total: @migracionesinsumo.total, user_id: @migracionesinsumo.user_id } }
    assert_redirected_to migracionesinsumo_url(@migracionesinsumo)
  end

  test "should destroy migracionesinsumo" do
    assert_difference('Migracionesinsumo.count', -1) do
      delete migracionesinsumo_url(@migracionesinsumo)
    end

    assert_redirected_to migracionesinsumos_url
  end
end
