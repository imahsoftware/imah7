require 'test_helper'

class ContratossoleppsdetallesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratossoleppsdetalle = contratossoleppsdetalles(:one)
  end

  test "should get index" do
    get contratossoleppsdetalles_url
    assert_response :success
  end

  test "should get new" do
    get new_contratossoleppsdetalle_url
    assert_response :success
  end

  test "should create contratossoleppsdetalle" do
    assert_difference('Contratossoleppsdetalle.count') do
      post contratossoleppsdetalles_url, params: { contratossoleppsdetalle: { cant_aprobada: @contratossoleppsdetalle.cant_aprobada, cantidad: @contratossoleppsdetalle.cantidad, contratossolepp_id: @contratossoleppsdetalle.contratossolepp_id, item: @contratossoleppsdetalle.item, observacion: @contratossoleppsdetalle.observacion } }
    end

    assert_redirected_to contratossoleppsdetalle_url(Contratossoleppsdetalle.last)
  end

  test "should show contratossoleppsdetalle" do
    get contratossoleppsdetalle_url(@contratossoleppsdetalle)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratossoleppsdetalle_url(@contratossoleppsdetalle)
    assert_response :success
  end

  test "should update contratossoleppsdetalle" do
    patch contratossoleppsdetalle_url(@contratossoleppsdetalle), params: { contratossoleppsdetalle: { cant_aprobada: @contratossoleppsdetalle.cant_aprobada, cantidad: @contratossoleppsdetalle.cantidad, contratossolepp_id: @contratossoleppsdetalle.contratossolepp_id, item: @contratossoleppsdetalle.item, observacion: @contratossoleppsdetalle.observacion } }
    assert_redirected_to contratossoleppsdetalle_url(@contratossoleppsdetalle)
  end

  test "should destroy contratossoleppsdetalle" do
    assert_difference('Contratossoleppsdetalle.count', -1) do
      delete contratossoleppsdetalle_url(@contratossoleppsdetalle)
    end

    assert_redirected_to contratossoleppsdetalles_url
  end
end
