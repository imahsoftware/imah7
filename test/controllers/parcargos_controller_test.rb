require 'test_helper'

class ParcargosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @parcargo = parcargos(:one)
  end

  test "should get index" do
    get parcargos_url
    assert_response :success
  end

  test "should get new" do
    get new_parcargo_url
    assert_response :success
  end

  test "should create parcargo" do
    assert_difference('Parcargo.count') do
      post parcargos_url, params: { parcargo: { descripcion: @parcargo.descripcion, estado: @parcargo.estado, observacion: @parcargo.observacion } }
    end

    assert_redirected_to parcargo_url(Parcargo.last)
  end

  test "should show parcargo" do
    get parcargo_url(@parcargo)
    assert_response :success
  end

  test "should get edit" do
    get edit_parcargo_url(@parcargo)
    assert_response :success
  end

  test "should update parcargo" do
    patch parcargo_url(@parcargo), params: { parcargo: { descripcion: @parcargo.descripcion, estado: @parcargo.estado, observacion: @parcargo.observacion } }
    assert_redirected_to parcargo_url(@parcargo)
  end

  test "should destroy parcargo" do
    assert_difference('Parcargo.count', -1) do
      delete parcargo_url(@parcargo)
    end

    assert_redirected_to parcargos_url
  end
end
