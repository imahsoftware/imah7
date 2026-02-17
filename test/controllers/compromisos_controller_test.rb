require 'test_helper'

class CompromisosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @compromiso = compromisos(:one)
  end

  test "should get index" do
    get compromisos_url
    assert_response :success
  end

  test "should get new" do
    get new_compromiso_url
    assert_response :success
  end

  test "should create compromiso" do
    assert_difference('Compromiso.count') do
      post compromisos_url, params: { compromiso: { estado: @compromiso.estado, fecha_entrega: @compromiso.fecha_entrega, fecha_real_compromiso: @compromiso.fecha_real_compromiso, observacion: @compromiso.observacion, parcargosdoc_id: @compromiso.parcargosdoc_id, user_compromiso: @compromiso.user_compromiso, user_marca: @compromiso.user_marca } }
    end

    assert_redirected_to compromiso_url(Compromiso.last)
  end

  test "should show compromiso" do
    get compromiso_url(@compromiso)
    assert_response :success
  end

  test "should get edit" do
    get edit_compromiso_url(@compromiso)
    assert_response :success
  end

  test "should update compromiso" do
    patch compromiso_url(@compromiso), params: { compromiso: { estado: @compromiso.estado, fecha_entrega: @compromiso.fecha_entrega, fecha_real_compromiso: @compromiso.fecha_real_compromiso, observacion: @compromiso.observacion, parcargosdoc_id: @compromiso.parcargosdoc_id, user_compromiso: @compromiso.user_compromiso, user_marca: @compromiso.user_marca } }
    assert_redirected_to compromiso_url(@compromiso)
  end

  test "should destroy compromiso" do
    assert_difference('Compromiso.count', -1) do
      delete compromiso_url(@compromiso)
    end

    assert_redirected_to compromisos_url
  end
end
