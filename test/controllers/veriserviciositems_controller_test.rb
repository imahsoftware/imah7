require 'test_helper'

class VeriserviciositemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @veriserviciositem = veriserviciositems(:one)
  end

  test "should get index" do
    get veriserviciositems_url
    assert_response :success
  end

  test "should get new" do
    get new_veriserviciositem_url
    assert_response :success
  end

  test "should create veriserviciositem" do
    assert_difference('Veriserviciositem.count') do
      post veriserviciositems_url, params: { veriserviciositem: { calificacion: @veriserviciositem.calificacion, clasificacion: @veriserviciositem.clasificacion, orden: @veriserviciositem.orden, veriservicio_id: @veriserviciositem.veriservicio_id } }
    end

    assert_redirected_to veriserviciositem_url(Veriserviciositem.last)
  end

  test "should show veriserviciositem" do
    get veriserviciositem_url(@veriserviciositem)
    assert_response :success
  end

  test "should get edit" do
    get edit_veriserviciositem_url(@veriserviciositem)
    assert_response :success
  end

  test "should update veriserviciositem" do
    patch veriserviciositem_url(@veriserviciositem), params: { veriserviciositem: { calificacion: @veriserviciositem.calificacion, clasificacion: @veriserviciositem.clasificacion, orden: @veriserviciositem.orden, veriservicio_id: @veriserviciositem.veriservicio_id } }
    assert_redirected_to veriserviciositem_url(@veriserviciositem)
  end

  test "should destroy veriserviciositem" do
    assert_difference('Veriserviciositem.count', -1) do
      delete veriserviciositem_url(@veriserviciositem)
    end

    assert_redirected_to veriserviciositems_url
  end
end
