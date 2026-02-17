require 'test_helper'

class IparametrosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @iparametro = iparametros(:one)
  end

  test "should get index" do
    get iparametros_url
    assert_response :success
  end

  test "should get new" do
    get new_iparametro_url
    assert_response :success
  end

  test "should create iparametro" do
    assert_difference('Iparametro.count') do
      post iparametros_url, params: { iparametro: { campo: @iparametro.campo, descripcion: @iparametro.descripcion, estado: @iparametro.estado } }
    end

    assert_redirected_to iparametro_url(Iparametro.last)
  end

  test "should show iparametro" do
    get iparametro_url(@iparametro)
    assert_response :success
  end

  test "should get edit" do
    get edit_iparametro_url(@iparametro)
    assert_response :success
  end

  test "should update iparametro" do
    patch iparametro_url(@iparametro), params: { iparametro: { campo: @iparametro.campo, descripcion: @iparametro.descripcion, estado: @iparametro.estado } }
    assert_redirected_to iparametro_url(@iparametro)
  end

  test "should destroy iparametro" do
    assert_difference('Iparametro.count', -1) do
      delete iparametro_url(@iparametro)
    end

    assert_redirected_to iparametros_url
  end
end
