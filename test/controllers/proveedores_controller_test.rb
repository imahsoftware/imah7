require 'test_helper'

class ProveedoresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @proveedor = proveedores(:one)
  end

  test "should get index" do
    get proveedores_url
    assert_response :success
  end

  test "should get new" do
    get new_proveedor_url
    assert_response :success
  end

  test "should create proveedor" do
    assert_difference('Proveedor.count') do
      post proveedores_url, params: { proveedor: { celular: @proveedor.celular, direccion: @proveedor.direccion, email: @proveedor.email, entidad: @proveedor.entidad, estado: @proveedor.estado, identificacion: @proveedor.identificacion, identificacion_cuenta: @proveedor.identificacion_cuenta, municipio_id: @proveedor.municipio_id, nombre_camara: @proveedor.nombre_camara, nombre_proveedor: @proveedor.nombre_proveedor, nro_cuenta: @proveedor.nro_cuenta, pertenece_cuenta: @proveedor.pertenece_cuenta, telefono: @proveedor.telefono, tipo_cuenta: @proveedor.tipo_cuenta, user_act: @proveedor.user_act, user_id: @proveedor.user_id } }
    end

    assert_redirected_to proveedor_url(Proveedor.last)
  end

  test "should show proveedor" do
    get proveedor_url(@proveedor)
    assert_response :success
  end

  test "should get edit" do
    get edit_proveedor_url(@proveedor)
    assert_response :success
  end

  test "should update proveedor" do
    patch proveedor_url(@proveedor), params: { proveedor: { celular: @proveedor.celular, direccion: @proveedor.direccion, email: @proveedor.email, entidad: @proveedor.entidad, estado: @proveedor.estado, identificacion: @proveedor.identificacion, identificacion_cuenta: @proveedor.identificacion_cuenta, municipio_id: @proveedor.municipio_id, nombre_camara: @proveedor.nombre_camara, nombre_proveedor: @proveedor.nombre_proveedor, nro_cuenta: @proveedor.nro_cuenta, pertenece_cuenta: @proveedor.pertenece_cuenta, telefono: @proveedor.telefono, tipo_cuenta: @proveedor.tipo_cuenta, user_act: @proveedor.user_act, user_id: @proveedor.user_id } }
    assert_redirected_to proveedor_url(@proveedor)
  end

  test "should destroy proveedor" do
    assert_difference('Proveedor.count', -1) do
      delete proveedor_url(@proveedor)
    end

    assert_redirected_to proveedores_url
  end
end
