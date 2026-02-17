require 'test_helper'

class ContratosperdotacionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosperdotacion = contratosperdotaciones(:one)
  end

  test "should get index" do
    get contratosperdotaciones_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosperdotacion_url
    assert_response :success
  end

  test "should create contratosperdotacion" do
    assert_difference('Contratosperdotacion.count') do
      post contratosperdotaciones_url, params: { contratosperdotacion: { cant_camisa: @contratosperdotacion.cant_camisa, cant_pantalon: @contratosperdotacion.cant_pantalon, cant_zapatos: @contratosperdotacion.cant_zapatos, contrato_id: @contratosperdotacion.contrato_id, contratosperfecha_id: @contratosperdotacion.contratosperfecha_id, contratospersona_id: @contratosperdotacion.contratospersona_id, estado: @contratosperdotacion.estado, fecha_prox_entrega: @contratosperdotacion.fecha_prox_entrega, observacion: @contratosperdotacion.observacion, talla_camisa: @contratosperdotacion.talla_camisa, talla_pantalon: @contratosperdotacion.talla_pantalon, talla_zapatos: @contratosperdotacion.talla_zapatos, user_estado: @contratosperdotacion.user_estado, zapatos: @contratosperdotacion.zapatos } }
    end

    assert_redirected_to contratosperdotacion_url(Contratosperdotacion.last)
  end

  test "should show contratosperdotacion" do
    get contratosperdotacion_url(@contratosperdotacion)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosperdotacion_url(@contratosperdotacion)
    assert_response :success
  end

  test "should update contratosperdotacion" do
    patch contratosperdotacion_url(@contratosperdotacion), params: { contratosperdotacion: { cant_camisa: @contratosperdotacion.cant_camisa, cant_pantalon: @contratosperdotacion.cant_pantalon, cant_zapatos: @contratosperdotacion.cant_zapatos, contrato_id: @contratosperdotacion.contrato_id, contratosperfecha_id: @contratosperdotacion.contratosperfecha_id, contratospersona_id: @contratosperdotacion.contratospersona_id, estado: @contratosperdotacion.estado, fecha_prox_entrega: @contratosperdotacion.fecha_prox_entrega, observacion: @contratosperdotacion.observacion, talla_camisa: @contratosperdotacion.talla_camisa, talla_pantalon: @contratosperdotacion.talla_pantalon, talla_zapatos: @contratosperdotacion.talla_zapatos, user_estado: @contratosperdotacion.user_estado, zapatos: @contratosperdotacion.zapatos } }
    assert_redirected_to contratosperdotacion_url(@contratosperdotacion)
  end

  test "should destroy contratosperdotacion" do
    assert_difference('Contratosperdotacion.count', -1) do
      delete contratosperdotacion_url(@contratosperdotacion)
    end

    assert_redirected_to contratosperdotaciones_url
  end
end
