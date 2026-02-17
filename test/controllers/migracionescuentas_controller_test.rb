require 'test_helper'

class MigracionescuentasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @migracionescuenta = migracionescuentas(:one)
  end

  test "should get index" do
    get migracionescuentas_url
    assert_response :success
  end

  test "should get new" do
    get new_migracionescuenta_url
    assert_response :success
  end

  test "should create migracionescuenta" do
    assert_difference('Migracionescuenta.count') do
      post migracionescuentas_url, params: { migracionescuenta: { archivo_id: @migracionescuenta.archivo_id, estado: @migracionescuenta.estado, identificacion: @migracionescuenta.identificacion, nro_cuenta: @migracionescuenta.nro_cuenta, user_id: @migracionescuenta.user_id } }
    end

    assert_redirected_to migracionescuenta_url(Migracionescuenta.last)
  end

  test "should show migracionescuenta" do
    get migracionescuenta_url(@migracionescuenta)
    assert_response :success
  end

  test "should get edit" do
    get edit_migracionescuenta_url(@migracionescuenta)
    assert_response :success
  end

  test "should update migracionescuenta" do
    patch migracionescuenta_url(@migracionescuenta), params: { migracionescuenta: { archivo_id: @migracionescuenta.archivo_id, estado: @migracionescuenta.estado, identificacion: @migracionescuenta.identificacion, nro_cuenta: @migracionescuenta.nro_cuenta, user_id: @migracionescuenta.user_id } }
    assert_redirected_to migracionescuenta_url(@migracionescuenta)
  end

  test "should destroy migracionescuenta" do
    assert_difference('Migracionescuenta.count', -1) do
      delete migracionescuenta_url(@migracionescuenta)
    end

    assert_redirected_to migracionescuentas_url
  end
end
