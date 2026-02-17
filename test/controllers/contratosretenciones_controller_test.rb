require 'test_helper'

class ContratosretencionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosretencion = contratosretenciones(:one)
  end

  test "should get index" do
    get contratosretenciones_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosretencion_url
    assert_response :success
  end

  test "should create contratosretencion" do
    assert_difference('Contratosretencion.count') do
      post contratosretenciones_url, params: { contratosretencion: { contrato_id: @contratosretencion.contrato_id, descripcion: @contratosretencion.descripcion, porcentaje: @contratosretencion.porcentaje, tipo_producto: @contratosretencion.tipo_producto, user_id: @contratosretencion.user_id } }
    end

    assert_redirected_to contratosretencion_url(Contratosretencion.last)
  end

  test "should show contratosretencion" do
    get contratosretencion_url(@contratosretencion)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosretencion_url(@contratosretencion)
    assert_response :success
  end

  test "should update contratosretencion" do
    patch contratosretencion_url(@contratosretencion), params: { contratosretencion: { contrato_id: @contratosretencion.contrato_id, descripcion: @contratosretencion.descripcion, porcentaje: @contratosretencion.porcentaje, tipo_producto: @contratosretencion.tipo_producto, user_id: @contratosretencion.user_id } }
    assert_redirected_to contratosretencion_url(@contratosretencion)
  end

  test "should destroy contratosretencion" do
    assert_difference('Contratosretencion.count', -1) do
      delete contratosretencion_url(@contratosretencion)
    end

    assert_redirected_to contratosretenciones_url
  end
end
