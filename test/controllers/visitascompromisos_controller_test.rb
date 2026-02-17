require 'test_helper'

class VisitascompromisosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @visitascompromiso = visitascompromisos(:one)
  end

  test "should get index" do
    get visitascompromisos_url
    assert_response :success
  end

  test "should get new" do
    get new_visitascompromiso_url
    assert_response :success
  end

  test "should create visitascompromiso" do
    assert_difference('Visitascompromiso.count') do
      post visitascompromisos_url, params: { visitascompromiso: { compromiso: @visitascompromiso.compromiso, estado: @visitascompromiso.estado, fecha: @visitascompromiso.fecha, user_id: @visitascompromiso.user_id, visita_id: @visitascompromiso.visita_id } }
    end

    assert_redirected_to visitascompromiso_url(Visitascompromiso.last)
  end

  test "should show visitascompromiso" do
    get visitascompromiso_url(@visitascompromiso)
    assert_response :success
  end

  test "should get edit" do
    get edit_visitascompromiso_url(@visitascompromiso)
    assert_response :success
  end

  test "should update visitascompromiso" do
    patch visitascompromiso_url(@visitascompromiso), params: { visitascompromiso: { compromiso: @visitascompromiso.compromiso, estado: @visitascompromiso.estado, fecha: @visitascompromiso.fecha, user_id: @visitascompromiso.user_id, visita_id: @visitascompromiso.visita_id } }
    assert_redirected_to visitascompromiso_url(@visitascompromiso)
  end

  test "should destroy visitascompromiso" do
    assert_difference('Visitascompromiso.count', -1) do
      delete visitascompromiso_url(@visitascompromiso)
    end

    assert_redirected_to visitascompromisos_url
  end
end
