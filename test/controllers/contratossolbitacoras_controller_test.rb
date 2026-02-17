require 'test_helper'

class ContratossolbitacorasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratossolbitacora = contratossolbitacoras(:one)
  end

  test "should get index" do
    get contratossolbitacoras_url
    assert_response :success
  end

  test "should get new" do
    get new_contratossolbitacora_url
    assert_response :success
  end

  test "should create contratossolbitacora" do
    assert_difference('Contratossolbitacora.count') do
      post contratossolbitacoras_url, params: { contratossolbitacora: { contratossolicitud_id: @contratossolbitacora.contratossolicitud_id, estado: @contratossolbitacora.estado, user_id: @contratossolbitacora.user_id } }
    end

    assert_redirected_to contratossolbitacora_url(Contratossolbitacora.last)
  end

  test "should show contratossolbitacora" do
    get contratossolbitacora_url(@contratossolbitacora)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratossolbitacora_url(@contratossolbitacora)
    assert_response :success
  end

  test "should update contratossolbitacora" do
    patch contratossolbitacora_url(@contratossolbitacora), params: { contratossolbitacora: { contratossolicitud_id: @contratossolbitacora.contratossolicitud_id, estado: @contratossolbitacora.estado, user_id: @contratossolbitacora.user_id } }
    assert_redirected_to contratossolbitacora_url(@contratossolbitacora)
  end

  test "should destroy contratossolbitacora" do
    assert_difference('Contratossolbitacora.count', -1) do
      delete contratossolbitacora_url(@contratossolbitacora)
    end

    assert_redirected_to contratossolbitacoras_url
  end
end
