require 'test_helper'

class ContratosperprodescargosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosperprodescargo = contratosperprodescargos(:one)
  end

  test "should get index" do
    get contratosperprodescargos_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosperprodescargo_url
    assert_response :success
  end

  test "should create contratosperprodescargo" do
    assert_difference('Contratosperprodescargo.count') do
      post contratosperprodescargos_url, params: { contratosperprodescargo: { asear: @contratosperprodescargo.asear, contratosperproceso_id: @contratosperprodescargo.contratosperproceso_id, contratospersona_id: @contratosperprodescargo.contratospersona_id, empleado: @contratosperprodescargo.empleado, user_id: @contratosperprodescargo.user_id } }
    end

    assert_redirected_to contratosperprodescargo_url(Contratosperprodescargo.last)
  end

  test "should show contratosperprodescargo" do
    get contratosperprodescargo_url(@contratosperprodescargo)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosperprodescargo_url(@contratosperprodescargo)
    assert_response :success
  end

  test "should update contratosperprodescargo" do
    patch contratosperprodescargo_url(@contratosperprodescargo), params: { contratosperprodescargo: { asear: @contratosperprodescargo.asear, contratosperproceso_id: @contratosperprodescargo.contratosperproceso_id, contratospersona_id: @contratosperprodescargo.contratospersona_id, empleado: @contratosperprodescargo.empleado, user_id: @contratosperprodescargo.user_id } }
    assert_redirected_to contratosperprodescargo_url(@contratosperprodescargo)
  end

  test "should destroy contratosperprodescargo" do
    assert_difference('Contratosperprodescargo.count', -1) do
      delete contratosperprodescargo_url(@contratosperprodescargo)
    end

    assert_redirected_to contratosperprodescargos_url
  end
end
