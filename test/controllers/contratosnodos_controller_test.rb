require 'test_helper'

class ContratosnodosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosnodo = contratosnodos(:one)
  end

  test "should get index" do
    get contratosnodos_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosnodo_url
    assert_response :success
  end

  test "should create contratosnodo" do
    assert_difference('Contratosnodo.count') do
      post contratosnodos_url, params: { contratosnodo: { clase_aseo2: @contratosnodo.clase_aseo2, clase_aseo3: @contratosnodo.clase_aseo3, clase_aseo4: @contratosnodo.clase_aseo4, clase_aseo5: @contratosnodo.clase_aseo5, clase_aseo: @contratosnodo.clase_aseo, contrato_id: @contratosnodo.contrato_id, contratossede_id: @contratosnodo.contratossede_id, estado: @contratosnodo.estado, nombre: @contratosnodo.nombre, user_act: @contratosnodo.user_act, user_id: @contratosnodo.user_id } }
    end

    assert_redirected_to contratosnodo_url(Contratosnodo.last)
  end

  test "should show contratosnodo" do
    get contratosnodo_url(@contratosnodo)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosnodo_url(@contratosnodo)
    assert_response :success
  end

  test "should update contratosnodo" do
    patch contratosnodo_url(@contratosnodo), params: { contratosnodo: { clase_aseo2: @contratosnodo.clase_aseo2, clase_aseo3: @contratosnodo.clase_aseo3, clase_aseo4: @contratosnodo.clase_aseo4, clase_aseo5: @contratosnodo.clase_aseo5, clase_aseo: @contratosnodo.clase_aseo, contrato_id: @contratosnodo.contrato_id, contratossede_id: @contratosnodo.contratossede_id, estado: @contratosnodo.estado, nombre: @contratosnodo.nombre, user_act: @contratosnodo.user_act, user_id: @contratosnodo.user_id } }
    assert_redirected_to contratosnodo_url(@contratosnodo)
  end

  test "should destroy contratosnodo" do
    assert_difference('Contratosnodo.count', -1) do
      delete contratosnodo_url(@contratosnodo)
    end

    assert_redirected_to contratosnodos_url
  end
end
