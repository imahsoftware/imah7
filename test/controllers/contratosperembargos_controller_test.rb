require 'test_helper'

class ContratosperembargosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosperembargo = contratosperembargos(:one)
  end

  test "should get index" do
    get contratosperembargos_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosperembargo_url
    assert_response :success
  end

  test "should create contratosperembargo" do
    assert_difference('Contratosperembargo.count') do
      post contratosperembargos_url, params: { contratosperembargo: { contratospersona_id: @contratosperembargo.contratospersona_id, porcentaje: @contratosperembargo.porcentaje, prestaciones: @contratosperembargo.prestaciones, termino_descuento: @contratosperembargo.termino_descuento, tipodescuento: @contratosperembargo.tipodescuento, tiposentidad_id: @contratosperembargo.tiposentidad_id, tope: @contratosperembargo.tope, user_actualiza: @contratosperembargo.user_actualiza, user_id: @contratosperembargo.user_id, valor: @contratosperembargo.valor } }
    end

    assert_redirected_to contratosperembargo_url(Contratosperembargo.last)
  end

  test "should show contratosperembargo" do
    get contratosperembargo_url(@contratosperembargo)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosperembargo_url(@contratosperembargo)
    assert_response :success
  end

  test "should update contratosperembargo" do
    patch contratosperembargo_url(@contratosperembargo), params: { contratosperembargo: { contratospersona_id: @contratosperembargo.contratospersona_id, porcentaje: @contratosperembargo.porcentaje, prestaciones: @contratosperembargo.prestaciones, termino_descuento: @contratosperembargo.termino_descuento, tipodescuento: @contratosperembargo.tipodescuento, tiposentidad_id: @contratosperembargo.tiposentidad_id, tope: @contratosperembargo.tope, user_actualiza: @contratosperembargo.user_actualiza, user_id: @contratosperembargo.user_id, valor: @contratosperembargo.valor } }
    assert_redirected_to contratosperembargo_url(@contratosperembargo)
  end

  test "should destroy contratosperembargo" do
    assert_difference('Contratosperembargo.count', -1) do
      delete contratosperembargo_url(@contratosperembargo)
    end

    assert_redirected_to contratosperembargos_url
  end
end
