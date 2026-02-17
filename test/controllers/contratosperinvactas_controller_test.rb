require 'test_helper'

class ContratosperinvactasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosperinvacta = contratosperinvactas(:one)
  end

  test "should get index" do
    get contratosperinvactas_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosperinvacta_url
    assert_response :success
  end

  test "should create contratosperinvacta" do
    assert_difference('Contratosperinvacta.count') do
      post contratosperinvactas_url, params: { contratosperinvacta: { consecutivo_acta: @contratosperinvacta.consecutivo_acta, contratosperinventario_id: @contratosperinvacta.contratosperinventario_id } }
    end

    assert_redirected_to contratosperinvacta_url(Contratosperinvacta.last)
  end

  test "should show contratosperinvacta" do
    get contratosperinvacta_url(@contratosperinvacta)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosperinvacta_url(@contratosperinvacta)
    assert_response :success
  end

  test "should update contratosperinvacta" do
    patch contratosperinvacta_url(@contratosperinvacta), params: { contratosperinvacta: { consecutivo_acta: @contratosperinvacta.consecutivo_acta, contratosperinventario_id: @contratosperinvacta.contratosperinventario_id } }
    assert_redirected_to contratosperinvacta_url(@contratosperinvacta)
  end

  test "should destroy contratosperinvacta" do
    assert_difference('Contratosperinvacta.count', -1) do
      delete contratosperinvacta_url(@contratosperinvacta)
    end

    assert_redirected_to contratosperinvactas_url
  end
end
