require 'test_helper'

class VisitasnotasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @visitasnota = visitasnotas(:one)
  end

  test "should get index" do
    get visitasnotas_url
    assert_response :success
  end

  test "should get new" do
    get new_visitasnota_url
    assert_response :success
  end

  test "should create visitasnota" do
    assert_difference('Visitasnota.count') do
      post visitasnotas_url, params: { visitasnota: { nota: @visitasnota.nota, user_id: @visitasnota.user_id, visita_id: @visitasnota.visita_id } }
    end

    assert_redirected_to visitasnota_url(Visitasnota.last)
  end

  test "should show visitasnota" do
    get visitasnota_url(@visitasnota)
    assert_response :success
  end

  test "should get edit" do
    get edit_visitasnota_url(@visitasnota)
    assert_response :success
  end

  test "should update visitasnota" do
    patch visitasnota_url(@visitasnota), params: { visitasnota: { nota: @visitasnota.nota, user_id: @visitasnota.user_id, visita_id: @visitasnota.visita_id } }
    assert_redirected_to visitasnota_url(@visitasnota)
  end

  test "should destroy visitasnota" do
    assert_difference('Visitasnota.count', -1) do
      delete visitasnota_url(@visitasnota)
    end

    assert_redirected_to visitasnotas_url
  end
end
