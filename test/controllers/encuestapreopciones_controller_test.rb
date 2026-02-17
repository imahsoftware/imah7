require 'test_helper'

class EncuestapreopcionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @encuestapreopcion = encuestapreopciones(:one)
  end

  test "should get index" do
    get encuestapreopciones_url
    assert_response :success
  end

  test "should get new" do
    get new_encuestapreopcion_url
    assert_response :success
  end

  test "should create encuestapreopcion" do
    assert_difference('Encuestapreopcion.count') do
      post encuestapreopciones_url, params: { encuestapreopcion: { clase: @encuestapreopcion.clase, encuestapregunta_id: @encuestapreopcion.encuestapregunta_id, respuesta: @encuestapreopcion.respuesta } }
    end

    assert_redirected_to encuestapreopcion_url(Encuestapreopcion.last)
  end

  test "should show encuestapreopcion" do
    get encuestapreopcion_url(@encuestapreopcion)
    assert_response :success
  end

  test "should get edit" do
    get edit_encuestapreopcion_url(@encuestapreopcion)
    assert_response :success
  end

  test "should update encuestapreopcion" do
    patch encuestapreopcion_url(@encuestapreopcion), params: { encuestapreopcion: { clase: @encuestapreopcion.clase, encuestapregunta_id: @encuestapreopcion.encuestapregunta_id, respuesta: @encuestapreopcion.respuesta } }
    assert_redirected_to encuestapreopcion_url(@encuestapreopcion)
  end

  test "should destroy encuestapreopcion" do
    assert_difference('Encuestapreopcion.count', -1) do
      delete encuestapreopcion_url(@encuestapreopcion)
    end

    assert_redirected_to encuestapreopciones_url
  end
end
