require 'test_helper'

class ParcargosdocsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @parcargosdoc = parcargosdocs(:one)
  end

  test "should get index" do
    get parcargosdocs_url
    assert_response :success
  end

  test "should get new" do
    get new_parcargosdoc_url
    assert_response :success
  end

  test "should create parcargosdoc" do
    assert_difference('Parcargosdoc.count') do
      post parcargosdocs_url, params: { parcargosdoc: { estado: @parcargosdoc.estado, obligatorio: @parcargosdoc.obligatorio, observacion: @parcargosdoc.observacion, parcargo_id: @parcargosdoc.parcargo_id, user_id: @parcargosdoc.user_id } }
    end

    assert_redirected_to parcargosdoc_url(Parcargosdoc.last)
  end

  test "should show parcargosdoc" do
    get parcargosdoc_url(@parcargosdoc)
    assert_response :success
  end

  test "should get edit" do
    get edit_parcargosdoc_url(@parcargosdoc)
    assert_response :success
  end

  test "should update parcargosdoc" do
    patch parcargosdoc_url(@parcargosdoc), params: { parcargosdoc: { estado: @parcargosdoc.estado, obligatorio: @parcargosdoc.obligatorio, observacion: @parcargosdoc.observacion, parcargo_id: @parcargosdoc.parcargo_id, user_id: @parcargosdoc.user_id } }
    assert_redirected_to parcargosdoc_url(@parcargosdoc)
  end

  test "should destroy parcargosdoc" do
    assert_difference('Parcargosdoc.count', -1) do
      delete parcargosdoc_url(@parcargosdoc)
    end

    assert_redirected_to parcargosdocs_url
  end
end
