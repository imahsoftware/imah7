require 'test_helper'

class ContratosperdotadicionalesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosperdotadicional = contratosperdotadicionales(:one)
  end

  test "should get index" do
    get contratosperdotadicionales_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosperdotadicional_url
    assert_response :success
  end

  test "should create contratosperdotadicional" do
    assert_difference('Contratosperdotadicional.count') do
      post contratosperdotadicionales_url, params: { contratosperdotadicional: { cantidad: @contratosperdotadicional.cantidad, contratosperdotacion_id: @contratosperdotadicional.contratosperdotacion_id, elemento: @contratosperdotadicional.elemento, user_id: @contratosperdotadicional.user_id } }
    end

    assert_redirected_to contratosperdotadicional_url(Contratosperdotadicional.last)
  end

  test "should show contratosperdotadicional" do
    get contratosperdotadicional_url(@contratosperdotadicional)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosperdotadicional_url(@contratosperdotadicional)
    assert_response :success
  end

  test "should update contratosperdotadicional" do
    patch contratosperdotadicional_url(@contratosperdotadicional), params: { contratosperdotadicional: { cantidad: @contratosperdotadicional.cantidad, contratosperdotacion_id: @contratosperdotadicional.contratosperdotacion_id, elemento: @contratosperdotadicional.elemento, user_id: @contratosperdotadicional.user_id } }
    assert_redirected_to contratosperdotadicional_url(@contratosperdotadicional)
  end

  test "should destroy contratosperdotadicional" do
    assert_difference('Contratosperdotadicional.count', -1) do
      delete contratosperdotadicional_url(@contratosperdotadicional)
    end

    assert_redirected_to contratosperdotadicionales_url
  end
end
