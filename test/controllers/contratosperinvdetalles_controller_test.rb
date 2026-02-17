require 'test_helper'

class ContratosperinvdetallesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosperinvdetalle = contratosperinvdetalles(:one)
  end

  test "should get index" do
    get contratosperinvdetalles_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosperinvdetalle_url
    assert_response :success
  end

  test "should create contratosperinvdetalle" do
    assert_difference('Contratosperinvdetalle.count') do
      post contratosperinvdetalles_url, params: { contratosperinvdetalle: { contratrosperinventario_id: @contratosperinvdetalle.contratrosperinventario_id, estado_item: @contratosperinvdetalle.estado_item, item: @contratosperinvdetalle.item, nro_placa: @contratosperinvdetalle.nro_placa, observaciones: @contratosperinvdetalle.observaciones } }
    end

    assert_redirected_to contratosperinvdetalle_url(Contratosperinvdetalle.last)
  end

  test "should show contratosperinvdetalle" do
    get contratosperinvdetalle_url(@contratosperinvdetalle)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosperinvdetalle_url(@contratosperinvdetalle)
    assert_response :success
  end

  test "should update contratosperinvdetalle" do
    patch contratosperinvdetalle_url(@contratosperinvdetalle), params: { contratosperinvdetalle: { contratrosperinventario_id: @contratosperinvdetalle.contratrosperinventario_id, estado_item: @contratosperinvdetalle.estado_item, item: @contratosperinvdetalle.item, nro_placa: @contratosperinvdetalle.nro_placa, observaciones: @contratosperinvdetalle.observaciones } }
    assert_redirected_to contratosperinvdetalle_url(@contratosperinvdetalle)
  end

  test "should destroy contratosperinvdetalle" do
    assert_difference('Contratosperinvdetalle.count', -1) do
      delete contratosperinvdetalle_url(@contratosperinvdetalle)
    end

    assert_redirected_to contratosperinvdetalles_url
  end
end
