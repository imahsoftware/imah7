require 'test_helper'

class ContratosprefimagenesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosprefimagen = contratosprefimagenes(:one)
  end

  test "should get index" do
    get contratosprefimagenes_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosprefimagen_url
    assert_response :success
  end

  test "should create contratosprefimagen" do
    assert_difference('Contratosprefimagen.count') do
      post contratosprefimagenes_url, params: { contratosprefimagen: { contratosprefactura_id: @contratosprefimagen.contratosprefactura_id, descripcion: @contratosprefimagen.descripcion, facturasimagen: @contratosprefimagen.facturasimagen, user_id: @contratosprefimagen.user_id } }
    end

    assert_redirected_to contratosprefimagen_url(Contratosprefimagen.last)
  end

  test "should show contratosprefimagen" do
    get contratosprefimagen_url(@contratosprefimagen)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosprefimagen_url(@contratosprefimagen)
    assert_response :success
  end

  test "should update contratosprefimagen" do
    patch contratosprefimagen_url(@contratosprefimagen), params: { contratosprefimagen: { contratosprefactura_id: @contratosprefimagen.contratosprefactura_id, descripcion: @contratosprefimagen.descripcion, facturasimagen: @contratosprefimagen.facturasimagen, user_id: @contratosprefimagen.user_id } }
    assert_redirected_to contratosprefimagen_url(@contratosprefimagen)
  end

  test "should destroy contratosprefimagen" do
    assert_difference('Contratosprefimagen.count', -1) do
      delete contratosprefimagen_url(@contratosprefimagen)
    end

    assert_redirected_to contratosprefimagenes_url
  end
end
