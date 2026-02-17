require 'test_helper'

class ProveedoresimagenesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @proveedoresimagen = proveedoresimagenes(:one)
  end

  test "should get index" do
    get proveedoresimagenes_url
    assert_response :success
  end

  test "should get new" do
    get new_proveedoresimagen_url
    assert_response :success
  end

  test "should create proveedoresimagen" do
    assert_difference('Proveedoresimagen.count') do
      post proveedoresimagenes_url, params: { proveedoresimagen: { prodocumentos: @proveedoresimagen.prodocumentos, proveedor_id: @proveedoresimagen.proveedor_id, tiposimagen_id: @proveedoresimagen.tiposimagen_id, user_id: @proveedoresimagen.user_id } }
    end

    assert_redirected_to proveedoresimagen_url(Proveedoresimagen.last)
  end

  test "should show proveedoresimagen" do
    get proveedoresimagen_url(@proveedoresimagen)
    assert_response :success
  end

  test "should get edit" do
    get edit_proveedoresimagen_url(@proveedoresimagen)
    assert_response :success
  end

  test "should update proveedoresimagen" do
    patch proveedoresimagen_url(@proveedoresimagen), params: { proveedoresimagen: { prodocumentos: @proveedoresimagen.prodocumentos, proveedor_id: @proveedoresimagen.proveedor_id, tiposimagen_id: @proveedoresimagen.tiposimagen_id, user_id: @proveedoresimagen.user_id } }
    assert_redirected_to proveedoresimagen_url(@proveedoresimagen)
  end

  test "should destroy proveedoresimagen" do
    assert_difference('Proveedoresimagen.count', -1) do
      delete proveedoresimagen_url(@proveedoresimagen)
    end

    assert_redirected_to proveedoresimagenes_url
  end
end
