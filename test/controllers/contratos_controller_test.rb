require 'test_helper'

class ContratosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contrato = contratos(:one)
  end

  test "should get index" do
    get contratos_url
    assert_response :success
  end

  test "should get new" do
    get new_contrato_url
    assert_response :success
  end

  test "should create contrato" do
    assert_difference('Contrato.count') do
      post contratos_url, params: { contrato: { anticipo: @contrato.anticipo, empresa_id: @contrato.empresa_id, estado: @contrato.estado, fecha_fin: @contrato.fecha_fin, fecha_firma: @contrato.fecha_firma, fecha_inicio: @contrato.fecha_inicio, fecha_liquidacion: @contrato.fecha_liquidacion, fechamasmodi: @contrato.fechamasmodi, nro_contrato: @contrato.nro_contrato, objeto: @contrato.objeto, plazo_dia: @contrato.plazo_dia, plazo_mes: @contrato.plazo_mes, tiposcontrato_id: @contrato.tiposcontrato_id, user_act: @contrato.user_act, user_id: @contrato.user_id, valor: @contrato.valor, valor_anticipo: @contrato.valor_anticipo, valormasmodi: @contrato.valormasmodi } }
    end

    assert_redirected_to contrato_url(Contrato.last)
  end

  test "should show contrato" do
    get contrato_url(@contrato)
    assert_response :success
  end

  test "should get edit" do
    get edit_contrato_url(@contrato)
    assert_response :success
  end

  test "should update contrato" do
    patch contrato_url(@contrato), params: { contrato: { anticipo: @contrato.anticipo, empresa_id: @contrato.empresa_id, estado: @contrato.estado, fecha_fin: @contrato.fecha_fin, fecha_firma: @contrato.fecha_firma, fecha_inicio: @contrato.fecha_inicio, fecha_liquidacion: @contrato.fecha_liquidacion, fechamasmodi: @contrato.fechamasmodi, nro_contrato: @contrato.nro_contrato, objeto: @contrato.objeto, plazo_dia: @contrato.plazo_dia, plazo_mes: @contrato.plazo_mes, tiposcontrato_id: @contrato.tiposcontrato_id, user_act: @contrato.user_act, user_id: @contrato.user_id, valor: @contrato.valor, valor_anticipo: @contrato.valor_anticipo, valormasmodi: @contrato.valormasmodi } }
    assert_redirected_to contrato_url(@contrato)
  end

  test "should destroy contrato" do
    assert_difference('Contrato.count', -1) do
      delete contrato_url(@contrato)
    end

    assert_redirected_to contratos_url
  end
end
