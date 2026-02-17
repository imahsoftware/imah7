require 'test_helper'

class MigracionesrodamientosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @migracionesrodamiento = migracionesrodamientos(:one)
  end

  test "should get index" do
    get migracionesrodamientos_url
    assert_response :success
  end

  test "should get new" do
    get new_migracionesrodamiento_url
    assert_response :success
  end

  test "should create migracionesrodamiento" do
    assert_difference('Migracionesrodamiento.count') do
      post migracionesrodamientos_url, params: { migracionesrodamiento: { archivo_id: @migracionesrodamiento.archivo_id, contrato_id: @migracionesrodamiento.contrato_id, detalle: @migracionesrodamiento.detalle, estado: @migracionesrodamiento.estado, identificacion: @migracionesrodamiento.identificacion, nombre: @migracionesrodamiento.nombre, nro_dias: @migracionesrodamiento.nro_dias, periodosliquidacion_id: @migracionesrodamiento.periodosliquidacion_id, user_id: @migracionesrodamiento.user_id, valor_dia: @migracionesrodamiento.valor_dia, valor_total: @migracionesrodamiento.valor_total } }
    end

    assert_redirected_to migracionesrodamiento_url(Migracionesrodamiento.last)
  end

  test "should show migracionesrodamiento" do
    get migracionesrodamiento_url(@migracionesrodamiento)
    assert_response :success
  end

  test "should get edit" do
    get edit_migracionesrodamiento_url(@migracionesrodamiento)
    assert_response :success
  end

  test "should update migracionesrodamiento" do
    patch migracionesrodamiento_url(@migracionesrodamiento), params: { migracionesrodamiento: { archivo_id: @migracionesrodamiento.archivo_id, contrato_id: @migracionesrodamiento.contrato_id, detalle: @migracionesrodamiento.detalle, estado: @migracionesrodamiento.estado, identificacion: @migracionesrodamiento.identificacion, nombre: @migracionesrodamiento.nombre, nro_dias: @migracionesrodamiento.nro_dias, periodosliquidacion_id: @migracionesrodamiento.periodosliquidacion_id, user_id: @migracionesrodamiento.user_id, valor_dia: @migracionesrodamiento.valor_dia, valor_total: @migracionesrodamiento.valor_total } }
    assert_redirected_to migracionesrodamiento_url(@migracionesrodamiento)
  end

  test "should destroy migracionesrodamiento" do
    assert_difference('Migracionesrodamiento.count', -1) do
      delete migracionesrodamiento_url(@migracionesrodamiento)
    end

    assert_redirected_to migracionesrodamientos_url
  end
end
