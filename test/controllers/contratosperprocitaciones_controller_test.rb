require 'test_helper'

class ContratosperprocitacionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosperprocitacion = contratosperprocitaciones(:one)
  end

  test "should get index" do
    get contratosperprocitaciones_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosperprocitacion_url
    assert_response :success
  end

  test "should create contratosperprocitacion" do
    assert_difference('Contratosperprocitacion.count') do
      post contratosperprocitaciones_url, params: { contratosperprocitacion: { contratosperproceso_id: @contratosperprocitacion.contratosperproceso_id, contratospersona_id: @contratosperprocitacion.contratospersona_id, estado: @contratosperprocitacion.estado, fecha: @contratosperprocitacion.fecha, lugar: @contratosperprocitacion.lugar, user_id: @contratosperprocitacion.user_id } }
    end

    assert_redirected_to contratosperprocitacion_url(Contratosperprocitacion.last)
  end

  test "should show contratosperprocitacion" do
    get contratosperprocitacion_url(@contratosperprocitacion)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosperprocitacion_url(@contratosperprocitacion)
    assert_response :success
  end

  test "should update contratosperprocitacion" do
    patch contratosperprocitacion_url(@contratosperprocitacion), params: { contratosperprocitacion: { contratosperproceso_id: @contratosperprocitacion.contratosperproceso_id, contratospersona_id: @contratosperprocitacion.contratospersona_id, estado: @contratosperprocitacion.estado, fecha: @contratosperprocitacion.fecha, lugar: @contratosperprocitacion.lugar, user_id: @contratosperprocitacion.user_id } }
    assert_redirected_to contratosperprocitacion_url(@contratosperprocitacion)
  end

  test "should destroy contratosperprocitacion" do
    assert_difference('Contratosperprocitacion.count', -1) do
      delete contratosperprocitacion_url(@contratosperprocitacion)
    end

    assert_redirected_to contratosperprocitaciones_url
  end
end
