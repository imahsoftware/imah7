require 'test_helper'

class InsumosfichasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @insumosficha = insumosfichas(:one)
  end

  test "should get index" do
    get insumosfichas_url
    assert_response :success
  end

  test "should get new" do
    get new_insumosficha_url
    assert_response :success
  end

  test "should create insumosficha" do
    assert_difference('Insumosficha.count') do
      post insumosfichas_url, params: { insumosficha: { docficha: @insumosficha.docficha, estado: @insumosficha.estado, insumo_id: @insumosficha.insumo_id, marca: @insumosficha.marca, referencia: @insumosficha.referencia, user_id: @insumosficha.user_id } }
    end

    assert_redirected_to insumosficha_url(Insumosficha.last)
  end

  test "should show insumosficha" do
    get insumosficha_url(@insumosficha)
    assert_response :success
  end

  test "should get edit" do
    get edit_insumosficha_url(@insumosficha)
    assert_response :success
  end

  test "should update insumosficha" do
    patch insumosficha_url(@insumosficha), params: { insumosficha: { docficha: @insumosficha.docficha, estado: @insumosficha.estado, insumo_id: @insumosficha.insumo_id, marca: @insumosficha.marca, referencia: @insumosficha.referencia, user_id: @insumosficha.user_id } }
    assert_redirected_to insumosficha_url(@insumosficha)
  end

  test "should destroy insumosficha" do
    assert_difference('Insumosficha.count', -1) do
      delete insumosficha_url(@insumosficha)
    end

    assert_redirected_to insumosfichas_url
  end
end
