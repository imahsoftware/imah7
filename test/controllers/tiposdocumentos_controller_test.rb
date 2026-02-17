require 'test_helper'

class TiposdocumentosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tiposdocumento = tiposdocumentos(:one)
  end

  test "should get index" do
    get tiposdocumentos_url
    assert_response :success
  end

  test "should get new" do
    get new_tiposdocumento_url
    assert_response :success
  end

  test "should create tiposdocumento" do
    assert_difference('Tiposdocumento.count') do
      post tiposdocumentos_url, params: { tiposdocumento: { descripcion: @tiposdocumento.descripcion } }
    end

    assert_redirected_to tiposdocumento_url(Tiposdocumento.last)
  end

  test "should show tiposdocumento" do
    get tiposdocumento_url(@tiposdocumento)
    assert_response :success
  end

  test "should get edit" do
    get edit_tiposdocumento_url(@tiposdocumento)
    assert_response :success
  end

  test "should update tiposdocumento" do
    patch tiposdocumento_url(@tiposdocumento), params: { tiposdocumento: { descripcion: @tiposdocumento.descripcion } }
    assert_redirected_to tiposdocumento_url(@tiposdocumento)
  end

  test "should destroy tiposdocumento" do
    assert_difference('Tiposdocumento.count', -1) do
      delete tiposdocumento_url(@tiposdocumento)
    end

    assert_redirected_to tiposdocumentos_url
  end
end
