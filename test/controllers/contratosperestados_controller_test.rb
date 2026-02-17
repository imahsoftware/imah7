require 'test_helper'

class ContratosperestadosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosperestado = contratosperestados(:one)
  end

  test "should get index" do
    get contratosperestados_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosperestado_url
    assert_response :success
  end

  test "should create contratosperestado" do
    assert_difference('Contratosperestado.count') do
      post contratosperestados_url, params: { contratosperestado: { contratospersona_id: @contratosperestado.contratospersona_id, descripcion: @contratosperestado.descripcion, user_act: @contratosperestado.user_act, user_id: @contratosperestado.user_id } }
    end

    assert_redirected_to contratosperestado_url(Contratosperestado.last)
  end

  test "should show contratosperestado" do
    get contratosperestado_url(@contratosperestado)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosperestado_url(@contratosperestado)
    assert_response :success
  end

  test "should update contratosperestado" do
    patch contratosperestado_url(@contratosperestado), params: { contratosperestado: { contratospersona_id: @contratosperestado.contratospersona_id, descripcion: @contratosperestado.descripcion, user_act: @contratosperestado.user_act, user_id: @contratosperestado.user_id } }
    assert_redirected_to contratosperestado_url(@contratosperestado)
  end

  test "should destroy contratosperestado" do
    assert_difference('Contratosperestado.count', -1) do
      delete contratosperestado_url(@contratosperestado)
    end

    assert_redirected_to contratosperestados_url
  end
end
