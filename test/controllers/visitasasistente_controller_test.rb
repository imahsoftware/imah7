require 'test_helper'

class VisitasasistenteControllerTest < ActionDispatch::IntegrationTest
  setup do
    @visitasasistente = visitasasistente(:one)
  end

  test "should get index" do
    get visitasasistente_index_url
    assert_response :success
  end

  test "should get new" do
    get new_visitasasistente_url
    assert_response :success
  end

  test "should create visitasasistente" do
    assert_difference('Visitasasistente.count') do
      post visitasasistente_index_url, params: { visitasasistente: { cargo: @visitasasistente.cargo, email: @visitasasistente.email, nombre: @visitasasistente.nombre, user_id: @visitasasistente.user_id, visita_id: @visitasasistente.visita_id } }
    end

    assert_redirected_to visitasasistente_url(Visitasasistente.last)
  end

  test "should show visitasasistente" do
    get visitasasistente_url(@visitasasistente)
    assert_response :success
  end

  test "should get edit" do
    get edit_visitasasistente_url(@visitasasistente)
    assert_response :success
  end

  test "should update visitasasistente" do
    patch visitasasistente_url(@visitasasistente), params: { visitasasistente: { cargo: @visitasasistente.cargo, email: @visitasasistente.email, nombre: @visitasasistente.nombre, user_id: @visitasasistente.user_id, visita_id: @visitasasistente.visita_id } }
    assert_redirected_to visitasasistente_url(@visitasasistente)
  end

  test "should destroy visitasasistente" do
    assert_difference('Visitasasistente.count', -1) do
      delete visitasasistente_url(@visitasasistente)
    end

    assert_redirected_to visitasasistente_index_url
  end
end
