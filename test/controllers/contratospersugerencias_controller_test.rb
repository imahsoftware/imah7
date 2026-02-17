require 'test_helper'

class ContratospersugerenciasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratospersugerencia = contratospersugerencias(:one)
  end

  test "should get index" do
    get contratospersugerencias_url
    assert_response :success
  end

  test "should get new" do
    get new_contratospersugerencia_url
    assert_response :success
  end

  test "should create contratospersugerencia" do
    assert_difference('Contratospersugerencia.count') do
      post contratospersugerencias_url, params: { contratospersugerencia: { contratospersona_id: @contratospersugerencia.contratospersona_id, correccion: @contratospersugerencia.correccion, fecha: @contratospersugerencia.fecha, prevencion: @contratospersugerencia.prevencion } }
    end

    assert_redirected_to contratospersugerencia_url(Contratospersugerencia.last)
  end

  test "should show contratospersugerencia" do
    get contratospersugerencia_url(@contratospersugerencia)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratospersugerencia_url(@contratospersugerencia)
    assert_response :success
  end

  test "should update contratospersugerencia" do
    patch contratospersugerencia_url(@contratospersugerencia), params: { contratospersugerencia: { contratospersona_id: @contratospersugerencia.contratospersona_id, correccion: @contratospersugerencia.correccion, fecha: @contratospersugerencia.fecha, prevencion: @contratospersugerencia.prevencion } }
    assert_redirected_to contratospersugerencia_url(@contratospersugerencia)
  end

  test "should destroy contratospersugerencia" do
    assert_difference('Contratospersugerencia.count', -1) do
      delete contratospersugerencia_url(@contratospersugerencia)
    end

    assert_redirected_to contratospersugerencias_url
  end
end
