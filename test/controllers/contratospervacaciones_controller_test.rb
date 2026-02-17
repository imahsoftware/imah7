require 'test_helper'

class ContratospervacacionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratospervacacion = contratospervacaciones(:one)
  end

  test "should get index" do
    get contratospervacaciones_url
    assert_response :success
  end

  test "should get new" do
    get new_contratospervacacion_url
    assert_response :success
  end

  test "should create contratospervacacion" do
    assert_difference('Contratospervacacion.count') do
      post contratospervacaciones_url, params: { contratospervacacion: { contratosperfecha_id: @contratospervacacion.contratosperfecha_id, contratospersona_id: @contratospervacacion.contratospersona_id, dias_disfrute: @contratospervacacion.dias_disfrute, dias_pago: @contratospervacacion.dias_pago, estado: @contratospervacacion.estado, fecha_fin: @contratospervacacion.fecha_fin, fecha_inicio: @contratospervacacion.fecha_inicio, user_aprueba: @contratospervacacion.user_aprueba, user_id: @contratospervacacion.user_id, user_paga: @contratospervacacion.user_paga, valor_disfrute: @contratospervacacion.valor_disfrute, valor_pago: @contratospervacacion.valor_pago, valor_pension: @contratospervacacion.valor_pension, valor_salud: @contratospervacacion.valor_salud, valor_total: @contratospervacacion.valor_total } }
    end

    assert_redirected_to contratospervacacion_url(Contratospervacacion.last)
  end

  test "should show contratospervacacion" do
    get contratospervacacion_url(@contratospervacacion)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratospervacacion_url(@contratospervacacion)
    assert_response :success
  end

  test "should update contratospervacacion" do
    patch contratospervacacion_url(@contratospervacacion), params: { contratospervacacion: { contratosperfecha_id: @contratospervacacion.contratosperfecha_id, contratospersona_id: @contratospervacacion.contratospersona_id, dias_disfrute: @contratospervacacion.dias_disfrute, dias_pago: @contratospervacacion.dias_pago, estado: @contratospervacacion.estado, fecha_fin: @contratospervacacion.fecha_fin, fecha_inicio: @contratospervacacion.fecha_inicio, user_aprueba: @contratospervacacion.user_aprueba, user_id: @contratospervacacion.user_id, user_paga: @contratospervacacion.user_paga, valor_disfrute: @contratospervacacion.valor_disfrute, valor_pago: @contratospervacacion.valor_pago, valor_pension: @contratospervacacion.valor_pension, valor_salud: @contratospervacacion.valor_salud, valor_total: @contratospervacacion.valor_total } }
    assert_redirected_to contratospervacacion_url(@contratospervacacion)
  end

  test "should destroy contratospervacacion" do
    assert_difference('Contratospervacacion.count', -1) do
      delete contratospervacacion_url(@contratospervacacion)
    end

    assert_redirected_to contratospervacaciones_url
  end
end
