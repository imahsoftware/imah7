require 'test_helper'

class ContratospernominasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratospernomina = contratospernominas(:one)
  end

  test "should get index" do
    get contratospernominas_url
    assert_response :success
  end

  test "should get new" do
    get new_contratospernomina_url
    assert_response :success
  end

  test "should create contratospernomina" do
    assert_difference('Contratospernomina.count') do
      post contratospernominas_url, params: { contratospernomina: { ajuste: @contratospernomina.ajuste, arl: @contratospernomina.arl, auxilio: @contratospernomina.auxilio, bonificacion: @contratospernomina.bonificacion, caja: @contratospernomina.caja, contrato_id: @contratospernomina.contrato_id, contratospersona_id: @contratospernomina.contratospersona_id, dias: @contratospernomina.dias, dias_incg: @contratospernomina.dias_incg, dias_incl: @contratospernomina.dias_incl, dias_novedad: @contratospernomina.dias_novedad, dias_vaca: @contratospernomina.dias_vaca, dotacion: @contratospernomina.dotacion, estado: @contratospernomina.estado, incapacidad: @contratospernomina.incapacidad, observacion: @contratospernomina.observacion, otros_desc: @contratospernomina.otros_desc, pension: @contratospernomina.pension, pension_emp: @contratospernomina.pension_emp, periodosliquidacion_id: @contratospernomina.periodosliquidacion_id, prestamo: @contratospernomina.prestamo, prov_cesantias: @contratospernomina.prov_cesantias, prov_intcesantias: @contratospernomina.prov_intcesantias, prov_prima: @contratospernomina.prov_prima, prov_vacaciones: @contratospernomina.prov_vacaciones, salario: @contratospernomina.salario, salario: @contratospernomina.salario, salud: @contratospernomina.salud, salud_emp: @contratospernomina.salud_emp, seguro: @contratospernomina.seguro, subtotal: @contratospernomina.subtotal, total: @contratospernomina.total, valor_novedad: @contratospernomina.valor_novedad, valor_vaca: @contratospernomina.valor_vaca } }
    end

    assert_redirected_to contratospernomina_url(Contratospernomina.last)
  end

  test "should show contratospernomina" do
    get contratospernomina_url(@contratospernomina)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratospernomina_url(@contratospernomina)
    assert_response :success
  end

  test "should update contratospernomina" do
    patch contratospernomina_url(@contratospernomina), params: { contratospernomina: { ajuste: @contratospernomina.ajuste, arl: @contratospernomina.arl, auxilio: @contratospernomina.auxilio, bonificacion: @contratospernomina.bonificacion, caja: @contratospernomina.caja, contrato_id: @contratospernomina.contrato_id, contratospersona_id: @contratospernomina.contratospersona_id, dias: @contratospernomina.dias, dias_incg: @contratospernomina.dias_incg, dias_incl: @contratospernomina.dias_incl, dias_novedad: @contratospernomina.dias_novedad, dias_vaca: @contratospernomina.dias_vaca, dotacion: @contratospernomina.dotacion, estado: @contratospernomina.estado, incapacidad: @contratospernomina.incapacidad, observacion: @contratospernomina.observacion, otros_desc: @contratospernomina.otros_desc, pension: @contratospernomina.pension, pension_emp: @contratospernomina.pension_emp, periodosliquidacion_id: @contratospernomina.periodosliquidacion_id, prestamo: @contratospernomina.prestamo, prov_cesantias: @contratospernomina.prov_cesantias, prov_intcesantias: @contratospernomina.prov_intcesantias, prov_prima: @contratospernomina.prov_prima, prov_vacaciones: @contratospernomina.prov_vacaciones, salario: @contratospernomina.salario, salario: @contratospernomina.salario, salud: @contratospernomina.salud, salud_emp: @contratospernomina.salud_emp, seguro: @contratospernomina.seguro, subtotal: @contratospernomina.subtotal, total: @contratospernomina.total, valor_novedad: @contratospernomina.valor_novedad, valor_vaca: @contratospernomina.valor_vaca } }
    assert_redirected_to contratospernomina_url(@contratospernomina)
  end

  test "should destroy contratospernomina" do
    assert_difference('Contratospernomina.count', -1) do
      delete contratospernomina_url(@contratospernomina)
    end

    assert_redirected_to contratospernominas_url
  end
end
