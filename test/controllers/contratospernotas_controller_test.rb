require 'test_helper'

class ContratospernotasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratospernota = contratospernotas(:one)
  end

  test "should get index" do
    get contratospernotas_url
    assert_response :success
  end

  test "should get new" do
    get new_contratospernota_url
    assert_response :success
  end

  test "should create contratospernota" do
    assert_difference('Contratospernota.count') do
      post contratospernotas_url, params: { contratospernota: { contratospersona_id: @contratospernota.contratospersona_id, fecha: @contratospernota.fecha, observacion: @contratospernota.observacion } }
    end

    assert_redirected_to contratospernota_url(Contratospernota.last)
  end

  test "should show contratospernota" do
    get contratospernota_url(@contratospernota)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratospernota_url(@contratospernota)
    assert_response :success
  end

  test "should update contratospernota" do
    patch contratospernota_url(@contratospernota), params: { contratospernota: { contratospersona_id: @contratospernota.contratospersona_id, fecha: @contratospernota.fecha, observacion: @contratospernota.observacion } }
    assert_redirected_to contratospernota_url(@contratospernota)
  end

  test "should destroy contratospernota" do
    assert_difference('Contratospernota.count', -1) do
      delete contratospernota_url(@contratospernota)
    end

    assert_redirected_to contratospernotas_url
  end
end
