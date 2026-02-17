require 'test_helper'

class EmpresasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @empresa = empresas(:one)
  end

  test "should get index" do
    get empresas_url
    assert_response :success
  end

  test "should get new" do
    get new_empresa_url
    assert_response :success
  end

  test "should create empresa" do
    assert_difference('Empresa.count') do
      post empresas_url, params: { empresa: { celular: @empresa.celular, contacto: @empresa.contacto, digito: @empresa.digito, dircampo1: @empresa.dircampo1, dircampo2: @empresa.dircampo2, dircampo3: @empresa.dircampo3, dircampo4: @empresa.dircampo4, dircampo5: @empresa.dircampo5, dircampo6: @empresa.dircampo6, dircampo7: @empresa.dircampo7, dircampo8: @empresa.dircampo8, dircampo9: @empresa.dircampo9, direccion: @empresa.direccion, email: @empresa.email, identificacion: @empresa.identificacion, municipio_id: @empresa.municipio_id, nombre: @empresa.nombre, paginaweb: @empresa.paginaweb, representante_legal: @empresa.representante_legal, tiposdocumento_id: @empresa.tiposdocumento_id, user_act: @empresa.user_act, user_id: @empresa.user_id } }
    end

    assert_redirected_to empresa_url(Empresa.last)
  end

  test "should show empresa" do
    get empresa_url(@empresa)
    assert_response :success
  end

  test "should get edit" do
    get edit_empresa_url(@empresa)
    assert_response :success
  end

  test "should update empresa" do
    patch empresa_url(@empresa), params: { empresa: { celular: @empresa.celular, contacto: @empresa.contacto, digito: @empresa.digito, dircampo1: @empresa.dircampo1, dircampo2: @empresa.dircampo2, dircampo3: @empresa.dircampo3, dircampo4: @empresa.dircampo4, dircampo5: @empresa.dircampo5, dircampo6: @empresa.dircampo6, dircampo7: @empresa.dircampo7, dircampo8: @empresa.dircampo8, dircampo9: @empresa.dircampo9, direccion: @empresa.direccion, email: @empresa.email, identificacion: @empresa.identificacion, municipio_id: @empresa.municipio_id, nombre: @empresa.nombre, paginaweb: @empresa.paginaweb, representante_legal: @empresa.representante_legal, tiposdocumento_id: @empresa.tiposdocumento_id, user_act: @empresa.user_act, user_id: @empresa.user_id } }
    assert_redirected_to empresa_url(@empresa)
  end

  test "should destroy empresa" do
    assert_difference('Empresa.count', -1) do
      delete empresa_url(@empresa)
    end

    assert_redirected_to empresas_url
  end
end
