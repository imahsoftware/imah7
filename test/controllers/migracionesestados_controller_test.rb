require 'test_helper'

class MigracionesestadosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @migracionesestado = migracionesestados(:one)
  end

  test "should get index" do
    get migracionesestados_url
    assert_response :success
  end

  test "should get new" do
    get new_migracionesestado_url
    assert_response :success
  end

  test "should create migracionesestado" do
    assert_difference('Migracionesestado.count') do
      post migracionesestados_url, params: { migracionesestado: { archivo_id: @migracionesestado.archivo_id, error: @migracionesestado.error, estado: @migracionesestado.estado, estado_cargue: @migracionesestado.estado_cargue, observacion_eps: @migracionesestado.observacion_eps, personasformulario_id: @migracionesestado.personasformulario_id, tipo: @migracionesestado.tipo, user_id: @migracionesestado.user_id } }
    end

    assert_redirected_to migracionesestado_url(Migracionesestado.last)
  end

  test "should show migracionesestado" do
    get migracionesestado_url(@migracionesestado)
    assert_response :success
  end

  test "should get edit" do
    get edit_migracionesestado_url(@migracionesestado)
    assert_response :success
  end

  test "should update migracionesestado" do
    patch migracionesestado_url(@migracionesestado), params: { migracionesestado: { archivo_id: @migracionesestado.archivo_id, error: @migracionesestado.error, estado: @migracionesestado.estado, estado_cargue: @migracionesestado.estado_cargue, observacion_eps: @migracionesestado.observacion_eps, personasformulario_id: @migracionesestado.personasformulario_id, tipo: @migracionesestado.tipo, user_id: @migracionesestado.user_id } }
    assert_redirected_to migracionesestado_url(@migracionesestado)
  end

  test "should destroy migracionesestado" do
    assert_difference('Migracionesestado.count', -1) do
      delete migracionesestado_url(@migracionesestado)
    end

    assert_redirected_to migracionesestados_url
  end
end
