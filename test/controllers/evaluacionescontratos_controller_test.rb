require 'test_helper'

class EvaluacionescontratosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @evaluacionescontrato = evaluacionescontratos(:one)
  end

  test "should get index" do
    get evaluacionescontratos_url
    assert_response :success
  end

  test "should get new" do
    get new_evaluacionescontrato_url
    assert_response :success
  end

  test "should create evaluacionescontrato" do
    assert_difference('Evaluacionescontrato.count') do
      post evaluacionescontratos_url, params: { evaluacionescontrato: { contrato_id: @evaluacionescontrato.contrato_id, estado: @evaluacionescontrato.estado, evaluacion_id: @evaluacionescontrato.evaluacion_id, fecha_limite: @evaluacionescontrato.fecha_limite, user_id: @evaluacionescontrato.user_id, user_responsable: @evaluacionescontrato.user_responsable } }
    end

    assert_redirected_to evaluacionescontrato_url(Evaluacionescontrato.last)
  end

  test "should show evaluacionescontrato" do
    get evaluacionescontrato_url(@evaluacionescontrato)
    assert_response :success
  end

  test "should get edit" do
    get edit_evaluacionescontrato_url(@evaluacionescontrato)
    assert_response :success
  end

  test "should update evaluacionescontrato" do
    patch evaluacionescontrato_url(@evaluacionescontrato), params: { evaluacionescontrato: { contrato_id: @evaluacionescontrato.contrato_id, estado: @evaluacionescontrato.estado, evaluacion_id: @evaluacionescontrato.evaluacion_id, fecha_limite: @evaluacionescontrato.fecha_limite, user_id: @evaluacionescontrato.user_id, user_responsable: @evaluacionescontrato.user_responsable } }
    assert_redirected_to evaluacionescontrato_url(@evaluacionescontrato)
  end

  test "should destroy evaluacionescontrato" do
    assert_difference('Evaluacionescontrato.count', -1) do
      delete evaluacionescontrato_url(@evaluacionescontrato)
    end

    assert_redirected_to evaluacionescontratos_url
  end
end
