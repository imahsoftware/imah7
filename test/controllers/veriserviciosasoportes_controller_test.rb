require 'test_helper'

class VeriserviciosasoportesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @veriserviciosasoporte = veriserviciosasoportes(:one)
  end

  test "should get index" do
    get veriserviciosasoportes_url
    assert_response :success
  end

  test "should get new" do
    get new_veriserviciosasoporte_url
    assert_response :success
  end

  test "should create veriserviciosasoporte" do
    assert_difference('Veriserviciosasoporte.count') do
      post veriserviciosasoportes_url, params: { veriserviciosasoporte: { descripcion: @veriserviciosasoporte.descripcion, user_id: @veriserviciosasoporte.user_id, veriserviciosagenda_id: @veriserviciosasoporte.veriserviciosagenda_id, verisoporte: @veriserviciosasoporte.verisoporte } }
    end

    assert_redirected_to veriserviciosasoporte_url(Veriserviciosasoporte.last)
  end

  test "should show veriserviciosasoporte" do
    get veriserviciosasoporte_url(@veriserviciosasoporte)
    assert_response :success
  end

  test "should get edit" do
    get edit_veriserviciosasoporte_url(@veriserviciosasoporte)
    assert_response :success
  end

  test "should update veriserviciosasoporte" do
    patch veriserviciosasoporte_url(@veriserviciosasoporte), params: { veriserviciosasoporte: { descripcion: @veriserviciosasoporte.descripcion, user_id: @veriserviciosasoporte.user_id, veriserviciosagenda_id: @veriserviciosasoporte.veriserviciosagenda_id, verisoporte: @veriserviciosasoporte.verisoporte } }
    assert_redirected_to veriserviciosasoporte_url(@veriserviciosasoporte)
  end

  test "should destroy veriserviciosasoporte" do
    assert_difference('Veriserviciosasoporte.count', -1) do
      delete veriserviciosasoporte_url(@veriserviciosasoporte)
    end

    assert_redirected_to veriserviciosasoportes_url
  end
end
