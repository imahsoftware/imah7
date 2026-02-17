require 'test_helper'

class EncuestapreguntasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @encuestapregunta = encuestapreguntas(:one)
  end

  test "should get index" do
    get encuestapreguntas_url
    assert_response :success
  end

  test "should get new" do
    get new_encuestapregunta_url
    assert_response :success
  end

  test "should create encuestapregunta" do
    assert_difference('Encuestapregunta.count') do
      post encuestapreguntas_url, params: { encuestapregunta: { encuesta_id: @encuestapregunta.encuesta_id, pregunta: @encuestapregunta.pregunta } }
    end

    assert_redirected_to encuestapregunta_url(Encuestapregunta.last)
  end

  test "should show encuestapregunta" do
    get encuestapregunta_url(@encuestapregunta)
    assert_response :success
  end

  test "should get edit" do
    get edit_encuestapregunta_url(@encuestapregunta)
    assert_response :success
  end

  test "should update encuestapregunta" do
    patch encuestapregunta_url(@encuestapregunta), params: { encuestapregunta: { encuesta_id: @encuestapregunta.encuesta_id, pregunta: @encuestapregunta.pregunta } }
    assert_redirected_to encuestapregunta_url(@encuestapregunta)
  end

  test "should destroy encuestapregunta" do
    assert_difference('Encuestapregunta.count', -1) do
      delete encuestapregunta_url(@encuestapregunta)
    end

    assert_redirected_to encuestapreguntas_url
  end
end
