require 'test_helper'

class ContratosperinvnotasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosperinvnota = contratosperinvnotas(:one)
  end

  test "should get index" do
    get contratosperinvnotas_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosperinvnota_url
    assert_response :success
  end

  test "should create contratosperinvnota" do
    assert_difference('Contratosperinvnota.count') do
      post contratosperinvnotas_url, params: { contratosperinvnota: { nota: @contratosperinvnota.nota } }
    end

    assert_redirected_to contratosperinvnota_url(Contratosperinvnota.last)
  end

  test "should show contratosperinvnota" do
    get contratosperinvnota_url(@contratosperinvnota)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosperinvnota_url(@contratosperinvnota)
    assert_response :success
  end

  test "should update contratosperinvnota" do
    patch contratosperinvnota_url(@contratosperinvnota), params: { contratosperinvnota: { nota: @contratosperinvnota.nota } }
    assert_redirected_to contratosperinvnota_url(@contratosperinvnota)
  end

  test "should destroy contratosperinvnota" do
    assert_difference('Contratosperinvnota.count', -1) do
      delete contratosperinvnota_url(@contratosperinvnota)
    end

    assert_redirected_to contratosperinvnotas_url
  end
end
