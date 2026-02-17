require 'test_helper'

class ContratossoleppsbitacorasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratossoleppsbitacora = contratossoleppsbitacoras(:one)
  end

  test "should get index" do
    get contratossoleppsbitacoras_url
    assert_response :success
  end

  test "should get new" do
    get new_contratossoleppsbitacora_url
    assert_response :success
  end

  test "should create contratossoleppsbitacora" do
    assert_difference('Contratossoleppsbitacora.count') do
      post contratossoleppsbitacoras_url, params: { contratossoleppsbitacora: { contratossolepp_id: @contratossoleppsbitacora.contratossolepp_id, detalle: @contratossoleppsbitacora.detalle } }
    end

    assert_redirected_to contratossoleppsbitacora_url(Contratossoleppsbitacora.last)
  end

  test "should show contratossoleppsbitacora" do
    get contratossoleppsbitacora_url(@contratossoleppsbitacora)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratossoleppsbitacora_url(@contratossoleppsbitacora)
    assert_response :success
  end

  test "should update contratossoleppsbitacora" do
    patch contratossoleppsbitacora_url(@contratossoleppsbitacora), params: { contratossoleppsbitacora: { contratossolepp_id: @contratossoleppsbitacora.contratossolepp_id, detalle: @contratossoleppsbitacora.detalle } }
    assert_redirected_to contratossoleppsbitacora_url(@contratossoleppsbitacora)
  end

  test "should destroy contratossoleppsbitacora" do
    assert_difference('Contratossoleppsbitacora.count', -1) do
      delete contratossoleppsbitacora_url(@contratossoleppsbitacora)
    end

    assert_redirected_to contratossoleppsbitacoras_url
  end
end
