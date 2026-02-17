require 'test_helper'

class TipospretencionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tipospretencion = tipospretenciones(:one)
  end

  test "should get index" do
    get tipospretenciones_url
    assert_response :success
  end

  test "should get new" do
    get new_tipospretencion_url
    assert_response :success
  end

  test "should create tipospretencion" do
    assert_difference('Tipospretencion.count') do
      post tipospretenciones_url, params: { tipospretencion: { codigo: @tipospretencion.codigo, descripcion: @tipospretencion.descripcion, estado: @tipospretencion.estado } }
    end

    assert_redirected_to tipospretencion_url(Tipospretencion.last)
  end

  test "should show tipospretencion" do
    get tipospretencion_url(@tipospretencion)
    assert_response :success
  end

  test "should get edit" do
    get edit_tipospretencion_url(@tipospretencion)
    assert_response :success
  end

  test "should update tipospretencion" do
    patch tipospretencion_url(@tipospretencion), params: { tipospretencion: { codigo: @tipospretencion.codigo, descripcion: @tipospretencion.descripcion, estado: @tipospretencion.estado } }
    assert_redirected_to tipospretencion_url(@tipospretencion)
  end

  test "should destroy tipospretencion" do
    assert_difference('Tipospretencion.count', -1) do
      delete tipospretencion_url(@tipospretencion)
    end

    assert_redirected_to tipospretenciones_url
  end
end
