require 'test_helper'

class ContratostiposnovedadesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratostiposnovedad = contratostiposnovedades(:one)
  end

  test "should get index" do
    get contratostiposnovedades_url
    assert_response :success
  end

  test "should get new" do
    get new_contratostiposnovedad_url
    assert_response :success
  end

  test "should create contratostiposnovedad" do
    assert_difference('Contratostiposnovedad.count') do
      post contratostiposnovedades_url, params: { contratostiposnovedad: { contrato_id: @contratostiposnovedad.contrato_id, tiposnovedad_id: @contratostiposnovedad.tiposnovedad_id } }
    end

    assert_redirected_to contratostiposnovedad_url(Contratostiposnovedad.last)
  end

  test "should show contratostiposnovedad" do
    get contratostiposnovedad_url(@contratostiposnovedad)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratostiposnovedad_url(@contratostiposnovedad)
    assert_response :success
  end

  test "should update contratostiposnovedad" do
    patch contratostiposnovedad_url(@contratostiposnovedad), params: { contratostiposnovedad: { contrato_id: @contratostiposnovedad.contrato_id, tiposnovedad_id: @contratostiposnovedad.tiposnovedad_id } }
    assert_redirected_to contratostiposnovedad_url(@contratostiposnovedad)
  end

  test "should destroy contratostiposnovedad" do
    assert_difference('Contratostiposnovedad.count', -1) do
      delete contratostiposnovedad_url(@contratostiposnovedad)
    end

    assert_redirected_to contratostiposnovedades_url
  end
end
