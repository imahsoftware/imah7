require 'test_helper'

class ContratosactcodigosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosactcodigo = contratosactcodigos(:one)
  end

  test "should get index" do
    get contratosactcodigos_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosactcodigo_url
    assert_response :success
  end

  test "should create contratosactcodigo" do
    assert_difference('Contratosactcodigo.count') do
      post contratosactcodigos_url, params: { contratosactcodigo: { contratossede_id: @contratosactcodigo.contratossede_id, sap_clasificacion: @contratosactcodigo.sap_clasificacion, sap_codigo: @contratosactcodigo.sap_codigo, sap_nota: @contratosactcodigo.sap_nota, user_id: @contratosactcodigo.user_id } }
    end

    assert_redirected_to contratosactcodigo_url(Contratosactcodigo.last)
  end

  test "should show contratosactcodigo" do
    get contratosactcodigo_url(@contratosactcodigo)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosactcodigo_url(@contratosactcodigo)
    assert_response :success
  end

  test "should update contratosactcodigo" do
    patch contratosactcodigo_url(@contratosactcodigo), params: { contratosactcodigo: { contratossede_id: @contratosactcodigo.contratossede_id, sap_clasificacion: @contratosactcodigo.sap_clasificacion, sap_codigo: @contratosactcodigo.sap_codigo, sap_nota: @contratosactcodigo.sap_nota, user_id: @contratosactcodigo.user_id } }
    assert_redirected_to contratosactcodigo_url(@contratosactcodigo)
  end

  test "should destroy contratosactcodigo" do
    assert_difference('Contratosactcodigo.count', -1) do
      delete contratosactcodigo_url(@contratosactcodigo)
    end

    assert_redirected_to contratosactcodigos_url
  end
end
