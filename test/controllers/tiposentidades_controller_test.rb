require 'test_helper'

class TiposentidadesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tiposentidad = tiposentidades(:one)
  end

  test "should get index" do
    get tiposentidades_url
    assert_response :success
  end

  test "should get new" do
    get new_tiposentidad_url
    assert_response :success
  end

  test "should create tiposentidad" do
    assert_difference('Tiposentidad.count') do
      post tiposentidades_url, params: { tiposentidad: { descripcion: @tiposentidad.descripcion, estado: @tiposentidad.estado, identificacion: @tiposentidad.identificacion, nombre: @tiposentidad.nombre, user_id: @tiposentidad.user_id } }
    end

    assert_redirected_to tiposentidad_url(Tiposentidad.last)
  end

  test "should show tiposentidad" do
    get tiposentidad_url(@tiposentidad)
    assert_response :success
  end

  test "should get edit" do
    get edit_tiposentidad_url(@tiposentidad)
    assert_response :success
  end

  test "should update tiposentidad" do
    patch tiposentidad_url(@tiposentidad), params: { tiposentidad: { descripcion: @tiposentidad.descripcion, estado: @tiposentidad.estado, identificacion: @tiposentidad.identificacion, nombre: @tiposentidad.nombre, user_id: @tiposentidad.user_id } }
    assert_redirected_to tiposentidad_url(@tiposentidad)
  end

  test "should destroy tiposentidad" do
    assert_difference('Tiposentidad.count', -1) do
      delete tiposentidad_url(@tiposentidad)
    end

    assert_redirected_to tiposentidades_url
  end
end
