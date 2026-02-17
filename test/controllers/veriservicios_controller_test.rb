require 'test_helper'

class VeriserviciosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @veriservicio = veriservicios(:one)
  end

  test "should get index" do
    get veriservicios_url
    assert_response :success
  end

  test "should get new" do
    get new_veriservicio_url
    assert_response :success
  end

  test "should create veriservicio" do
    assert_difference('Veriservicio.count') do
      post veriservicios_url, params: { veriservicio: { cal_cumplimiento: @veriservicio.cal_cumplimiento, cal_personal: @veriservicio.cal_personal, cal_servicio: @veriservicio.cal_servicio, contrato_id: @veriservicio.contrato_id, estado: @veriservicio.estado, fecha: @veriservicio.fecha, fecha_final: @veriservicio.fecha_final, objetivo: @veriservicio.objetivo, resultado: @veriservicio.resultado, user_id: @veriservicio.user_id } }
    end

    assert_redirected_to veriservicio_url(Veriservicio.last)
  end

  test "should show veriservicio" do
    get veriservicio_url(@veriservicio)
    assert_response :success
  end

  test "should get edit" do
    get edit_veriservicio_url(@veriservicio)
    assert_response :success
  end

  test "should update veriservicio" do
    patch veriservicio_url(@veriservicio), params: { veriservicio: { cal_cumplimiento: @veriservicio.cal_cumplimiento, cal_personal: @veriservicio.cal_personal, cal_servicio: @veriservicio.cal_servicio, contrato_id: @veriservicio.contrato_id, estado: @veriservicio.estado, fecha: @veriservicio.fecha, fecha_final: @veriservicio.fecha_final, objetivo: @veriservicio.objetivo, resultado: @veriservicio.resultado, user_id: @veriservicio.user_id } }
    assert_redirected_to veriservicio_url(@veriservicio)
  end

  test "should destroy veriservicio" do
    assert_difference('Veriservicio.count', -1) do
      delete veriservicio_url(@veriservicio)
    end

    assert_redirected_to veriservicios_url
  end
end
