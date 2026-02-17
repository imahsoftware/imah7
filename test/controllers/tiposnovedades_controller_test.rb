require 'test_helper'

class TiposnovedadesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tiposnovedad = tiposnovedades(:one)
  end

  test "should get index" do
    get tiposnovedades_url
    assert_response :success
  end

  test "should get new" do
    get new_tiposnovedad_url
    assert_response :success
  end

  test "should create tiposnovedad" do
    assert_difference('Tiposnovedad.count') do
      post tiposnovedades_url, params: { tiposnovedad: { codigo: @tiposnovedad.codigo, descripcion: @tiposnovedad.descripcion, estado: @tiposnovedad.estado, tipo: @tiposnovedad.tipo } }
    end

    assert_redirected_to tiposnovedad_url(Tiposnovedad.last)
  end

  test "should show tiposnovedad" do
    get tiposnovedad_url(@tiposnovedad)
    assert_response :success
  end

  test "should get edit" do
    get edit_tiposnovedad_url(@tiposnovedad)
    assert_response :success
  end

  test "should update tiposnovedad" do
    patch tiposnovedad_url(@tiposnovedad), params: { tiposnovedad: { codigo: @tiposnovedad.codigo, descripcion: @tiposnovedad.descripcion, estado: @tiposnovedad.estado, tipo: @tiposnovedad.tipo } }
    assert_redirected_to tiposnovedad_url(@tiposnovedad)
  end

  test "should destroy tiposnovedad" do
    assert_difference('Tiposnovedad.count', -1) do
      delete tiposnovedad_url(@tiposnovedad)
    end

    assert_redirected_to tiposnovedades_url
  end
end
