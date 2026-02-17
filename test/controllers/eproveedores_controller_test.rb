require 'test_helper'

class EproveedoresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @eproveedor = eproveedores(:one)
  end

  test "should get index" do
    get eproveedores_url
    assert_response :success
  end

  test "should get new" do
    get new_eproveedor_url
    assert_response :success
  end

  test "should create eproveedor" do
    assert_difference('Eproveedor.count') do
      post eproveedores_url, params: { eproveedor: { apellido: @eproveedor.apellido, autorretenedor2: @eproveedor.autorretenedor2, autorretenedor3: @eproveedor.autorretenedor3, autorretenedor: @eproveedor.autorretenedor, celular: @eproveedor.celular, clasificacion: @eproveedor.clasificacion, declarante: @eproveedor.declarante, digito: @eproveedor.digito, direccion: @eproveedor.direccion, email: @eproveedor.email, etapa: @eproveedor.etapa, identificacion: @eproveedor.identificacion, municipio_id: @eproveedor.municipio_id, nombre: @eproveedor.nombre, responsable: @eproveedor.responsable, responsableiva: @eproveedor.responsableiva, retefuente: @eproveedor.retefuente, telefono: @eproveedor.telefono, tipodoc: @eproveedor.tipodoc, user_id: @eproveedor.user_id } }
    end

    assert_redirected_to eproveedor_url(Eproveedor.last)
  end

  test "should show eproveedor" do
    get eproveedor_url(@eproveedor)
    assert_response :success
  end

  test "should get edit" do
    get edit_eproveedor_url(@eproveedor)
    assert_response :success
  end

  test "should update eproveedor" do
    patch eproveedor_url(@eproveedor), params: { eproveedor: { apellido: @eproveedor.apellido, autorretenedor2: @eproveedor.autorretenedor2, autorretenedor3: @eproveedor.autorretenedor3, autorretenedor: @eproveedor.autorretenedor, celular: @eproveedor.celular, clasificacion: @eproveedor.clasificacion, declarante: @eproveedor.declarante, digito: @eproveedor.digito, direccion: @eproveedor.direccion, email: @eproveedor.email, etapa: @eproveedor.etapa, identificacion: @eproveedor.identificacion, municipio_id: @eproveedor.municipio_id, nombre: @eproveedor.nombre, responsable: @eproveedor.responsable, responsableiva: @eproveedor.responsableiva, retefuente: @eproveedor.retefuente, telefono: @eproveedor.telefono, tipodoc: @eproveedor.tipodoc, user_id: @eproveedor.user_id } }
    assert_redirected_to eproveedor_url(@eproveedor)
  end

  test "should destroy eproveedor" do
    assert_difference('Eproveedor.count', -1) do
      delete eproveedor_url(@eproveedor)
    end

    assert_redirected_to eproveedores_url
  end
end
