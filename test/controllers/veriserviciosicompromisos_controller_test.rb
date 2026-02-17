require 'test_helper'

class VeriserviciosicompromisosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @veriserviciosicompromiso = veriserviciosicompromisos(:one)
  end

  test "should get index" do
    get veriserviciosicompromisos_url
    assert_response :success
  end

  test "should get new" do
    get new_veriserviciosicompromiso_url
    assert_response :success
  end

  test "should create veriserviciosicompromiso" do
    assert_difference('Veriserviciosicompromiso.count') do
      post veriserviciosicompromisos_url, params: { veriserviciosicompromiso: { compromiso: @veriserviciosicompromiso.compromiso, estado: @veriserviciosicompromiso.estado, fecha: @veriserviciosicompromiso.fecha, observacion_estado: @veriserviciosicompromiso.observacion_estado, user_id: @veriserviciosicompromiso.user_id, veriserviciositem_id: @veriserviciosicompromiso.veriserviciositem_id } }
    end

    assert_redirected_to veriserviciosicompromiso_url(Veriserviciosicompromiso.last)
  end

  test "should show veriserviciosicompromiso" do
    get veriserviciosicompromiso_url(@veriserviciosicompromiso)
    assert_response :success
  end

  test "should get edit" do
    get edit_veriserviciosicompromiso_url(@veriserviciosicompromiso)
    assert_response :success
  end

  test "should update veriserviciosicompromiso" do
    patch veriserviciosicompromiso_url(@veriserviciosicompromiso), params: { veriserviciosicompromiso: { compromiso: @veriserviciosicompromiso.compromiso, estado: @veriserviciosicompromiso.estado, fecha: @veriserviciosicompromiso.fecha, observacion_estado: @veriserviciosicompromiso.observacion_estado, user_id: @veriserviciosicompromiso.user_id, veriserviciositem_id: @veriserviciosicompromiso.veriserviciositem_id } }
    assert_redirected_to veriserviciosicompromiso_url(@veriserviciosicompromiso)
  end

  test "should destroy veriserviciosicompromiso" do
    assert_difference('Veriserviciosicompromiso.count', -1) do
      delete veriserviciosicompromiso_url(@veriserviciosicompromiso)
    end

    assert_redirected_to veriserviciosicompromisos_url
  end
end
