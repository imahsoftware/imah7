require 'test_helper'

class ParcagosdocsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @parcagosdoc = parcagosdocs(:one)
  end

  test "should get index" do
    get parcagosdocs_url
    assert_response :success
  end

  test "should get new" do
    get new_parcagosdoc_url
    assert_response :success
  end

  test "should create parcagosdoc" do
    assert_difference('Parcagosdoc.count') do
      post parcagosdocs_url, params: { parcagosdoc: { estado: @parcagosdoc.estado, obligatorio: @parcagosdoc.obligatorio, observacion: @parcagosdoc.observacion, parcargo_id: @parcagosdoc.parcargo_id, user_id: @parcagosdoc.user_id } }
    end

    assert_redirected_to parcagosdoc_url(Parcagosdoc.last)
  end

  test "should show parcagosdoc" do
    get parcagosdoc_url(@parcagosdoc)
    assert_response :success
  end

  test "should get edit" do
    get edit_parcagosdoc_url(@parcagosdoc)
    assert_response :success
  end

  test "should update parcagosdoc" do
    patch parcagosdoc_url(@parcagosdoc), params: { parcagosdoc: { estado: @parcagosdoc.estado, obligatorio: @parcagosdoc.obligatorio, observacion: @parcagosdoc.observacion, parcargo_id: @parcagosdoc.parcargo_id, user_id: @parcagosdoc.user_id } }
    assert_redirected_to parcagosdoc_url(@parcagosdoc)
  end

  test "should destroy parcagosdoc" do
    assert_difference('Parcagosdoc.count', -1) do
      delete parcagosdoc_url(@parcagosdoc)
    end

    assert_redirected_to parcagosdocs_url
  end
end
