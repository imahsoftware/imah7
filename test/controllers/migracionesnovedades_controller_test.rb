require 'test_helper'

class MigracionesnovedadesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @migracionesnovedad = migracionesnovedades(:one)
  end

  test "should get index" do
    get migracionesnovedades_url
    assert_response :success
  end

  test "should get new" do
    get new_migracionesnovedad_url
    assert_response :success
  end

  test "should create migracionesnovedad" do
    assert_difference('Migracionesnovedad.count') do
      post migracionesnovedades_url, params: { migracionesnovedad: { archivo_id: @migracionesnovedad.archivo_id, contrato_id: @migracionesnovedad.contrato_id, contratosgrupo_id: @migracionesnovedad.contratosgrupo_id, contratospersona_id: @migracionesnovedad.contratospersona_id, estado: @migracionesnovedad.estado, identificacion: @migracionesnovedad.identificacion, nov_10: @migracionesnovedad.nov_10, nov_11: @migracionesnovedad.nov_11, nov_12: @migracionesnovedad.nov_12, nov_14: @migracionesnovedad.nov_14, nov_16: @migracionesnovedad.nov_16, nov_18: @migracionesnovedad.nov_18, nov_19: @migracionesnovedad.nov_19, nov_1: @migracionesnovedad.nov_1, nov_22: @migracionesnovedad.nov_22, nov_2: @migracionesnovedad.nov_2, nov_3: @migracionesnovedad.nov_3, nov_40: @migracionesnovedad.nov_40, nov_41: @migracionesnovedad.nov_41, nov_42: @migracionesnovedad.nov_42, nov_43: @migracionesnovedad.nov_43, nov_44: @migracionesnovedad.nov_44, nov_46: @migracionesnovedad.nov_46, nov_47: @migracionesnovedad.nov_47, nov_49: @migracionesnovedad.nov_49, nov_4: @migracionesnovedad.nov_4, nov_50: @migracionesnovedad.nov_50, nov_53: @migracionesnovedad.nov_53, nov_55: @migracionesnovedad.nov_55, nov_56: @migracionesnovedad.nov_56, nov_57: @migracionesnovedad.nov_57, nov_5: @migracionesnovedad.nov_5, nov_6: @migracionesnovedad.nov_6, nov_7: @migracionesnovedad.nov_7, nov_8: @migracionesnovedad.nov_8, nov_9: @migracionesnovedad.nov_9, observacion: @migracionesnovedad.observacion, periodosliquidacion_id: @migracionesnovedad.periodosliquidacion_id, user_id: @migracionesnovedad.user_id } }
    end

    assert_redirected_to migracionesnovedad_url(Migracionesnovedad.last)
  end

  test "should show migracionesnovedad" do
    get migracionesnovedad_url(@migracionesnovedad)
    assert_response :success
  end

  test "should get edit" do
    get edit_migracionesnovedad_url(@migracionesnovedad)
    assert_response :success
  end

  test "should update migracionesnovedad" do
    patch migracionesnovedad_url(@migracionesnovedad), params: { migracionesnovedad: { archivo_id: @migracionesnovedad.archivo_id, contrato_id: @migracionesnovedad.contrato_id, contratosgrupo_id: @migracionesnovedad.contratosgrupo_id, contratospersona_id: @migracionesnovedad.contratospersona_id, estado: @migracionesnovedad.estado, identificacion: @migracionesnovedad.identificacion, nov_10: @migracionesnovedad.nov_10, nov_11: @migracionesnovedad.nov_11, nov_12: @migracionesnovedad.nov_12, nov_14: @migracionesnovedad.nov_14, nov_16: @migracionesnovedad.nov_16, nov_18: @migracionesnovedad.nov_18, nov_19: @migracionesnovedad.nov_19, nov_1: @migracionesnovedad.nov_1, nov_22: @migracionesnovedad.nov_22, nov_2: @migracionesnovedad.nov_2, nov_3: @migracionesnovedad.nov_3, nov_40: @migracionesnovedad.nov_40, nov_41: @migracionesnovedad.nov_41, nov_42: @migracionesnovedad.nov_42, nov_43: @migracionesnovedad.nov_43, nov_44: @migracionesnovedad.nov_44, nov_46: @migracionesnovedad.nov_46, nov_47: @migracionesnovedad.nov_47, nov_49: @migracionesnovedad.nov_49, nov_4: @migracionesnovedad.nov_4, nov_50: @migracionesnovedad.nov_50, nov_53: @migracionesnovedad.nov_53, nov_55: @migracionesnovedad.nov_55, nov_56: @migracionesnovedad.nov_56, nov_57: @migracionesnovedad.nov_57, nov_5: @migracionesnovedad.nov_5, nov_6: @migracionesnovedad.nov_6, nov_7: @migracionesnovedad.nov_7, nov_8: @migracionesnovedad.nov_8, nov_9: @migracionesnovedad.nov_9, observacion: @migracionesnovedad.observacion, periodosliquidacion_id: @migracionesnovedad.periodosliquidacion_id, user_id: @migracionesnovedad.user_id } }
    assert_redirected_to migracionesnovedad_url(@migracionesnovedad)
  end

  test "should destroy migracionesnovedad" do
    assert_difference('Migracionesnovedad.count', -1) do
      delete migracionesnovedad_url(@migracionesnovedad)
    end

    assert_redirected_to migracionesnovedades_url
  end
end
