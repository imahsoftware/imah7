require 'test_helper'

class ContratosenteppsfirmasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosenteppsfirma = contratosenteppsfirmas(:one)
  end

  test "should get index" do
    get contratosenteppsfirmas_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosenteppsfirma_url
    assert_response :success
  end

  test "should create contratosenteppsfirma" do
    assert_difference('Contratosenteppsfirma.count') do
      post contratosenteppsfirmas_url, params: { contratosenteppsfirma: { codigo_env: @contratosenteppsfirma.codigo_env, codigo_firma: @contratosenteppsfirma.codigo_firma, codigo_rec: @contratosenteppsfirma.codigo_rec, contratosentepp_id: @contratosenteppsfirma.contratosentepp_id, contratosperfecha_id: @contratosenteppsfirma.contratosperfecha_id, fecha_firma: @contratosenteppsfirma.fecha_firma } }
    end

    assert_redirected_to contratosenteppsfirma_url(Contratosenteppsfirma.last)
  end

  test "should show contratosenteppsfirma" do
    get contratosenteppsfirma_url(@contratosenteppsfirma)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosenteppsfirma_url(@contratosenteppsfirma)
    assert_response :success
  end

  test "should update contratosenteppsfirma" do
    patch contratosenteppsfirma_url(@contratosenteppsfirma), params: { contratosenteppsfirma: { codigo_env: @contratosenteppsfirma.codigo_env, codigo_firma: @contratosenteppsfirma.codigo_firma, codigo_rec: @contratosenteppsfirma.codigo_rec, contratosentepp_id: @contratosenteppsfirma.contratosentepp_id, contratosperfecha_id: @contratosenteppsfirma.contratosperfecha_id, fecha_firma: @contratosenteppsfirma.fecha_firma } }
    assert_redirected_to contratosenteppsfirma_url(@contratosenteppsfirma)
  end

  test "should destroy contratosenteppsfirma" do
    assert_difference('Contratosenteppsfirma.count', -1) do
      delete contratosenteppsfirma_url(@contratosenteppsfirma)
    end

    assert_redirected_to contratosenteppsfirmas_url
  end
end
