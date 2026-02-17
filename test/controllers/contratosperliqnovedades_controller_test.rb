require 'test_helper'

class ContratosperliqnovedadesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosperliqnovedad = contratosperliqnovedades(:one)
  end

  test "should get index" do
    get contratosperliqnovedades_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosperliqnovedad_url
    assert_response :success
  end

  test "should create contratosperliqnovedad" do
    assert_difference('Contratosperliqnovedad.count') do
      post contratosperliqnovedades_url, params: { contratosperliqnovedad: { contratosperfecha_id: @contratosperliqnovedad.contratosperfecha_id, tiposnovedad_id: @contratosperliqnovedad.tiposnovedad_id, user_id: @contratosperliqnovedad.user_id, valor_novedad: @contratosperliqnovedad.valor_novedad } }
    end

    assert_redirected_to contratosperliqnovedad_url(Contratosperliqnovedad.last)
  end

  test "should show contratosperliqnovedad" do
    get contratosperliqnovedad_url(@contratosperliqnovedad)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosperliqnovedad_url(@contratosperliqnovedad)
    assert_response :success
  end

  test "should update contratosperliqnovedad" do
    patch contratosperliqnovedad_url(@contratosperliqnovedad), params: { contratosperliqnovedad: { contratosperfecha_id: @contratosperliqnovedad.contratosperfecha_id, tiposnovedad_id: @contratosperliqnovedad.tiposnovedad_id, user_id: @contratosperliqnovedad.user_id, valor_novedad: @contratosperliqnovedad.valor_novedad } }
    assert_redirected_to contratosperliqnovedad_url(@contratosperliqnovedad)
  end

  test "should destroy contratosperliqnovedad" do
    assert_difference('Contratosperliqnovedad.count', -1) do
      delete contratosperliqnovedad_url(@contratosperliqnovedad)
    end

    assert_redirected_to contratosperliqnovedades_url
  end
end
