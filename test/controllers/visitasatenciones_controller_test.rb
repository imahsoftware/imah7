require 'test_helper'

class VisitasatencionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @visitasatencion = visitasatenciones(:one)
  end

  test "should get index" do
    get visitasatenciones_url
    assert_response :success
  end

  test "should get new" do
    get new_visitasatencion_url
    assert_response :success
  end

  test "should create visitasatencion" do
    assert_difference('Visitasatencion.count') do
      post visitasatenciones_url, params: { visitasatencion: { cargo: @visitasatencion.cargo, celular: @visitasatencion.celular, codigo_env: @visitasatencion.codigo_env, codigo_fecha: @visitasatencion.codigo_fecha, codigo_firma: @visitasatencion.codigo_firma, codigo_rec: @visitasatencion.codigo_rec, email: @visitasatencion.email, identificacion: @visitasatencion.identificacion, nombre: @visitasatencion.nombre, user_id: @visitasatencion.user_id, visita_id: @visitasatencion.visita_id } }
    end

    assert_redirected_to visitasatencion_url(Visitasatencion.last)
  end

  test "should show visitasatencion" do
    get visitasatencion_url(@visitasatencion)
    assert_response :success
  end

  test "should get edit" do
    get edit_visitasatencion_url(@visitasatencion)
    assert_response :success
  end

  test "should update visitasatencion" do
    patch visitasatencion_url(@visitasatencion), params: { visitasatencion: { cargo: @visitasatencion.cargo, celular: @visitasatencion.celular, codigo_env: @visitasatencion.codigo_env, codigo_fecha: @visitasatencion.codigo_fecha, codigo_firma: @visitasatencion.codigo_firma, codigo_rec: @visitasatencion.codigo_rec, email: @visitasatencion.email, identificacion: @visitasatencion.identificacion, nombre: @visitasatencion.nombre, user_id: @visitasatencion.user_id, visita_id: @visitasatencion.visita_id } }
    assert_redirected_to visitasatencion_url(@visitasatencion)
  end

  test "should destroy visitasatencion" do
    assert_difference('Visitasatencion.count', -1) do
      delete visitasatencion_url(@visitasatencion)
    end

    assert_redirected_to visitasatenciones_url
  end
end
