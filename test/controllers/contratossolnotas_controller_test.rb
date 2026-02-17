require 'test_helper'

class ContratossolnotasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratossolnota = contratossolnotas(:one)
  end

  test "should get index" do
    get contratossolnotas_url
    assert_response :success
  end

  test "should get new" do
    get new_contratossolnota_url
    assert_response :success
  end

  test "should create contratossolnota" do
    assert_difference('Contratossolnota.count') do
      post contratossolnotas_url, params: { contratossolnota: { contratossolicitud_id: @contratossolnota.contratossolicitud_id, observacion: @contratossolnota.observacion, user_id: @contratossolnota.user_id } }
    end

    assert_redirected_to contratossolnota_url(Contratossolnota.last)
  end

  test "should show contratossolnota" do
    get contratossolnota_url(@contratossolnota)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratossolnota_url(@contratossolnota)
    assert_response :success
  end

  test "should update contratossolnota" do
    patch contratossolnota_url(@contratossolnota), params: { contratossolnota: { contratossolicitud_id: @contratossolnota.contratossolicitud_id, observacion: @contratossolnota.observacion, user_id: @contratossolnota.user_id } }
    assert_redirected_to contratossolnota_url(@contratossolnota)
  end

  test "should destroy contratossolnota" do
    assert_difference('Contratossolnota.count', -1) do
      delete contratossolnota_url(@contratossolnota)
    end

    assert_redirected_to contratossolnotas_url
  end
end
