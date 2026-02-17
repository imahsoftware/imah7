require 'test_helper'

class MigracionespersonasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @migracionespersona = migracionespersonas(:one)
  end

  test "should get index" do
    get migracionespersonas_url
    assert_response :success
  end

  test "should get new" do
    get new_migracionespersona_url
    assert_response :success
  end

  test "should create migracionespersona" do
    assert_difference('Migracionespersona.count') do
      post migracionespersonas_url, params: { migracionespersona: { archivo_id: @migracionespersona.archivo_id, cargo_id: @migracionespersona.cargo_id, celular: @migracionespersona.celular, colegio: @migracionespersona.colegio, correo: @migracionespersona.correo, departamento: @migracionespersona.departamento, error: @migracionespersona.error, estado_cargue: @migracionespersona.estado_cargue, estado_correo: @migracionespersona.estado_correo, estado_sms: @migracionespersona.estado_sms, identificacion: @migracionespersona.identificacion, lote: @migracionespersona.lote, municipio: @migracionespersona.municipio, nombre: @migracionespersona.nombre, observacion: @migracionespersona.observacion, user_id: @migracionespersona.user_id } }
    end

    assert_redirected_to migracionespersona_url(Migracionespersona.last)
  end

  test "should show migracionespersona" do
    get migracionespersona_url(@migracionespersona)
    assert_response :success
  end

  test "should get edit" do
    get edit_migracionespersona_url(@migracionespersona)
    assert_response :success
  end

  test "should update migracionespersona" do
    patch migracionespersona_url(@migracionespersona), params: { migracionespersona: { archivo_id: @migracionespersona.archivo_id, cargo_id: @migracionespersona.cargo_id, celular: @migracionespersona.celular, colegio: @migracionespersona.colegio, correo: @migracionespersona.correo, departamento: @migracionespersona.departamento, error: @migracionespersona.error, estado_cargue: @migracionespersona.estado_cargue, estado_correo: @migracionespersona.estado_correo, estado_sms: @migracionespersona.estado_sms, identificacion: @migracionespersona.identificacion, lote: @migracionespersona.lote, municipio: @migracionespersona.municipio, nombre: @migracionespersona.nombre, observacion: @migracionespersona.observacion, user_id: @migracionespersona.user_id } }
    assert_redirected_to migracionespersona_url(@migracionespersona)
  end

  test "should destroy migracionespersona" do
    assert_difference('Migracionespersona.count', -1) do
      delete migracionespersona_url(@migracionespersona)
    end

    assert_redirected_to migracionespersonas_url
  end
end
