require 'test_helper'

class VeriserviciosiimagenesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @veriserviciosiimagen = veriserviciosiimagenes(:one)
  end

  test "should get index" do
    get veriserviciosiimagenes_url
    assert_response :success
  end

  test "should get new" do
    get new_veriserviciosiimagen_url
    assert_response :success
  end

  test "should create veriserviciosiimagen" do
    assert_difference('Veriserviciosiimagen.count') do
      post veriserviciosiimagenes_url, params: { veriserviciosiimagen: { descripcion: @veriserviciosiimagen.descripcion, user_id: @veriserviciosiimagen.user_id, veriimagen: @veriserviciosiimagen.veriimagen, veriserviciositem_id: @veriserviciosiimagen.veriserviciositem_id } }
    end

    assert_redirected_to veriserviciosiimagen_url(Veriserviciosiimagen.last)
  end

  test "should show veriserviciosiimagen" do
    get veriserviciosiimagen_url(@veriserviciosiimagen)
    assert_response :success
  end

  test "should get edit" do
    get edit_veriserviciosiimagen_url(@veriserviciosiimagen)
    assert_response :success
  end

  test "should update veriserviciosiimagen" do
    patch veriserviciosiimagen_url(@veriserviciosiimagen), params: { veriserviciosiimagen: { descripcion: @veriserviciosiimagen.descripcion, user_id: @veriserviciosiimagen.user_id, veriimagen: @veriserviciosiimagen.veriimagen, veriserviciositem_id: @veriserviciosiimagen.veriserviciositem_id } }
    assert_redirected_to veriserviciosiimagen_url(@veriserviciosiimagen)
  end

  test "should destroy veriserviciosiimagen" do
    assert_difference('Veriserviciosiimagen.count', -1) do
      delete veriserviciosiimagen_url(@veriserviciosiimagen)
    end

    assert_redirected_to veriserviciosiimagenes_url
  end
end
