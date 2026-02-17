require 'test_helper'

class ContratoscapacitacionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratoscapacitacion = contratoscapacitaciones(:one)
  end

  test "should get index" do
    get contratoscapacitaciones_url
    assert_response :success
  end

  test "should get new" do
    get new_contratoscapacitacion_url
    assert_response :success
  end

  test "should create contratoscapacitacion" do
    assert_difference('Contratoscapacitacion.count') do
      post contratoscapacitaciones_url, params: { contratoscapacitacion: { capacitacion_id: @contratoscapacitacion.capacitacion_id, contrato_id: @contratoscapacitacion.contrato_id, fecha_programacion: @contratoscapacitacion.fecha_programacion, fecha_real: @contratoscapacitacion.fecha_real, user_id: @contratoscapacitacion.user_id, user_supervisor: @contratoscapacitacion.user_supervisor } }
    end

    assert_redirected_to contratoscapacitacion_url(Contratoscapacitacion.last)
  end

  test "should show contratoscapacitacion" do
    get contratoscapacitacion_url(@contratoscapacitacion)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratoscapacitacion_url(@contratoscapacitacion)
    assert_response :success
  end

  test "should update contratoscapacitacion" do
    patch contratoscapacitacion_url(@contratoscapacitacion), params: { contratoscapacitacion: { capacitacion_id: @contratoscapacitacion.capacitacion_id, contrato_id: @contratoscapacitacion.contrato_id, fecha_programacion: @contratoscapacitacion.fecha_programacion, fecha_real: @contratoscapacitacion.fecha_real, user_id: @contratoscapacitacion.user_id, user_supervisor: @contratoscapacitacion.user_supervisor } }
    assert_redirected_to contratoscapacitacion_url(@contratoscapacitacion)
  end

  test "should destroy contratoscapacitacion" do
    assert_difference('Contratoscapacitacion.count', -1) do
      delete contratoscapacitacion_url(@contratoscapacitacion)
    end

    assert_redirected_to contratoscapacitaciones_url
  end
end
