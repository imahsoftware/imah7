require 'test_helper'

class PersonasforencuestasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @personasforencuesta = personasforencuestas(:one)
  end

  test "should get index" do
    get personasforencuestas_url
    assert_response :success
  end

  test "should get new" do
    get new_personasforencuesta_url
    assert_response :success
  end

  test "should create personasforencuesta" do
    assert_difference('Personasforencuesta.count') do
      post personasforencuestas_url, params: { personasforencuesta: { calificacion: @personasforencuesta.calificacion, encuesta_id: @personasforencuesta.encuesta_id, encuestapreopcion_id: @personasforencuesta.encuestapreopcion_id, encuestaspregunta_id: @personasforencuesta.encuestaspregunta_id, personasformulario_id: @personasforencuesta.personasformulario_id } }
    end

    assert_redirected_to personasforencuesta_url(Personasforencuesta.last)
  end

  test "should show personasforencuesta" do
    get personasforencuesta_url(@personasforencuesta)
    assert_response :success
  end

  test "should get edit" do
    get edit_personasforencuesta_url(@personasforencuesta)
    assert_response :success
  end

  test "should update personasforencuesta" do
    patch personasforencuesta_url(@personasforencuesta), params: { personasforencuesta: { calificacion: @personasforencuesta.calificacion, encuesta_id: @personasforencuesta.encuesta_id, encuestapreopcion_id: @personasforencuesta.encuestapreopcion_id, encuestaspregunta_id: @personasforencuesta.encuestaspregunta_id, personasformulario_id: @personasforencuesta.personasformulario_id } }
    assert_redirected_to personasforencuesta_url(@personasforencuesta)
  end

  test "should destroy personasforencuesta" do
    assert_difference('Personasforencuesta.count', -1) do
      delete personasforencuesta_url(@personasforencuesta)
    end

    assert_redirected_to personasforencuestas_url
  end
end
