require 'test_helper'

class MigracionesexamenesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @migracionesexamen = migracionesexamenes(:one)
  end

  test "should get index" do
    get migracionesexamenes_url
    assert_response :success
  end

  test "should get new" do
    get new_migracionesexamen_url
    assert_response :success
  end

  test "should create migracionesexamen" do
    assert_difference('Migracionesexamen.count') do
      post migracionesexamenes_url, params: { migracionesexamen: { archivo_id: @migracionesexamen.archivo_id, descripcion: @migracionesexamen.descripcion, direccion: @migracionesexamen.direccion, error: @migracionesexamen.error, estado: @migracionesexamen.estado, estado_cargue: @migracionesexamen.estado_cargue, fecha: @migracionesexamen.fecha, hora: @migracionesexamen.hora, observacion_eps: @migracionesexamen.observacion_eps, personasformulario_id: @migracionesexamen.personasformulario_id, recomendaciones: @migracionesexamen.recomendaciones, user_id: @migracionesexamen.user_id } }
    end

    assert_redirected_to migracionesexamen_url(Migracionesexamen.last)
  end

  test "should show migracionesexamen" do
    get migracionesexamen_url(@migracionesexamen)
    assert_response :success
  end

  test "should get edit" do
    get edit_migracionesexamen_url(@migracionesexamen)
    assert_response :success
  end

  test "should update migracionesexamen" do
    patch migracionesexamen_url(@migracionesexamen), params: { migracionesexamen: { archivo_id: @migracionesexamen.archivo_id, descripcion: @migracionesexamen.descripcion, direccion: @migracionesexamen.direccion, error: @migracionesexamen.error, estado: @migracionesexamen.estado, estado_cargue: @migracionesexamen.estado_cargue, fecha: @migracionesexamen.fecha, hora: @migracionesexamen.hora, observacion_eps: @migracionesexamen.observacion_eps, personasformulario_id: @migracionesexamen.personasformulario_id, recomendaciones: @migracionesexamen.recomendaciones, user_id: @migracionesexamen.user_id } }
    assert_redirected_to migracionesexamen_url(@migracionesexamen)
  end

  test "should destroy migracionesexamen" do
    assert_difference('Migracionesexamen.count', -1) do
      delete migracionesexamen_url(@migracionesexamen)
    end

    assert_redirected_to migracionesexamenes_url
  end
end
