require 'test_helper'

class TiposimagenesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tiposimagen = tiposimagenes(:one)
  end

  test "should get index" do
    get tiposimagenes_url
    assert_response :success
  end

  test "should get new" do
    get new_tiposimagen_url
    assert_response :success
  end

  test "should create tiposimagen" do
    assert_difference('Tiposimagen.count') do
      post tiposimagenes_url, params: { tiposimagen: { descripcion: @tiposimagen.descripcion } }
    end

    assert_redirected_to tiposimagen_url(Tiposimagen.last)
  end

  test "should show tiposimagen" do
    get tiposimagen_url(@tiposimagen)
    assert_response :success
  end

  test "should get edit" do
    get edit_tiposimagen_url(@tiposimagen)
    assert_response :success
  end

  test "should update tiposimagen" do
    patch tiposimagen_url(@tiposimagen), params: { tiposimagen: { descripcion: @tiposimagen.descripcion } }
    assert_redirected_to tiposimagen_url(@tiposimagen)
  end

  test "should destroy tiposimagen" do
    assert_difference('Tiposimagen.count', -1) do
      delete tiposimagen_url(@tiposimagen)
    end

    assert_redirected_to tiposimagenes_url
  end
end
