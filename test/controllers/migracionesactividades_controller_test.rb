require 'test_helper'

class MigracionesactividadesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @migracionesactividad = migracionesactividades(:one)
  end

  test "should get index" do
    get migracionesactividades_url
    assert_response :success
  end

  test "should get new" do
    get new_migracionesactividad_url
    assert_response :success
  end

  test "should create migracionesactividad" do
    assert_difference('Migracionesactividad.count') do
      post migracionesactividades_url, params: { migracionesactividad: { archivo_id: @migracionesactividad.archivo_id, dias: @migracionesactividad.dias, estado: @migracionesactividad.estado, estado_actividad: @migracionesactividad.estado_actividad, tareasactividad_id: @migracionesactividad.tareasactividad_id, user_id: @migracionesactividad.user_id, user_persona: @migracionesactividad.user_persona } }
    end

    assert_redirected_to migracionesactividad_url(Migracionesactividad.last)
  end

  test "should show migracionesactividad" do
    get migracionesactividad_url(@migracionesactividad)
    assert_response :success
  end

  test "should get edit" do
    get edit_migracionesactividad_url(@migracionesactividad)
    assert_response :success
  end

  test "should update migracionesactividad" do
    patch migracionesactividad_url(@migracionesactividad), params: { migracionesactividad: { archivo_id: @migracionesactividad.archivo_id, dias: @migracionesactividad.dias, estado: @migracionesactividad.estado, estado_actividad: @migracionesactividad.estado_actividad, tareasactividad_id: @migracionesactividad.tareasactividad_id, user_id: @migracionesactividad.user_id, user_persona: @migracionesactividad.user_persona } }
    assert_redirected_to migracionesactividad_url(@migracionesactividad)
  end

  test "should destroy migracionesactividad" do
    assert_difference('Migracionesactividad.count', -1) do
      delete migracionesactividad_url(@migracionesactividad)
    end

    assert_redirected_to migracionesactividades_url
  end
end
