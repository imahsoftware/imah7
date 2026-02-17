require 'test_helper'

class ContratospernovedadesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratospernovedad = contratospernovedades(:one)
  end

  test "should get index" do
    get contratospernovedades_url
    assert_response :success
  end

  test "should get new" do
    get new_contratospernovedad_url
    assert_response :success
  end

  test "should create contratospernovedad" do
    assert_difference('Contratospernovedad.count') do
      post contratospernovedades_url, params: { contratospernovedad: { contratospersona_id: @contratospernovedad.contratospersona_id, fecha: @contratospernovedad.fecha, observacion: @contratospernovedad.observacion, tiposnovedad_id: @contratospernovedad.tiposnovedad_id, user_id: @contratospernovedad.user_id } }
    end

    assert_redirected_to contratospernovedad_url(Contratospernovedad.last)
  end

  test "should show contratospernovedad" do
    get contratospernovedad_url(@contratospernovedad)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratospernovedad_url(@contratospernovedad)
    assert_response :success
  end

  test "should update contratospernovedad" do
    patch contratospernovedad_url(@contratospernovedad), params: { contratospernovedad: { contratospersona_id: @contratospernovedad.contratospersona_id, fecha: @contratospernovedad.fecha, observacion: @contratospernovedad.observacion, tiposnovedad_id: @contratospernovedad.tiposnovedad_id, user_id: @contratospernovedad.user_id } }
    assert_redirected_to contratospernovedad_url(@contratospernovedad)
  end

  test "should destroy contratospernovedad" do
    assert_difference('Contratospernovedad.count', -1) do
      delete contratospernovedad_url(@contratospernovedad)
    end

    assert_redirected_to contratospernovedades_url
  end
end
