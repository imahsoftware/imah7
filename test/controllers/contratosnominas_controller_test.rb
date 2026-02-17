require 'test_helper'

class ContratosnominasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosnomina = contratosnominas(:one)
  end

  test "should get index" do
    get contratosnominas_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosnomina_url
    assert_response :success
  end

  test "should create contratosnomina" do
    assert_difference('Contratosnomina.count') do
      post contratosnominas_url, params: { contratosnomina: { consecutivo: @contratosnomina.consecutivo, contratosgrupo_id: @contratosnomina.contratosgrupo_id, contratospersona_id: @contratosnomina.contratospersona_id, estado: @contratosnomina.estado, periodosliquidacion_id: @contratosnomina.periodosliquidacion_id, user_id: @contratosnomina.user_id } }
    end

    assert_redirected_to contratosnomina_url(Contratosnomina.last)
  end

  test "should show contratosnomina" do
    get contratosnomina_url(@contratosnomina)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosnomina_url(@contratosnomina)
    assert_response :success
  end

  test "should update contratosnomina" do
    patch contratosnomina_url(@contratosnomina), params: { contratosnomina: { consecutivo: @contratosnomina.consecutivo, contratosgrupo_id: @contratosnomina.contratosgrupo_id, contratospersona_id: @contratosnomina.contratospersona_id, estado: @contratosnomina.estado, periodosliquidacion_id: @contratosnomina.periodosliquidacion_id, user_id: @contratosnomina.user_id } }
    assert_redirected_to contratosnomina_url(@contratosnomina)
  end

  test "should destroy contratosnomina" do
    assert_difference('Contratosnomina.count', -1) do
      delete contratosnomina_url(@contratosnomina)
    end

    assert_redirected_to contratosnominas_url
  end
end
