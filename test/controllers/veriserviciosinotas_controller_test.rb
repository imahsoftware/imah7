require 'test_helper'

class VeriserviciosinotasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @veriserviciosinota = veriserviciosinotas(:one)
  end

  test "should get index" do
    get veriserviciosinotas_url
    assert_response :success
  end

  test "should get new" do
    get new_veriserviciosinota_url
    assert_response :success
  end

  test "should create veriserviciosinota" do
    assert_difference('Veriserviciosinota.count') do
      post veriserviciosinotas_url, params: { veriserviciosinota: { observacion: @veriserviciosinota.observacion, user_id: @veriserviciosinota.user_id, veriserviciositem_id: @veriserviciosinota.veriserviciositem_id } }
    end

    assert_redirected_to veriserviciosinota_url(Veriserviciosinota.last)
  end

  test "should show veriserviciosinota" do
    get veriserviciosinota_url(@veriserviciosinota)
    assert_response :success
  end

  test "should get edit" do
    get edit_veriserviciosinota_url(@veriserviciosinota)
    assert_response :success
  end

  test "should update veriserviciosinota" do
    patch veriserviciosinota_url(@veriserviciosinota), params: { veriserviciosinota: { observacion: @veriserviciosinota.observacion, user_id: @veriserviciosinota.user_id, veriserviciositem_id: @veriserviciosinota.veriserviciositem_id } }
    assert_redirected_to veriserviciosinota_url(@veriserviciosinota)
  end

  test "should destroy veriserviciosinota" do
    assert_difference('Veriserviciosinota.count', -1) do
      delete veriserviciosinota_url(@veriserviciosinota)
    end

    assert_redirected_to veriserviciosinotas_url
  end
end
