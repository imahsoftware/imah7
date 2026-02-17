require 'test_helper'

class BitacoraprocesosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bitacoraproceso = bitacoraprocesos(:one)
  end

  test "should get index" do
    get bitacoraprocesos_url
    assert_response :success
  end

  test "should get new" do
    get new_bitacoraproceso_url
    assert_response :success
  end

  test "should create bitacoraproceso" do
    assert_difference('Bitacoraproceso.count') do
      post bitacoraprocesos_url, params: { bitacoraproceso: { codigo: @bitacoraproceso.codigo, codigo_firma: @bitacoraproceso.codigo_firma, codigo_recibido: @bitacoraproceso.codigo_recibido, controlador_tabla: @bitacoraproceso.controlador_tabla, fecha_firma: @bitacoraproceso.fecha_firma, id_tabla: @bitacoraproceso.id_tabla, proceso: @bitacoraproceso.proceso, user_id: @bitacoraproceso.user_id } }
    end

    assert_redirected_to bitacoraproceso_url(Bitacoraproceso.last)
  end

  test "should show bitacoraproceso" do
    get bitacoraproceso_url(@bitacoraproceso)
    assert_response :success
  end

  test "should get edit" do
    get edit_bitacoraproceso_url(@bitacoraproceso)
    assert_response :success
  end

  test "should update bitacoraproceso" do
    patch bitacoraproceso_url(@bitacoraproceso), params: { bitacoraproceso: { codigo: @bitacoraproceso.codigo, codigo_firma: @bitacoraproceso.codigo_firma, codigo_recibido: @bitacoraproceso.codigo_recibido, controlador_tabla: @bitacoraproceso.controlador_tabla, fecha_firma: @bitacoraproceso.fecha_firma, id_tabla: @bitacoraproceso.id_tabla, proceso: @bitacoraproceso.proceso, user_id: @bitacoraproceso.user_id } }
    assert_redirected_to bitacoraproceso_url(@bitacoraproceso)
  end

  test "should destroy bitacoraproceso" do
    assert_difference('Bitacoraproceso.count', -1) do
      delete bitacoraproceso_url(@bitacoraproceso)
    end

    assert_redirected_to bitacoraprocesos_url
  end
end
