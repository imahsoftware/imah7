require 'test_helper'

class ContratosperprocesosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosperproceso = contratosperprocesos(:one)
  end

  test "should get index" do
    get contratosperprocesos_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosperproceso_url
    assert_response :success
  end

  test "should create contratosperproceso" do
    assert_difference('Contratosperproceso.count') do
      post contratosperprocesos_url, params: { contratosperproceso: { clase: @contratosperproceso.clase, contratosperfecha_id: @contratosperproceso.contratosperfecha_id, contratospersona_id: @contratosperproceso.contratospersona_id, detalle: @contratosperproceso.detalle, estado: @contratosperproceso.estado, fecha: @contratosperproceso.fecha, user_id: @contratosperproceso.user_id, user_testigo1: @contratosperproceso.user_testigo1, user_testigo2: @contratosperproceso.user_testigo2 } }
    end

    assert_redirected_to contratosperproceso_url(Contratosperproceso.last)
  end

  test "should show contratosperproceso" do
    get contratosperproceso_url(@contratosperproceso)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosperproceso_url(@contratosperproceso)
    assert_response :success
  end

  test "should update contratosperproceso" do
    patch contratosperproceso_url(@contratosperproceso), params: { contratosperproceso: { clase: @contratosperproceso.clase, contratosperfecha_id: @contratosperproceso.contratosperfecha_id, contratospersona_id: @contratosperproceso.contratospersona_id, detalle: @contratosperproceso.detalle, estado: @contratosperproceso.estado, fecha: @contratosperproceso.fecha, user_id: @contratosperproceso.user_id, user_testigo1: @contratosperproceso.user_testigo1, user_testigo2: @contratosperproceso.user_testigo2 } }
    assert_redirected_to contratosperproceso_url(@contratosperproceso)
  end

  test "should destroy contratosperproceso" do
    assert_difference('Contratosperproceso.count', -1) do
      delete contratosperproceso_url(@contratosperproceso)
    end

    assert_redirected_to contratosperprocesos_url
  end
end
