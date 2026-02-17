require 'test_helper'

class EntradaControllerTest < ActionDispatch::IntegrationTest
  setup do
    @entrada = entrada(:one)
  end

  test "should get index" do
    get entrada_index_url
    assert_response :success
  end

  test "should get new" do
    get new_entrada_url
    assert_response :success
  end

  test "should create entrada" do
    assert_difference('Entrada.count') do
      post entrada_index_url, params: { entrada: { barrio_id: @entrada.barrio_id, celular: @entrada.celular, clase: @entrada.clase, direccion: @entrada.direccion, identificacion: @entrada.identificacion, nombre: @entrada.nombre, portafolio_id: @entrada.portafolio_id, temperatura: @entrada.temperatura, user_id: @entrada.user_id } }
    end

    assert_redirected_to entrada_url(Entrada.last)
  end

  test "should show entrada" do
    get entrada_url(@entrada)
    assert_response :success
  end

  test "should get edit" do
    get edit_entrada_url(@entrada)
    assert_response :success
  end

  test "should update entrada" do
    patch entrada_url(@entrada), params: { entrada: { barrio_id: @entrada.barrio_id, celular: @entrada.celular, clase: @entrada.clase, direccion: @entrada.direccion, identificacion: @entrada.identificacion, nombre: @entrada.nombre, portafolio_id: @entrada.portafolio_id, temperatura: @entrada.temperatura, user_id: @entrada.user_id } }
    assert_redirected_to entrada_url(@entrada)
  end

  test "should destroy entrada" do
    assert_difference('Entrada.count', -1) do
      delete entrada_url(@entrada)
    end

    assert_redirected_to entrada_index_url
  end
end
