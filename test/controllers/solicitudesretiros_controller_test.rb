require 'test_helper'

class SolicitudesretirosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @solicitudesretiro = solicitudesretiros(:one)
  end

  test "should get index" do
    get solicitudesretiros_url
    assert_response :success
  end

  test "should get new" do
    get new_solicitudesretiro_url
    assert_response :success
  end

  test "should create solicitudesretiro" do
    assert_difference('Solicitudesretiro.count') do
      post solicitudesretiros_url, params: { solicitudesretiro: { contrato_id: @solicitudesretiro.contrato_id, contratosgrupo_id: @solicitudesretiro.contratosgrupo_id, contratospersona_id: @solicitudesretiro.contratospersona_id, fecha: @solicitudesretiro.fecha, fecha_aprobacion: @solicitudesretiro.fecha_aprobacion, fecha_liquidacion: @solicitudesretiro.fecha_liquidacion, justificacion: @solicitudesretiro.justificacion, user_aprobacion: @solicitudesretiro.user_aprobacion, user_id: @solicitudesretiro.user_id, user_liquidacion: @solicitudesretiro.user_liquidacion } }
    end

    assert_redirected_to solicitudesretiro_url(Solicitudesretiro.last)
  end

  test "should show solicitudesretiro" do
    get solicitudesretiro_url(@solicitudesretiro)
    assert_response :success
  end

  test "should get edit" do
    get edit_solicitudesretiro_url(@solicitudesretiro)
    assert_response :success
  end

  test "should update solicitudesretiro" do
    patch solicitudesretiro_url(@solicitudesretiro), params: { solicitudesretiro: { contrato_id: @solicitudesretiro.contrato_id, contratosgrupo_id: @solicitudesretiro.contratosgrupo_id, contratospersona_id: @solicitudesretiro.contratospersona_id, fecha: @solicitudesretiro.fecha, fecha_aprobacion: @solicitudesretiro.fecha_aprobacion, fecha_liquidacion: @solicitudesretiro.fecha_liquidacion, justificacion: @solicitudesretiro.justificacion, user_aprobacion: @solicitudesretiro.user_aprobacion, user_id: @solicitudesretiro.user_id, user_liquidacion: @solicitudesretiro.user_liquidacion } }
    assert_redirected_to solicitudesretiro_url(@solicitudesretiro)
  end

  test "should destroy solicitudesretiro" do
    assert_difference('Solicitudesretiro.count', -1) do
      delete solicitudesretiro_url(@solicitudesretiro)
    end

    assert_redirected_to solicitudesretiros_url
  end
end
