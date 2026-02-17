require 'test_helper'

class ProveedorescontactosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @proveedorescontacto = proveedorescontactos(:one)
  end

  test "should get index" do
    get proveedorescontactos_url
    assert_response :success
  end

  test "should get new" do
    get new_proveedorescontacto_url
    assert_response :success
  end

  test "should create proveedorescontacto" do
    assert_difference('Proveedorescontacto.count') do
      post proveedorescontactos_url, params: { proveedorescontacto: { cargo: @proveedorescontacto.cargo, email: @proveedorescontacto.email, estado: @proveedorescontacto.estado, nombre: @proveedorescontacto.nombre, proveedor_id: @proveedorescontacto.proveedor_id, telefono: @proveedorescontacto.telefono, user_act: @proveedorescontacto.user_act, user_id: @proveedorescontacto.user_id } }
    end

    assert_redirected_to proveedorescontacto_url(Proveedorescontacto.last)
  end

  test "should show proveedorescontacto" do
    get proveedorescontacto_url(@proveedorescontacto)
    assert_response :success
  end

  test "should get edit" do
    get edit_proveedorescontacto_url(@proveedorescontacto)
    assert_response :success
  end

  test "should update proveedorescontacto" do
    patch proveedorescontacto_url(@proveedorescontacto), params: { proveedorescontacto: { cargo: @proveedorescontacto.cargo, email: @proveedorescontacto.email, estado: @proveedorescontacto.estado, nombre: @proveedorescontacto.nombre, proveedor_id: @proveedorescontacto.proveedor_id, telefono: @proveedorescontacto.telefono, user_act: @proveedorescontacto.user_act, user_id: @proveedorescontacto.user_id } }
    assert_redirected_to proveedorescontacto_url(@proveedorescontacto)
  end

  test "should destroy proveedorescontacto" do
    assert_difference('Proveedorescontacto.count', -1) do
      delete proveedorescontacto_url(@proveedorescontacto)
    end

    assert_redirected_to proveedorescontactos_url
  end
end
