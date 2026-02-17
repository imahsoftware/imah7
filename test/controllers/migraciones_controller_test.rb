require 'test_helper'

class MigracionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @migracion = migraciones(:one)
  end

  test "should get index" do
    get migraciones_url
    assert_response :success
  end

  test "should get new" do
    get new_migracion_url
    assert_response :success
  end

  test "should create migracion" do
    assert_difference('Migracion.count') do
      post migraciones_url, params: { migracion: { estado: @migracion.estado, nombre: @migracion.nombre } }
    end

    assert_redirected_to migracion_url(Migracion.last)
  end

  test "should show migracion" do
    get migracion_url(@migracion)
    assert_response :success
  end

  test "should get edit" do
    get edit_migracion_url(@migracion)
    assert_response :success
  end

  test "should update migracion" do
    patch migracion_url(@migracion), params: { migracion: { estado: @migracion.estado, nombre: @migracion.nombre } }
    assert_redirected_to migracion_url(@migracion)
  end

  test "should destroy migracion" do
    assert_difference('Migracion.count', -1) do
      delete migracion_url(@migracion)
    end

    assert_redirected_to migraciones_url
  end
end
