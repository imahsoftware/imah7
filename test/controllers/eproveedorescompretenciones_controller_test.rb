require 'test_helper'

class EproveedorescompretencionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @eproveedorescompretencion = eproveedorescompretenciones(:one)
  end

  test "should get index" do
    get eproveedorescompretenciones_url
    assert_response :success
  end

  test "should get new" do
    get new_eproveedorescompretencion_url
    assert_response :success
  end

  test "should create eproveedorescompretencion" do
    assert_difference('Eproveedorescompretencion.count') do
      post eproveedorescompretenciones_url, params: { eproveedorescompretencion: { eproveedorescompra_id: @eproveedorescompretencion.eproveedorescompra_id, tipospretencion_id: @eproveedorescompretencion.tipospretencion_id, valor: @eproveedorescompretencion.valor } }
    end

    assert_redirected_to eproveedorescompretencion_url(Eproveedorescompretencion.last)
  end

  test "should show eproveedorescompretencion" do
    get eproveedorescompretencion_url(@eproveedorescompretencion)
    assert_response :success
  end

  test "should get edit" do
    get edit_eproveedorescompretencion_url(@eproveedorescompretencion)
    assert_response :success
  end

  test "should update eproveedorescompretencion" do
    patch eproveedorescompretencion_url(@eproveedorescompretencion), params: { eproveedorescompretencion: { eproveedorescompra_id: @eproveedorescompretencion.eproveedorescompra_id, tipospretencion_id: @eproveedorescompretencion.tipospretencion_id, valor: @eproveedorescompretencion.valor } }
    assert_redirected_to eproveedorescompretencion_url(@eproveedorescompretencion)
  end

  test "should destroy eproveedorescompretencion" do
    assert_difference('Eproveedorescompretencion.count', -1) do
      delete eproveedorescompretencion_url(@eproveedorescompretencion)
    end

    assert_redirected_to eproveedorescompretenciones_url
  end
end
