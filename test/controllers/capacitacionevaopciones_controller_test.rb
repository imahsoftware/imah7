require 'test_helper'

class CapacitacionevaopcionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @capacitacionevaopcion = capacitacionevaopciones(:one)
  end

  test "should get index" do
    get capacitacionevaopciones_url
    assert_response :success
  end

  test "should get new" do
    get new_capacitacionevaopcion_url
    assert_response :success
  end

  test "should create capacitacionevaopcion" do
    assert_difference('Capacitacionevaopcion.count') do
      post capacitacionevaopciones_url, params: { capacitacionevaopcion: { capacitacionevaluacion_id: @capacitacionevaopcion.capacitacionevaluacion_id, descripcion: @capacitacionevaopcion.descripcion, imagen: @capacitacionevaopcion.imagen, respuesta: @capacitacionevaopcion.respuesta } }
    end

    assert_redirected_to capacitacionevaopcion_url(Capacitacionevaopcion.last)
  end

  test "should show capacitacionevaopcion" do
    get capacitacionevaopcion_url(@capacitacionevaopcion)
    assert_response :success
  end

  test "should get edit" do
    get edit_capacitacionevaopcion_url(@capacitacionevaopcion)
    assert_response :success
  end

  test "should update capacitacionevaopcion" do
    patch capacitacionevaopcion_url(@capacitacionevaopcion), params: { capacitacionevaopcion: { capacitacionevaluacion_id: @capacitacionevaopcion.capacitacionevaluacion_id, descripcion: @capacitacionevaopcion.descripcion, imagen: @capacitacionevaopcion.imagen, respuesta: @capacitacionevaopcion.respuesta } }
    assert_redirected_to capacitacionevaopcion_url(@capacitacionevaopcion)
  end

  test "should destroy capacitacionevaopcion" do
    assert_difference('Capacitacionevaopcion.count', -1) do
      delete capacitacionevaopcion_url(@capacitacionevaopcion)
    end

    assert_redirected_to capacitacionevaopciones_url
  end
end
