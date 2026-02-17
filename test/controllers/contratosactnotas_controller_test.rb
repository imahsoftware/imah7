require 'test_helper'

class ContratosactnotasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosactnota = contratosactnotas(:one)
  end

  test "should get index" do
    get contratosactnotas_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosactnota_url
    assert_response :success
  end

  test "should create contratosactnota" do
    assert_difference('Contratosactnota.count') do
      post contratosactnotas_url, params: { contratosactnota: { contratosactividad_id: @contratosactnota.contratosactividad_id, contratossede_id: @contratosactnota.contratossede_id, nota: @contratosactnota.nota, user_id: @contratosactnota.user_id } }
    end

    assert_redirected_to contratosactnota_url(Contratosactnota.last)
  end

  test "should show contratosactnota" do
    get contratosactnota_url(@contratosactnota)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosactnota_url(@contratosactnota)
    assert_response :success
  end

  test "should update contratosactnota" do
    patch contratosactnota_url(@contratosactnota), params: { contratosactnota: { contratosactividad_id: @contratosactnota.contratosactividad_id, contratossede_id: @contratosactnota.contratossede_id, nota: @contratosactnota.nota, user_id: @contratosactnota.user_id } }
    assert_redirected_to contratosactnota_url(@contratosactnota)
  end

  test "should destroy contratosactnota" do
    assert_difference('Contratosactnota.count', -1) do
      delete contratosactnota_url(@contratosactnota)
    end

    assert_redirected_to contratosactnotas_url
  end
end
