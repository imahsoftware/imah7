require 'test_helper'

class CentroscostosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @centroscosto = centroscostos(:one)
  end

  test "should get index" do
    get centroscostos_url
    assert_response :success
  end

  test "should get new" do
    get new_centroscosto_url
    assert_response :success
  end

  test "should create centroscosto" do
    assert_difference('Centroscosto.count') do
      post centroscostos_url, params: { centroscosto: { codigo: @centroscosto.codigo, descripcion: @centroscosto.descripcion, user_id: @centroscosto.user_id } }
    end

    assert_redirected_to centroscosto_url(Centroscosto.last)
  end

  test "should show centroscosto" do
    get centroscosto_url(@centroscosto)
    assert_response :success
  end

  test "should get edit" do
    get edit_centroscosto_url(@centroscosto)
    assert_response :success
  end

  test "should update centroscosto" do
    patch centroscosto_url(@centroscosto), params: { centroscosto: { codigo: @centroscosto.codigo, descripcion: @centroscosto.descripcion, user_id: @centroscosto.user_id } }
    assert_redirected_to centroscosto_url(@centroscosto)
  end

  test "should destroy centroscosto" do
    assert_difference('Centroscosto.count', -1) do
      delete centroscosto_url(@centroscosto)
    end

    assert_redirected_to centroscostos_url
  end
end
