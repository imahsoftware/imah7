require 'test_helper'

class EncuestasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @encuesta = encuestas(:one)
  end

  test "should get index" do
    get encuestas_url
    assert_response :success
  end

  test "should get new" do
    get new_encuesta_url
    assert_response :success
  end

  test "should create encuesta" do
    assert_difference('Encuesta.count') do
      post encuestas_url, params: { encuesta: { descripcion: @encuesta.descripcion, estado: @encuesta.estado } }
    end

    assert_redirected_to encuesta_url(Encuesta.last)
  end

  test "should show encuesta" do
    get encuesta_url(@encuesta)
    assert_response :success
  end

  test "should get edit" do
    get edit_encuesta_url(@encuesta)
    assert_response :success
  end

  test "should update encuesta" do
    patch encuesta_url(@encuesta), params: { encuesta: { descripcion: @encuesta.descripcion, estado: @encuesta.estado } }
    assert_redirected_to encuesta_url(@encuesta)
  end

  test "should destroy encuesta" do
    assert_difference('Encuesta.count', -1) do
      delete encuesta_url(@encuesta)
    end

    assert_redirected_to encuestas_url
  end
end
