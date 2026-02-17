require 'test_helper'

class ContratosperprestamosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosperprestamo = contratosperprestamos(:one)
  end

  test "should get index" do
    get contratosperprestamos_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosperprestamo_url
    assert_response :success
  end

  test "should create contratosperprestamo" do
    assert_difference('Contratosperprestamo.count') do
      post contratosperprestamos_url, params: { contratosperprestamo: { contratospersona_id: @contratosperprestamo.contratospersona_id, cuota: @contratosperprestamo.cuota, estado: @contratosperprestamo.estado, saldo: @contratosperprestamo.saldo, termino_descuento: @contratosperprestamo.termino_descuento, user_actualiza: @contratosperprestamo.user_actualiza, user_id: @contratosperprestamo.user_id, valor: @contratosperprestamo.valor } }
    end

    assert_redirected_to contratosperprestamo_url(Contratosperprestamo.last)
  end

  test "should show contratosperprestamo" do
    get contratosperprestamo_url(@contratosperprestamo)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosperprestamo_url(@contratosperprestamo)
    assert_response :success
  end

  test "should update contratosperprestamo" do
    patch contratosperprestamo_url(@contratosperprestamo), params: { contratosperprestamo: { contratospersona_id: @contratosperprestamo.contratospersona_id, cuota: @contratosperprestamo.cuota, estado: @contratosperprestamo.estado, saldo: @contratosperprestamo.saldo, termino_descuento: @contratosperprestamo.termino_descuento, user_actualiza: @contratosperprestamo.user_actualiza, user_id: @contratosperprestamo.user_id, valor: @contratosperprestamo.valor } }
    assert_redirected_to contratosperprestamo_url(@contratosperprestamo)
  end

  test "should destroy contratosperprestamo" do
    assert_difference('Contratosperprestamo.count', -1) do
      delete contratosperprestamo_url(@contratosperprestamo)
    end

    assert_redirected_to contratosperprestamos_url
  end
end
