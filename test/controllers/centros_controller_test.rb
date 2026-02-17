require 'test_helper'

class CentrosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @centro = centros(:one)
  end

  test "should get index" do
    get centros_url
    assert_response :success
  end

  test "should get new" do
    get new_centro_url
    assert_response :success
  end

  test "should create centro" do
    assert_difference('Centro.count') do
      post centros_url, params: { centro: { codigo: @centro.codigo, descripcion: @centro.descripcion } }
    end

    assert_redirected_to centro_url(Centro.last)
  end

  test "should show centro" do
    get centro_url(@centro)
    assert_response :success
  end

  test "should get edit" do
    get edit_centro_url(@centro)
    assert_response :success
  end

  test "should update centro" do
    patch centro_url(@centro), params: { centro: { codigo: @centro.codigo, descripcion: @centro.descripcion } }
    assert_redirected_to centro_url(@centro)
  end

  test "should destroy centro" do
    assert_difference('Centro.count', -1) do
      delete centro_url(@centro)
    end

    assert_redirected_to centros_url
  end
end
