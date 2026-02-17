require 'test_helper'

class ContratosperbitacorasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosperbitacora = contratosperbitacoras(:one)
  end

  test "should get index" do
    get contratosperbitacoras_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosperbitacora_url
    assert_response :success
  end

  test "should create contratosperbitacora" do
    assert_difference('Contratosperbitacora.count') do
      post contratosperbitacoras_url, params: { contratosperbitacora: { contratospersona_id: @contratosperbitacora.contratospersona_id, estado: @contratosperbitacora.estado, user_id: @contratosperbitacora.user_id } }
    end

    assert_redirected_to contratosperbitacora_url(Contratosperbitacora.last)
  end

  test "should show contratosperbitacora" do
    get contratosperbitacora_url(@contratosperbitacora)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosperbitacora_url(@contratosperbitacora)
    assert_response :success
  end

  test "should update contratosperbitacora" do
    patch contratosperbitacora_url(@contratosperbitacora), params: { contratosperbitacora: { contratospersona_id: @contratosperbitacora.contratospersona_id, estado: @contratosperbitacora.estado, user_id: @contratosperbitacora.user_id } }
    assert_redirected_to contratosperbitacora_url(@contratosperbitacora)
  end

  test "should destroy contratosperbitacora" do
    assert_difference('Contratosperbitacora.count', -1) do
      delete contratosperbitacora_url(@contratosperbitacora)
    end

    assert_redirected_to contratosperbitacoras_url
  end
end
