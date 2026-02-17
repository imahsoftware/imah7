require 'test_helper'

class ContratosotrosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosotro = contratosotros(:one)
  end

  test "should get index" do
    get contratosotros_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosotro_url
    assert_response :success
  end

  test "should create contratosotro" do
    assert_difference('Contratosotro.count') do
      post contratosotros_url, params: { contratosotro: { cantidad_mensual: @contratosotro.cantidad_mensual, contrato_id: @contratosotro.contrato_id, descripcion: @contratosotro.descripcion, descuento: @contratosotro.descuento, precio_condescuento: @contratosotro.precio_condescuento, precio_unitario: @contratosotro.precio_unitario, total: @contratosotro.total, user_act: @contratosotro.user_act, user_id: @contratosotro.user_id } }
    end

    assert_redirected_to contratosotro_url(Contratosotro.last)
  end

  test "should show contratosotro" do
    get contratosotro_url(@contratosotro)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosotro_url(@contratosotro)
    assert_response :success
  end

  test "should update contratosotro" do
    patch contratosotro_url(@contratosotro), params: { contratosotro: { cantidad_mensual: @contratosotro.cantidad_mensual, contrato_id: @contratosotro.contrato_id, descripcion: @contratosotro.descripcion, descuento: @contratosotro.descuento, precio_condescuento: @contratosotro.precio_condescuento, precio_unitario: @contratosotro.precio_unitario, total: @contratosotro.total, user_act: @contratosotro.user_act, user_id: @contratosotro.user_id } }
    assert_redirected_to contratosotro_url(@contratosotro)
  end

  test "should destroy contratosotro" do
    assert_difference('Contratosotro.count', -1) do
      delete contratosotro_url(@contratosotro)
    end

    assert_redirected_to contratosotros_url
  end
end
