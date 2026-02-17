require 'test_helper'

class TiposcargosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tiposcargo = tiposcargos(:one)
  end

  test "should get index" do
    get tiposcargos_url
    assert_response :success
  end

  test "should get new" do
    get new_tiposcargo_url
    assert_response :success
  end

  test "should create tiposcargo" do
    assert_difference('Tiposcargo.count') do
      post tiposcargos_url, params: { tiposcargo: { descripcion: @tiposcargo.descripcion, perfil: @tiposcargo.perfil } }
    end

    assert_redirected_to tiposcargo_url(Tiposcargo.last)
  end

  test "should show tiposcargo" do
    get tiposcargo_url(@tiposcargo)
    assert_response :success
  end

  test "should get edit" do
    get edit_tiposcargo_url(@tiposcargo)
    assert_response :success
  end

  test "should update tiposcargo" do
    patch tiposcargo_url(@tiposcargo), params: { tiposcargo: { descripcion: @tiposcargo.descripcion, perfil: @tiposcargo.perfil } }
    assert_redirected_to tiposcargo_url(@tiposcargo)
  end

  test "should destroy tiposcargo" do
    assert_difference('Tiposcargo.count', -1) do
      delete tiposcargo_url(@tiposcargo)
    end

    assert_redirected_to tiposcargos_url
  end
end
