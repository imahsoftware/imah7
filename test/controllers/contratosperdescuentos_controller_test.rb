require 'test_helper'

class ContratosperdescuentosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosperdescuento = contratosperdescuentos(:one)
  end

  test "should get index" do
    get contratosperdescuentos_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosperdescuento_url
    assert_response :success
  end

  test "should create contratosperdescuento" do
    assert_difference('Contratosperdescuento.count') do
      post contratosperdescuentos_url, params: { contratosperdescuento: { contratospersona_id: @contratosperdescuento.contratospersona_id, estado: @contratosperdescuento.estado, termino_descuento: @contratosperdescuento.termino_descuento, user_actualiza: @contratosperdescuento.user_actualiza, user_id: @contratosperdescuento.user_id, valor: @contratosperdescuento.valor } }
    end

    assert_redirected_to contratosperdescuento_url(Contratosperdescuento.last)
  end

  test "should show contratosperdescuento" do
    get contratosperdescuento_url(@contratosperdescuento)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosperdescuento_url(@contratosperdescuento)
    assert_response :success
  end

  test "should update contratosperdescuento" do
    patch contratosperdescuento_url(@contratosperdescuento), params: { contratosperdescuento: { contratospersona_id: @contratosperdescuento.contratospersona_id, estado: @contratosperdescuento.estado, termino_descuento: @contratosperdescuento.termino_descuento, user_actualiza: @contratosperdescuento.user_actualiza, user_id: @contratosperdescuento.user_id, valor: @contratosperdescuento.valor } }
    assert_redirected_to contratosperdescuento_url(@contratosperdescuento)
  end

  test "should destroy contratosperdescuento" do
    assert_difference('Contratosperdescuento.count', -1) do
      delete contratosperdescuento_url(@contratosperdescuento)
    end

    assert_redirected_to contratosperdescuentos_url
  end
end
