require 'test_helper'

class ContratossoleppsatencionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratossoleppsatencion = contratossoleppsatenciones(:one)
  end

  test "should get index" do
    get contratossoleppsatenciones_url
    assert_response :success
  end

  test "should get new" do
    get new_contratossoleppsatencion_url
    assert_response :success
  end

  test "should create contratossoleppsatencion" do
    assert_difference('Contratossoleppsatencion.count') do
      post contratossoleppsatenciones_url, params: { contratossoleppsatencion: { cargo: @contratossoleppsatencion.cargo, celular: @contratossoleppsatencion.celular, codigo_env: @contratossoleppsatencion.codigo_env, codigo_fecha: @contratossoleppsatencion.codigo_fecha, codigo_firma: @contratossoleppsatencion.codigo_firma, codigo_rec: @contratossoleppsatencion.codigo_rec, contratossolepp_id: @contratossoleppsatencion.contratossolepp_id, email: @contratossoleppsatencion.email, identificacion: @contratossoleppsatencion.identificacion, nombre: @contratossoleppsatencion.nombre, user_id: @contratossoleppsatencion.user_id } }
    end

    assert_redirected_to contratossoleppsatencion_url(Contratossoleppsatencion.last)
  end

  test "should show contratossoleppsatencion" do
    get contratossoleppsatencion_url(@contratossoleppsatencion)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratossoleppsatencion_url(@contratossoleppsatencion)
    assert_response :success
  end

  test "should update contratossoleppsatencion" do
    patch contratossoleppsatencion_url(@contratossoleppsatencion), params: { contratossoleppsatencion: { cargo: @contratossoleppsatencion.cargo, celular: @contratossoleppsatencion.celular, codigo_env: @contratossoleppsatencion.codigo_env, codigo_fecha: @contratossoleppsatencion.codigo_fecha, codigo_firma: @contratossoleppsatencion.codigo_firma, codigo_rec: @contratossoleppsatencion.codigo_rec, contratossolepp_id: @contratossoleppsatencion.contratossolepp_id, email: @contratossoleppsatencion.email, identificacion: @contratossoleppsatencion.identificacion, nombre: @contratossoleppsatencion.nombre, user_id: @contratossoleppsatencion.user_id } }
    assert_redirected_to contratossoleppsatencion_url(@contratossoleppsatencion)
  end

  test "should destroy contratossoleppsatencion" do
    assert_difference('Contratossoleppsatencion.count', -1) do
      delete contratossoleppsatencion_url(@contratossoleppsatencion)
    end

    assert_redirected_to contratossoleppsatenciones_url
  end
end
