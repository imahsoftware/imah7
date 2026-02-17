require 'test_helper'

class VeriserviciosagendasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @veriserviciosagenda = veriserviciosagendas(:one)
  end

  test "should get index" do
    get veriserviciosagendas_url
    assert_response :success
  end

  test "should get new" do
    get new_veriserviciosagenda_url
    assert_response :success
  end

  test "should create veriserviciosagenda" do
    assert_difference('Veriserviciosagenda.count') do
      post veriserviciosagendas_url, params: { veriserviciosagenda: { fecha_reprogramacion: @veriserviciosagenda.fecha_reprogramacion, nota: @veriserviciosagenda.nota, user_id: @veriserviciosagenda.user_id, veriservicio_id: @veriserviciosagenda.veriservicio_id } }
    end

    assert_redirected_to veriserviciosagenda_url(Veriserviciosagenda.last)
  end

  test "should show veriserviciosagenda" do
    get veriserviciosagenda_url(@veriserviciosagenda)
    assert_response :success
  end

  test "should get edit" do
    get edit_veriserviciosagenda_url(@veriserviciosagenda)
    assert_response :success
  end

  test "should update veriserviciosagenda" do
    patch veriserviciosagenda_url(@veriserviciosagenda), params: { veriserviciosagenda: { fecha_reprogramacion: @veriserviciosagenda.fecha_reprogramacion, nota: @veriserviciosagenda.nota, user_id: @veriserviciosagenda.user_id, veriservicio_id: @veriserviciosagenda.veriservicio_id } }
    assert_redirected_to veriserviciosagenda_url(@veriserviciosagenda)
  end

  test "should destroy veriserviciosagenda" do
    assert_difference('Veriserviciosagenda.count', -1) do
      delete veriserviciosagenda_url(@veriserviciosagenda)
    end

    assert_redirected_to veriserviciosagendas_url
  end
end
