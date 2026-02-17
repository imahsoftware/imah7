require 'test_helper'

class ContratoscargosnotasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratoscargosnota = contratoscargosnotas(:one)
  end

  test "should get index" do
    get contratoscargosnotas_url
    assert_response :success
  end

  test "should get new" do
    get new_contratoscargosnota_url
    assert_response :success
  end

  test "should create contratoscargosnota" do
    assert_difference('Contratoscargosnota.count') do
      post contratoscargosnotas_url, params: { contratoscargosnota: { contratoscargo_id: @contratoscargosnota.contratoscargo_id, observacion: @contratoscargosnota.observacion, user_id: @contratoscargosnota.user_id } }
    end

    assert_redirected_to contratoscargosnota_url(Contratoscargosnota.last)
  end

  test "should show contratoscargosnota" do
    get contratoscargosnota_url(@contratoscargosnota)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratoscargosnota_url(@contratoscargosnota)
    assert_response :success
  end

  test "should update contratoscargosnota" do
    patch contratoscargosnota_url(@contratoscargosnota), params: { contratoscargosnota: { contratoscargo_id: @contratoscargosnota.contratoscargo_id, observacion: @contratoscargosnota.observacion, user_id: @contratoscargosnota.user_id } }
    assert_redirected_to contratoscargosnota_url(@contratoscargosnota)
  end

  test "should destroy contratoscargosnota" do
    assert_difference('Contratoscargosnota.count', -1) do
      delete contratoscargosnota_url(@contratoscargosnota)
    end

    assert_redirected_to contratoscargosnotas_url
  end
end
