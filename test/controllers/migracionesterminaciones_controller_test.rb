require 'test_helper'

class MigracionesterminacionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @migracionesterminacion = migracionesterminaciones(:one)
  end

  test "should get index" do
    get migracionesterminaciones_url
    assert_response :success
  end

  test "should get new" do
    get new_migracionesterminacion_url
    assert_response :success
  end

  test "should create migracionesterminacion" do
    assert_difference('Migracionesterminacion.count') do
      post migracionesterminaciones_url, params: { migracionesterminacion: { archivo_id: @migracionesterminacion.archivo_id, contratosperfecha_id: @migracionesterminacion.contratosperfecha_id, contratospersona_id: @migracionesterminacion.contratospersona_id, contratospervalidacion: @migracionesterminacion.contratospervalidacion, estado: @migracionesterminacion.estado, fecha_fin: @migracionesterminacion.fecha_fin, identificacion: @migracionesterminacion.identificacion, user_id: @migracionesterminacion.user_id } }
    end

    assert_redirected_to migracionesterminacion_url(Migracionesterminacion.last)
  end

  test "should show migracionesterminacion" do
    get migracionesterminacion_url(@migracionesterminacion)
    assert_response :success
  end

  test "should get edit" do
    get edit_migracionesterminacion_url(@migracionesterminacion)
    assert_response :success
  end

  test "should update migracionesterminacion" do
    patch migracionesterminacion_url(@migracionesterminacion), params: { migracionesterminacion: { archivo_id: @migracionesterminacion.archivo_id, contratosperfecha_id: @migracionesterminacion.contratosperfecha_id, contratospersona_id: @migracionesterminacion.contratospersona_id, contratospervalidacion: @migracionesterminacion.contratospervalidacion, estado: @migracionesterminacion.estado, fecha_fin: @migracionesterminacion.fecha_fin, identificacion: @migracionesterminacion.identificacion, user_id: @migracionesterminacion.user_id } }
    assert_redirected_to migracionesterminacion_url(@migracionesterminacion)
  end

  test "should destroy migracionesterminacion" do
    assert_difference('Migracionesterminacion.count', -1) do
      delete migracionesterminacion_url(@migracionesterminacion)
    end

    assert_redirected_to migracionesterminaciones_url
  end
end
