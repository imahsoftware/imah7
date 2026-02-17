require 'test_helper'

class PersonasobservacionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @personasobservacion = personasobservaciones(:one)
  end

  test "should get index" do
    get personasobservaciones_url
    assert_response :success
  end

  test "should get new" do
    get new_personasobservacion_url
    assert_response :success
  end

  test "should create personasobservacion" do
    assert_difference('Personasobservacion.count') do
      post personasobservaciones_url, params: { personasobservacion: { observacion: @personasobservacion.observacion, persona_id: @personasobservacion.persona_id, user_id: @personasobservacion.user_id } }
    end

    assert_redirected_to personasobservacion_url(Personasobservacion.last)
  end

  test "should show personasobservacion" do
    get personasobservacion_url(@personasobservacion)
    assert_response :success
  end

  test "should get edit" do
    get edit_personasobservacion_url(@personasobservacion)
    assert_response :success
  end

  test "should update personasobservacion" do
    patch personasobservacion_url(@personasobservacion), params: { personasobservacion: { observacion: @personasobservacion.observacion, persona_id: @personasobservacion.persona_id, user_id: @personasobservacion.user_id } }
    assert_redirected_to personasobservacion_url(@personasobservacion)
  end

  test "should destroy personasobservacion" do
    assert_difference('Personasobservacion.count', -1) do
      delete personasobservacion_url(@personasobservacion)
    end

    assert_redirected_to personasobservaciones_url
  end
end
