require 'test_helper'

class ContratosprefretencionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosprefretencion = contratosprefretenciones(:one)
  end

  test "should get index" do
    get contratosprefretenciones_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosprefretencion_url
    assert_response :success
  end

  test "should create contratosprefretencion" do
    assert_difference('Contratosprefretencion.count') do
      post contratosprefretenciones_url, params: { contratosprefretencion: { contratosprefactura_id: @contratosprefretencion.contratosprefactura_id, contratosprefdetalle_id: @contratosprefretencion.contratosprefdetalle_id, contratosretencion_id: @contratosprefretencion.contratosretencion_id, valor_retencion: @contratosprefretencion.valor_retencion } }
    end

    assert_redirected_to contratosprefretencion_url(Contratosprefretencion.last)
  end

  test "should show contratosprefretencion" do
    get contratosprefretencion_url(@contratosprefretencion)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosprefretencion_url(@contratosprefretencion)
    assert_response :success
  end

  test "should update contratosprefretencion" do
    patch contratosprefretencion_url(@contratosprefretencion), params: { contratosprefretencion: { contratosprefactura_id: @contratosprefretencion.contratosprefactura_id, contratosprefdetalle_id: @contratosprefretencion.contratosprefdetalle_id, contratosretencion_id: @contratosprefretencion.contratosretencion_id, valor_retencion: @contratosprefretencion.valor_retencion } }
    assert_redirected_to contratosprefretencion_url(@contratosprefretencion)
  end

  test "should destroy contratosprefretencion" do
    assert_difference('Contratosprefretencion.count', -1) do
      delete contratosprefretencion_url(@contratosprefretencion)
    end

    assert_redirected_to contratosprefretenciones_url
  end
end
