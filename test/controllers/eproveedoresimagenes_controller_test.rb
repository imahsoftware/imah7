require 'test_helper'

class EproveedoresimagenesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @eproveedoresimagen = eproveedoresimagenes(:one)
  end

  test "should get index" do
    get eproveedoresimagenes_url
    assert_response :success
  end

  test "should get new" do
    get new_eproveedoresimagen_url
    assert_response :success
  end

  test "should create eproveedoresimagen" do
    assert_difference('Eproveedoresimagen.count') do
      post eproveedoresimagenes_url, params: { eproveedoresimagen: { descripcion: @eproveedoresimagen.descripcion, eproveedor_id: @eproveedoresimagen.eproveedor_id, proveedor_content_type: @eproveedoresimagen.proveedor_content_type, proveedor_file_name: @eproveedoresimagen.proveedor_file_name, proveedor_file_size: @eproveedoresimagen.proveedor_file_size, proveedor_updated_at: @eproveedoresimagen.proveedor_updated_at, user_id: @eproveedoresimagen.user_id } }
    end

    assert_redirected_to eproveedoresimagen_url(Eproveedoresimagen.last)
  end

  test "should show eproveedoresimagen" do
    get eproveedoresimagen_url(@eproveedoresimagen)
    assert_response :success
  end

  test "should get edit" do
    get edit_eproveedoresimagen_url(@eproveedoresimagen)
    assert_response :success
  end

  test "should update eproveedoresimagen" do
    patch eproveedoresimagen_url(@eproveedoresimagen), params: { eproveedoresimagen: { descripcion: @eproveedoresimagen.descripcion, eproveedor_id: @eproveedoresimagen.eproveedor_id, proveedor_content_type: @eproveedoresimagen.proveedor_content_type, proveedor_file_name: @eproveedoresimagen.proveedor_file_name, proveedor_file_size: @eproveedoresimagen.proveedor_file_size, proveedor_updated_at: @eproveedoresimagen.proveedor_updated_at, user_id: @eproveedoresimagen.user_id } }
    assert_redirected_to eproveedoresimagen_url(@eproveedoresimagen)
  end

  test "should destroy eproveedoresimagen" do
    assert_difference('Eproveedoresimagen.count', -1) do
      delete eproveedoresimagen_url(@eproveedoresimagen)
    end

    assert_redirected_to eproveedoresimagenes_url
  end
end
