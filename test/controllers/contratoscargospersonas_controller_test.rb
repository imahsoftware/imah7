require 'test_helper'

class ContratoscargospersonasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratoscargospersona = contratoscargospersonas(:one)
  end

  test "should get index" do
    get contratoscargospersonas_url
    assert_response :success
  end

  test "should get new" do
    get new_contratoscargospersona_url
    assert_response :success
  end

  test "should create contratoscargospersona" do
    assert_difference('Contratoscargospersona.count') do
      post contratoscargospersonas_url, params: { contratoscargospersona: { cargoimagen: @contratoscargospersona.cargoimagen, contratoscargo_id: @contratoscargospersona.contratoscargo_id, identificacion: @contratoscargospersona.identificacion, nombre: @contratoscargospersona.nombre, observacion: @contratoscargospersona.observacion, user_id: @contratoscargospersona.user_id } }
    end

    assert_redirected_to contratoscargospersona_url(Contratoscargospersona.last)
  end

  test "should show contratoscargospersona" do
    get contratoscargospersona_url(@contratoscargospersona)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratoscargospersona_url(@contratoscargospersona)
    assert_response :success
  end

  test "should update contratoscargospersona" do
    patch contratoscargospersona_url(@contratoscargospersona), params: { contratoscargospersona: { cargoimagen: @contratoscargospersona.cargoimagen, contratoscargo_id: @contratoscargospersona.contratoscargo_id, identificacion: @contratoscargospersona.identificacion, nombre: @contratoscargospersona.nombre, observacion: @contratoscargospersona.observacion, user_id: @contratoscargospersona.user_id } }
    assert_redirected_to contratoscargospersona_url(@contratoscargospersona)
  end

  test "should destroy contratoscargospersona" do
    assert_difference('Contratoscargospersona.count', -1) do
      delete contratoscargospersona_url(@contratoscargospersona)
    end

    assert_redirected_to contratoscargospersonas_url
  end
end
