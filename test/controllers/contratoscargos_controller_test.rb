require 'test_helper'

class ContratoscargosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratoscargo = contratoscargos(:one)
  end

  test "should get index" do
    get contratoscargos_url
    assert_response :success
  end

  test "should get new" do
    get new_contratoscargo_url
    assert_response :success
  end

  test "should create contratoscargo" do
    assert_difference('Contratoscargo.count') do
      post contratoscargos_url, params: { contratoscargo: { cantidad: @contratoscargo.cantidad, contrato_id: @contratoscargo.contrato_id, disponibilidad: @contratoscargo.disponibilidad, perfil: @contratoscargo.perfil, salario: @contratoscargo.salario, tiposcargo_id: @contratoscargo.tiposcargo_id, user_act: @contratoscargo.user_act, user_id: @contratoscargo.user_id } }
    end

    assert_redirected_to contratoscargo_url(Contratoscargo.last)
  end

  test "should show contratoscargo" do
    get contratoscargo_url(@contratoscargo)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratoscargo_url(@contratoscargo)
    assert_response :success
  end

  test "should update contratoscargo" do
    patch contratoscargo_url(@contratoscargo), params: { contratoscargo: { cantidad: @contratoscargo.cantidad, contrato_id: @contratoscargo.contrato_id, disponibilidad: @contratoscargo.disponibilidad, perfil: @contratoscargo.perfil, salario: @contratoscargo.salario, tiposcargo_id: @contratoscargo.tiposcargo_id, user_act: @contratoscargo.user_act, user_id: @contratoscargo.user_id } }
    assert_redirected_to contratoscargo_url(@contratoscargo)
  end

  test "should destroy contratoscargo" do
    assert_difference('Contratoscargo.count', -1) do
      delete contratoscargo_url(@contratoscargo)
    end

    assert_redirected_to contratoscargos_url
  end
end
