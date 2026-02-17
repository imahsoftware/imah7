require 'test_helper'

class ContratosautoinsumosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosautoinsumo = contratosautoinsumos(:one)
  end

  test "should get index" do
    get contratosautoinsumos_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosautoinsumo_url
    assert_response :success
  end

  test "should create contratosautoinsumo" do
    assert_difference('Contratosautoinsumo.count') do
      post contratosautoinsumos_url, params: { contratosautoinsumo: { contrato_id: @contratosautoinsumo.contrato_id, insumo_id: @contratosautoinsumo.insumo_id, user_id: @contratosautoinsumo.user_id } }
    end

    assert_redirected_to contratosautoinsumo_url(Contratosautoinsumo.last)
  end

  test "should show contratosautoinsumo" do
    get contratosautoinsumo_url(@contratosautoinsumo)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosautoinsumo_url(@contratosautoinsumo)
    assert_response :success
  end

  test "should update contratosautoinsumo" do
    patch contratosautoinsumo_url(@contratosautoinsumo), params: { contratosautoinsumo: { contrato_id: @contratosautoinsumo.contrato_id, insumo_id: @contratosautoinsumo.insumo_id, user_id: @contratosautoinsumo.user_id } }
    assert_redirected_to contratosautoinsumo_url(@contratosautoinsumo)
  end

  test "should destroy contratosautoinsumo" do
    assert_difference('Contratosautoinsumo.count', -1) do
      delete contratosautoinsumo_url(@contratosautoinsumo)
    end

    assert_redirected_to contratosautoinsumos_url
  end
end
