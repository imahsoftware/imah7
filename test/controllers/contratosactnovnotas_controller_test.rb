require 'test_helper'

class ContratosactnovnotasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosactnovnota = contratosactnovnotas(:one)
  end

  test "should get index" do
    get contratosactnovnotas_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosactnovnota_url
    assert_response :success
  end

  test "should create contratosactnovnota" do
    assert_difference('Contratosactnovnota.count') do
      post contratosactnovnotas_url, params: { contratosactnovnota: { contratosactnovedad_id: @contratosactnovnota.contratosactnovedad_id, observacion: @contratosactnovnota.observacion, user_id: @contratosactnovnota.user_id } }
    end

    assert_redirected_to contratosactnovnota_url(Contratosactnovnota.last)
  end

  test "should show contratosactnovnota" do
    get contratosactnovnota_url(@contratosactnovnota)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosactnovnota_url(@contratosactnovnota)
    assert_response :success
  end

  test "should update contratosactnovnota" do
    patch contratosactnovnota_url(@contratosactnovnota), params: { contratosactnovnota: { contratosactnovedad_id: @contratosactnovnota.contratosactnovedad_id, observacion: @contratosactnovnota.observacion, user_id: @contratosactnovnota.user_id } }
    assert_redirected_to contratosactnovnota_url(@contratosactnovnota)
  end

  test "should destroy contratosactnovnota" do
    assert_difference('Contratosactnovnota.count', -1) do
      delete contratosactnovnota_url(@contratosactnovnota)
    end

    assert_redirected_to contratosactnovnotas_url
  end
end
