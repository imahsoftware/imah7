require 'test_helper'

class PersonasformulariosmensajesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @personasformulariosmensaje = personasformulariosmensajes(:one)
  end

  test "should get index" do
    get personasformulariosmensajes_url
    assert_response :success
  end

  test "should get new" do
    get new_personasformulariosmensaje_url
    assert_response :success
  end

  test "should create personasformulariosmensaje" do
    assert_difference('Personasformulariosmensaje.count') do
      post personasformulariosmensajes_url, params: { personasformulariosmensaje: { estado: @personasformulariosmensaje.estado, personasformulario_id: @personasformulariosmensaje.personasformulario_id, tipo: @personasformulariosmensaje.tipo, user_envia: @personasformulariosmensaje.user_envia } }
    end

    assert_redirected_to personasformulariosmensaje_url(Personasformulariosmensaje.last)
  end

  test "should show personasformulariosmensaje" do
    get personasformulariosmensaje_url(@personasformulariosmensaje)
    assert_response :success
  end

  test "should get edit" do
    get edit_personasformulariosmensaje_url(@personasformulariosmensaje)
    assert_response :success
  end

  test "should update personasformulariosmensaje" do
    patch personasformulariosmensaje_url(@personasformulariosmensaje), params: { personasformulariosmensaje: { estado: @personasformulariosmensaje.estado, personasformulario_id: @personasformulariosmensaje.personasformulario_id, tipo: @personasformulariosmensaje.tipo, user_envia: @personasformulariosmensaje.user_envia } }
    assert_redirected_to personasformulariosmensaje_url(@personasformulariosmensaje)
  end

  test "should destroy personasformulariosmensaje" do
    assert_difference('Personasformulariosmensaje.count', -1) do
      delete personasformulariosmensaje_url(@personasformulariosmensaje)
    end

    assert_redirected_to personasformulariosmensajes_url
  end
end
