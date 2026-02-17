require 'test_helper'

class ContratossoldetallesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratossoldetalle = contratossoldetalles(:one)
  end

  test "should get index" do
    get contratossoldetalles_url
    assert_response :success
  end

  test "should get new" do
    get new_contratossoldetalle_url
    assert_response :success
  end

  test "should create contratossoldetalle" do
    assert_difference('Contratossoldetalle.count') do
      post contratossoldetalles_url, params: { contratossoldetalle: { cantidad: @contratossoldetalle.cantidad, cantidad_real: @contratossoldetalle.cantidad_real, contratosinsumo_id: @contratossoldetalle.contratosinsumo_id, contratosmaquinaria_id: @contratossoldetalle.contratosmaquinaria_id, contratosotro_id: @contratossoldetalle.contratosotro_id, contratossolicitud_id: @contratossoldetalle.contratossolicitud_id, insumo_id: @contratossoldetalle.insumo_id, precio_unitario: @contratossoldetalle.precio_unitario, total: @contratossoldetalle.total, user_act: @contratossoldetalle.user_act, user_id: @contratossoldetalle.user_id } }
    end

    assert_redirected_to contratossoldetalle_url(Contratossoldetalle.last)
  end

  test "should show contratossoldetalle" do
    get contratossoldetalle_url(@contratossoldetalle)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratossoldetalle_url(@contratossoldetalle)
    assert_response :success
  end

  test "should update contratossoldetalle" do
    patch contratossoldetalle_url(@contratossoldetalle), params: { contratossoldetalle: { cantidad: @contratossoldetalle.cantidad, cantidad_real: @contratossoldetalle.cantidad_real, contratosinsumo_id: @contratossoldetalle.contratosinsumo_id, contratosmaquinaria_id: @contratossoldetalle.contratosmaquinaria_id, contratosotro_id: @contratossoldetalle.contratosotro_id, contratossolicitud_id: @contratossoldetalle.contratossolicitud_id, insumo_id: @contratossoldetalle.insumo_id, precio_unitario: @contratossoldetalle.precio_unitario, total: @contratossoldetalle.total, user_act: @contratossoldetalle.user_act, user_id: @contratossoldetalle.user_id } }
    assert_redirected_to contratossoldetalle_url(@contratossoldetalle)
  end

  test "should destroy contratossoldetalle" do
    assert_difference('Contratossoldetalle.count', -1) do
      delete contratossoldetalle_url(@contratossoldetalle)
    end

    assert_redirected_to contratossoldetalles_url
  end
end
