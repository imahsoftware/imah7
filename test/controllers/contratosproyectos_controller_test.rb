require 'test_helper'

class ContratosproyectosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosproyecto = contratosproyectos(:one)
  end

  test "should get index" do
    get contratosproyectos_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosproyecto_url
    assert_response :success
  end

  test "should create contratosproyecto" do
    assert_difference('Contratosproyecto.count') do
      post contratosproyectos_url, params: { contratosproyecto: { contrato_id: @contratosproyecto.contrato_id, descripcion: @contratosproyecto.descripcion, saldo: @contratosproyecto.saldo, usado: @contratosproyecto.usado, user_id: @contratosproyecto.user_id, valor: @contratosproyecto.valor } }
    end

    assert_redirected_to contratosproyecto_url(Contratosproyecto.last)
  end

  test "should show contratosproyecto" do
    get contratosproyecto_url(@contratosproyecto)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosproyecto_url(@contratosproyecto)
    assert_response :success
  end

  test "should update contratosproyecto" do
    patch contratosproyecto_url(@contratosproyecto), params: { contratosproyecto: { contrato_id: @contratosproyecto.contrato_id, descripcion: @contratosproyecto.descripcion, saldo: @contratosproyecto.saldo, usado: @contratosproyecto.usado, user_id: @contratosproyecto.user_id, valor: @contratosproyecto.valor } }
    assert_redirected_to contratosproyecto_url(@contratosproyecto)
  end

  test "should destroy contratosproyecto" do
    assert_difference('Contratosproyecto.count', -1) do
      delete contratosproyecto_url(@contratosproyecto)
    end

    assert_redirected_to contratosproyectos_url
  end
end
