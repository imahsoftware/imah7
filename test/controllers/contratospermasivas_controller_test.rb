require 'test_helper'

class ContratospermasivasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratospermasiva = contratospermasivas(:one)
  end

  test "should get index" do
    get contratospermasivas_url
    assert_response :success
  end

  test "should get new" do
    get new_contratospermasiva_url
    assert_response :success
  end

  test "should create contratospermasiva" do
    assert_difference('Contratospermasiva.count') do
      post contratospermasivas_url, params: { contratospermasiva: { contrato_id: @contratospermasiva.contrato_id, contratosgrupo_id: @contratospermasiva.contratosgrupo_id, fecha: @contratospermasiva.fecha, observacion: @contratospermasiva.observacion, user_id: @contratospermasiva.user_id } }
    end

    assert_redirected_to contratospermasiva_url(Contratospermasiva.last)
  end

  test "should show contratospermasiva" do
    get contratospermasiva_url(@contratospermasiva)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratospermasiva_url(@contratospermasiva)
    assert_response :success
  end

  test "should update contratospermasiva" do
    patch contratospermasiva_url(@contratospermasiva), params: { contratospermasiva: { contrato_id: @contratospermasiva.contrato_id, contratosgrupo_id: @contratospermasiva.contratosgrupo_id, fecha: @contratospermasiva.fecha, observacion: @contratospermasiva.observacion, user_id: @contratospermasiva.user_id } }
    assert_redirected_to contratospermasiva_url(@contratospermasiva)
  end

  test "should destroy contratospermasiva" do
    assert_difference('Contratospermasiva.count', -1) do
      delete contratospermasiva_url(@contratospermasiva)
    end

    assert_redirected_to contratospermasivas_url
  end
end
