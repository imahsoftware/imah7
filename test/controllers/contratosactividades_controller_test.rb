require 'test_helper'

class ContratosactividadesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosactividad = contratosactividades(:one)
  end

  test "should get index" do
    get contratosactividades_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosactividad_url
    assert_response :success
  end

  test "should create contratosactividad" do
    assert_difference('Contratosactividad.count') do
      post contratosactividades_url, params: { contratosactividad: { cantidad: @contratosactividad.cantidad, clase: @contratosactividad.clase, contrato_id: @contratosactividad.contrato_id, contratossede_id: @contratosactividad.contratossede_id, detalle: @contratosactividad.detalle, dia_semana: @contratosactividad.dia_semana, tipo: @contratosactividad.tipo, user_id: @contratosactividad.user_id } }
    end

    assert_redirected_to contratosactividad_url(Contratosactividad.last)
  end

  test "should show contratosactividad" do
    get contratosactividad_url(@contratosactividad)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosactividad_url(@contratosactividad)
    assert_response :success
  end

  test "should update contratosactividad" do
    patch contratosactividad_url(@contratosactividad), params: { contratosactividad: { cantidad: @contratosactividad.cantidad, clase: @contratosactividad.clase, contrato_id: @contratosactividad.contrato_id, contratossede_id: @contratosactividad.contratossede_id, detalle: @contratosactividad.detalle, dia_semana: @contratosactividad.dia_semana, tipo: @contratosactividad.tipo, user_id: @contratosactividad.user_id } }
    assert_redirected_to contratosactividad_url(@contratosactividad)
  end

  test "should destroy contratosactividad" do
    assert_difference('Contratosactividad.count', -1) do
      delete contratosactividad_url(@contratosactividad)
    end

    assert_redirected_to contratosactividades_url
  end
end
