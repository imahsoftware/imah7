require 'test_helper'

class ContratoscapapersonasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratoscapapersona = contratoscapapersonas(:one)
  end

  test "should get index" do
    get contratoscapapersonas_url
    assert_response :success
  end

  test "should get new" do
    get new_contratoscapapersona_url
    assert_response :success
  end

  test "should create contratoscapapersona" do
    assert_difference('Contratoscapapersona.count') do
      post contratoscapapersonas_url, params: { contratoscapapersona: { capacitacion_id: @contratoscapapersona.capacitacion_id, contrato_id: @contratoscapapersona.contrato_id, contratoscapacitacion_id: @contratoscapapersona.contratoscapacitacion_id, contratosperfecha_id: @contratoscapapersona.contratosperfecha_id, contratospersona_id: @contratoscapapersona.contratospersona_id, estado_evaluacion: @contratoscapapersona.estado_evaluacion, resultado_evaluacion: @contratoscapapersona.resultado_evaluacion } }
    end

    assert_redirected_to contratoscapapersona_url(Contratoscapapersona.last)
  end

  test "should show contratoscapapersona" do
    get contratoscapapersona_url(@contratoscapapersona)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratoscapapersona_url(@contratoscapapersona)
    assert_response :success
  end

  test "should update contratoscapapersona" do
    patch contratoscapapersona_url(@contratoscapapersona), params: { contratoscapapersona: { capacitacion_id: @contratoscapapersona.capacitacion_id, contrato_id: @contratoscapapersona.contrato_id, contratoscapacitacion_id: @contratoscapapersona.contratoscapacitacion_id, contratosperfecha_id: @contratoscapapersona.contratosperfecha_id, contratospersona_id: @contratoscapapersona.contratospersona_id, estado_evaluacion: @contratoscapapersona.estado_evaluacion, resultado_evaluacion: @contratoscapapersona.resultado_evaluacion } }
    assert_redirected_to contratoscapapersona_url(@contratoscapapersona)
  end

  test "should destroy contratoscapapersona" do
    assert_difference('Contratoscapapersona.count', -1) do
      delete contratoscapapersona_url(@contratoscapapersona)
    end

    assert_redirected_to contratoscapapersonas_url
  end
end
