require 'test_helper'

class ControlformatosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @controlformato = controlformatos(:one)
  end

  test "should get index" do
    get controlformatos_url
    assert_response :success
  end

  test "should get new" do
    get new_controlformato_url
    assert_response :success
  end

  test "should create controlformato" do
    assert_difference('Controlformato.count') do
      post controlformatos_url, params: { controlformato: { controlador: @controlformato.controlador, estado: @controlformato.estado, modelo: @controlformato.modelo, proceso: @controlformato.proceso, tipo_documento: @controlformato.tipo_documento, url: @controlformato.url } }
    end

    assert_redirected_to controlformato_url(Controlformato.last)
  end

  test "should show controlformato" do
    get controlformato_url(@controlformato)
    assert_response :success
  end

  test "should get edit" do
    get edit_controlformato_url(@controlformato)
    assert_response :success
  end

  test "should update controlformato" do
    patch controlformato_url(@controlformato), params: { controlformato: { controlador: @controlformato.controlador, estado: @controlformato.estado, modelo: @controlformato.modelo, proceso: @controlformato.proceso, tipo_documento: @controlformato.tipo_documento, url: @controlformato.url } }
    assert_redirected_to controlformato_url(@controlformato)
  end

  test "should destroy controlformato" do
    assert_difference('Controlformato.count', -1) do
      delete controlformato_url(@controlformato)
    end

    assert_redirected_to controlformatos_url
  end
end
