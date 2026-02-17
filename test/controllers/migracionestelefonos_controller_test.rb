require 'test_helper'

class MigracionestelefonosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @migracionestelefono = migracionestelefonos(:one)
  end

  test "should get index" do
    get migracionestelefonos_url
    assert_response :success
  end

  test "should get new" do
    get new_migracionestelefono_url
    assert_response :success
  end

  test "should create migracionestelefono" do
    assert_difference('Migracionestelefono.count') do
      post migracionestelefonos_url, params: { migracionestelefono: { archivo_id: @migracionestelefono.archivo_id, estado: @migracionestelefono.estado, identificacion: @migracionestelefono.identificacion, telefono: @migracionestelefono.telefono, user_id: @migracionestelefono.user_id } }
    end

    assert_redirected_to migracionestelefono_url(Migracionestelefono.last)
  end

  test "should show migracionestelefono" do
    get migracionestelefono_url(@migracionestelefono)
    assert_response :success
  end

  test "should get edit" do
    get edit_migracionestelefono_url(@migracionestelefono)
    assert_response :success
  end

  test "should update migracionestelefono" do
    patch migracionestelefono_url(@migracionestelefono), params: { migracionestelefono: { archivo_id: @migracionestelefono.archivo_id, estado: @migracionestelefono.estado, identificacion: @migracionestelefono.identificacion, telefono: @migracionestelefono.telefono, user_id: @migracionestelefono.user_id } }
    assert_redirected_to migracionestelefono_url(@migracionestelefono)
  end

  test "should destroy migracionestelefono" do
    assert_difference('Migracionestelefono.count', -1) do
      delete migracionestelefono_url(@migracionestelefono)
    end

    assert_redirected_to migracionestelefonos_url
  end
end
