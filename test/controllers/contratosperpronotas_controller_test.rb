require 'test_helper'

class ContratosperpronotasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosperpronota = contratosperpronotas(:one)
  end

  test "should get index" do
    get contratosperpronotas_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosperpronota_url
    assert_response :success
  end

  test "should create contratosperpronota" do
    assert_difference('Contratosperpronota.count') do
      post contratosperpronotas_url, params: { contratosperpronota: { contratosperproceso_id: @contratosperpronota.contratosperproceso_id, contratospersona_id: @contratosperpronota.contratospersona_id, nota: @contratosperpronota.nota, user_id: @contratosperpronota.user_id } }
    end

    assert_redirected_to contratosperpronota_url(Contratosperpronota.last)
  end

  test "should show contratosperpronota" do
    get contratosperpronota_url(@contratosperpronota)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosperpronota_url(@contratosperpronota)
    assert_response :success
  end

  test "should update contratosperpronota" do
    patch contratosperpronota_url(@contratosperpronota), params: { contratosperpronota: { contratosperproceso_id: @contratosperpronota.contratosperproceso_id, contratospersona_id: @contratosperpronota.contratospersona_id, nota: @contratosperpronota.nota, user_id: @contratosperpronota.user_id } }
    assert_redirected_to contratosperpronota_url(@contratosperpronota)
  end

  test "should destroy contratosperpronota" do
    assert_difference('Contratosperpronota.count', -1) do
      delete contratosperpronota_url(@contratosperpronota)
    end

    assert_redirected_to contratosperpronotas_url
  end
end
