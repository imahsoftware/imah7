require 'test_helper'

class ContratoscaparesultadosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratoscaparesultado = contratoscaparesultados(:one)
  end

  test "should get index" do
    get contratoscaparesultados_url
    assert_response :success
  end

  test "should get new" do
    get new_contratoscaparesultado_url
    assert_response :success
  end

  test "should create contratoscaparesultado" do
    assert_difference('Contratoscaparesultado.count') do
      post contratoscaparesultados_url, params: { contratoscaparesultado: { capacitacion_id: @contratoscaparesultado.capacitacion_id, capacitacionevaluacion_id: @contratoscaparesultado.capacitacionevaluacion_id, contratoscapapersona_id: @contratoscaparesultado.contratoscapapersona_id, contratosperfecha_id: @contratoscaparesultado.contratosperfecha_id, respuesta: @contratoscaparesultado.respuesta, resultado: @contratoscaparesultado.resultado } }
    end

    assert_redirected_to contratoscaparesultado_url(Contratoscaparesultado.last)
  end

  test "should show contratoscaparesultado" do
    get contratoscaparesultado_url(@contratoscaparesultado)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratoscaparesultado_url(@contratoscaparesultado)
    assert_response :success
  end

  test "should update contratoscaparesultado" do
    patch contratoscaparesultado_url(@contratoscaparesultado), params: { contratoscaparesultado: { capacitacion_id: @contratoscaparesultado.capacitacion_id, capacitacionevaluacion_id: @contratoscaparesultado.capacitacionevaluacion_id, contratoscapapersona_id: @contratoscaparesultado.contratoscapapersona_id, contratosperfecha_id: @contratoscaparesultado.contratosperfecha_id, respuesta: @contratoscaparesultado.respuesta, resultado: @contratoscaparesultado.resultado } }
    assert_redirected_to contratoscaparesultado_url(@contratoscaparesultado)
  end

  test "should destroy contratoscaparesultado" do
    assert_difference('Contratoscaparesultado.count', -1) do
      delete contratoscaparesultado_url(@contratoscaparesultado)
    end

    assert_redirected_to contratoscaparesultados_url
  end
end
