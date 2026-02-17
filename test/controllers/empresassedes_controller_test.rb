require 'test_helper'

class EmpresassedesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @empresassede = empresassedes(:one)
  end

  test "should get index" do
    get empresassedes_url
    assert_response :success
  end

  test "should get new" do
    get new_empresassede_url
    assert_response :success
  end

  test "should create empresassede" do
    assert_difference('Empresassede.count') do
      post empresassedes_url, params: { empresassede: { dircampo1: @empresassede.dircampo1, dircampo2: @empresassede.dircampo2, dircampo3: @empresassede.dircampo3, dircampo4: @empresassede.dircampo4, dircampo5: @empresassede.dircampo5, dircampo6: @empresassede.dircampo6, dircampo7: @empresassede.dircampo7, dircampo8: @empresassede.dircampo8, dircampo9: @empresassede.dircampo9, direccion: @empresassede.direccion, empresa_id: @empresassede.empresa_id, municipio_id: @empresassede.municipio_id, nombre: @empresassede.nombre, user_act: @empresassede.user_act, user_id: @empresassede.user_id } }
    end

    assert_redirected_to empresassede_url(Empresassede.last)
  end

  test "should show empresassede" do
    get empresassede_url(@empresassede)
    assert_response :success
  end

  test "should get edit" do
    get edit_empresassede_url(@empresassede)
    assert_response :success
  end

  test "should update empresassede" do
    patch empresassede_url(@empresassede), params: { empresassede: { dircampo1: @empresassede.dircampo1, dircampo2: @empresassede.dircampo2, dircampo3: @empresassede.dircampo3, dircampo4: @empresassede.dircampo4, dircampo5: @empresassede.dircampo5, dircampo6: @empresassede.dircampo6, dircampo7: @empresassede.dircampo7, dircampo8: @empresassede.dircampo8, dircampo9: @empresassede.dircampo9, direccion: @empresassede.direccion, empresa_id: @empresassede.empresa_id, municipio_id: @empresassede.municipio_id, nombre: @empresassede.nombre, user_act: @empresassede.user_act, user_id: @empresassede.user_id } }
    assert_redirected_to empresassede_url(@empresassede)
  end

  test "should destroy empresassede" do
    assert_difference('Empresassede.count', -1) do
      delete empresassede_url(@empresassede)
    end

    assert_redirected_to empresassedes_url
  end
end
