require 'test_helper'

class ContratossoleppscontrolesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratossoleppscontrol = contratossoleppscontroles(:one)
  end

  test "should get index" do
    get contratossoleppscontroles_url
    assert_response :success
  end

  test "should get new" do
    get new_contratossoleppscontrol_url
    assert_response :success
  end

  test "should create contratossoleppscontrol" do
    assert_difference('Contratossoleppscontrol.count') do
      post contratossoleppscontroles_url, params: { contratossoleppscontrol: { cantidad_aprobada: @contratossoleppscontrol.cantidad_aprobada, cantidad_restante: @contratossoleppscontrol.cantidad_restante, item: @contratossoleppscontrol.item } }
    end

    assert_redirected_to contratossoleppscontrol_url(Contratossoleppscontrol.last)
  end

  test "should show contratossoleppscontrol" do
    get contratossoleppscontrol_url(@contratossoleppscontrol)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratossoleppscontrol_url(@contratossoleppscontrol)
    assert_response :success
  end

  test "should update contratossoleppscontrol" do
    patch contratossoleppscontrol_url(@contratossoleppscontrol), params: { contratossoleppscontrol: { cantidad_aprobada: @contratossoleppscontrol.cantidad_aprobada, cantidad_restante: @contratossoleppscontrol.cantidad_restante, item: @contratossoleppscontrol.item } }
    assert_redirected_to contratossoleppscontrol_url(@contratossoleppscontrol)
  end

  test "should destroy contratossoleppscontrol" do
    assert_difference('Contratossoleppscontrol.count', -1) do
      delete contratossoleppscontrol_url(@contratossoleppscontrol)
    end

    assert_redirected_to contratossoleppscontroles_url
  end
end
