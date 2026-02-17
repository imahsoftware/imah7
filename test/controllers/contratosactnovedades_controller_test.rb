require 'test_helper'

class ContratosactnovedadesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosactnovedad = contratosactnovedades(:one)
  end

  test "should get index" do
    get contratosactnovedades_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosactnovedad_url
    assert_response :success
  end

  test "should create contratosactnovedad" do
    assert_difference('Contratosactnovedad.count') do
      post contratosactnovedades_url, params: { contratosactnovedad: { calificacion: @contratosactnovedad.calificacion, contratossede_id: @contratosactnovedad.contratossede_id, estado: @contratosactnovedad.estado, fecha: @contratosactnovedad.fecha, nodo: @contratosactnovedad.nodo, observaciones: @contratosactnovedad.observaciones, tiposevaluacion_id: @contratosactnovedad.tiposevaluacion_id, user_id: @contratosactnovedad.user_id } }
    end

    assert_redirected_to contratosactnovedad_url(Contratosactnovedad.last)
  end

  test "should show contratosactnovedad" do
    get contratosactnovedad_url(@contratosactnovedad)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosactnovedad_url(@contratosactnovedad)
    assert_response :success
  end

  test "should update contratosactnovedad" do
    patch contratosactnovedad_url(@contratosactnovedad), params: { contratosactnovedad: { calificacion: @contratosactnovedad.calificacion, contratossede_id: @contratosactnovedad.contratossede_id, estado: @contratosactnovedad.estado, fecha: @contratosactnovedad.fecha, nodo: @contratosactnovedad.nodo, observaciones: @contratosactnovedad.observaciones, tiposevaluacion_id: @contratosactnovedad.tiposevaluacion_id, user_id: @contratosactnovedad.user_id } }
    assert_redirected_to contratosactnovedad_url(@contratosactnovedad)
  end

  test "should destroy contratosactnovedad" do
    assert_difference('Contratosactnovedad.count', -1) do
      delete contratosactnovedad_url(@contratosactnovedad)
    end

    assert_redirected_to contratosactnovedades_url
  end
end
