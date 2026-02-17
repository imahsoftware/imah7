require 'test_helper'

class ContratosactmcodigosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosactmcodigo = contratosactmcodigos(:one)
  end

  test "should get index" do
    get contratosactmcodigos_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosactmcodigo_url
    assert_response :success
  end

  test "should create contratosactmcodigo" do
    assert_difference('Contratosactmcodigo.count') do
      post contratosactmcodigos_url, params: { contratosactmcodigo: { calificacion: @contratosactmcodigo.calificacion, contratossede_id: @contratosactmcodigo.contratossede_id, nodo: @contratosactmcodigo.nodo, observaciones: @contratosactmcodigo.observaciones, tiposevaluacion_id: @contratosactmcodigo.tiposevaluacion_id, user_id: @contratosactmcodigo.user_id } }
    end

    assert_redirected_to contratosactmcodigo_url(Contratosactmcodigo.last)
  end

  test "should show contratosactmcodigo" do
    get contratosactmcodigo_url(@contratosactmcodigo)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosactmcodigo_url(@contratosactmcodigo)
    assert_response :success
  end

  test "should update contratosactmcodigo" do
    patch contratosactmcodigo_url(@contratosactmcodigo), params: { contratosactmcodigo: { calificacion: @contratosactmcodigo.calificacion, contratossede_id: @contratosactmcodigo.contratossede_id, nodo: @contratosactmcodigo.nodo, observaciones: @contratosactmcodigo.observaciones, tiposevaluacion_id: @contratosactmcodigo.tiposevaluacion_id, user_id: @contratosactmcodigo.user_id } }
    assert_redirected_to contratosactmcodigo_url(@contratosactmcodigo)
  end

  test "should destroy contratosactmcodigo" do
    assert_difference('Contratosactmcodigo.count', -1) do
      delete contratosactmcodigo_url(@contratosactmcodigo)
    end

    assert_redirected_to contratosactmcodigos_url
  end
end
