require 'test_helper'

class SoportesnotasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @soportesnota = soportesnotas(:one)
  end

  test "should get index" do
    get soportesnotas_url
    assert_response :success
  end

  test "should get new" do
    get new_soportesnota_url
    assert_response :success
  end

  test "should create soportesnota" do
    assert_difference('Soportesnota.count') do
      post soportesnotas_url, params: { soportesnota: { observaciones: @soportesnota.observaciones, soporte_id: @soportesnota.soporte_id, user_id: @soportesnota.user_id } }
    end

    assert_redirected_to soportesnota_url(Soportesnota.last)
  end

  test "should show soportesnota" do
    get soportesnota_url(@soportesnota)
    assert_response :success
  end

  test "should get edit" do
    get edit_soportesnota_url(@soportesnota)
    assert_response :success
  end

  test "should update soportesnota" do
    patch soportesnota_url(@soportesnota), params: { soportesnota: { observaciones: @soportesnota.observaciones, soporte_id: @soportesnota.soporte_id, user_id: @soportesnota.user_id } }
    assert_redirected_to soportesnota_url(@soportesnota)
  end

  test "should destroy soportesnota" do
    assert_difference('Soportesnota.count', -1) do
      delete soportesnota_url(@soportesnota)
    end

    assert_redirected_to soportesnotas_url
  end
end
