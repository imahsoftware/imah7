require 'test_helper'

class ContratosseccionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosseccion = contratossecciones(:one)
  end

  test "should get index" do
    get contratossecciones_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosseccion_url
    assert_response :success
  end

  test "should create contratosseccion" do
    assert_difference('Contratosseccion.count') do
      post contratossecciones_url, params: { contratosseccion: { cantidad: @contratosseccion.cantidad, contrato_id: @contratosseccion.contrato_id, contratoscargo_id: @contratosseccion.contratoscargo_id, contratosgrupo_id: @contratosseccion.contratosgrupo_id, descripcion: @contratosseccion.descripcion, municipio_id: @contratosseccion.municipio_id, user_id: @contratosseccion.user_id } }
    end

    assert_redirected_to contratosseccion_url(Contratosseccion.last)
  end

  test "should show contratosseccion" do
    get contratosseccion_url(@contratosseccion)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosseccion_url(@contratosseccion)
    assert_response :success
  end

  test "should update contratosseccion" do
    patch contratosseccion_url(@contratosseccion), params: { contratosseccion: { cantidad: @contratosseccion.cantidad, contrato_id: @contratosseccion.contrato_id, contratoscargo_id: @contratosseccion.contratoscargo_id, contratosgrupo_id: @contratosseccion.contratosgrupo_id, descripcion: @contratosseccion.descripcion, municipio_id: @contratosseccion.municipio_id, user_id: @contratosseccion.user_id } }
    assert_redirected_to contratosseccion_url(@contratosseccion)
  end

  test "should destroy contratosseccion" do
    assert_difference('Contratosseccion.count', -1) do
      delete contratosseccion_url(@contratosseccion)
    end

    assert_redirected_to contratossecciones_url
  end
end
