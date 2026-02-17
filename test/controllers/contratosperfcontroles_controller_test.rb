require 'test_helper'

class ContratosperfcontrolesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosperfcontrol = contratosperfcontroles(:one)
  end

  test "should get index" do
    get contratosperfcontroles_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosperfcontrol_url
    assert_response :success
  end

  test "should create contratosperfcontrol" do
    assert_difference('Contratosperfcontrol.count') do
      post contratosperfcontroles_url, params: { contratosperfcontrol: { contratosperfecha_id: @contratosperfcontrol.contratosperfecha_id, contratospervacacion_id: @contratosperfcontrol.contratospervacacion_id, estado: @contratosperfcontrol.estado, fecha: @contratosperfcontrol.fecha } }
    end

    assert_redirected_to contratosperfcontrol_url(Contratosperfcontrol.last)
  end

  test "should show contratosperfcontrol" do
    get contratosperfcontrol_url(@contratosperfcontrol)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosperfcontrol_url(@contratosperfcontrol)
    assert_response :success
  end

  test "should update contratosperfcontrol" do
    patch contratosperfcontrol_url(@contratosperfcontrol), params: { contratosperfcontrol: { contratosperfecha_id: @contratosperfcontrol.contratosperfecha_id, contratospervacacion_id: @contratosperfcontrol.contratospervacacion_id, estado: @contratosperfcontrol.estado, fecha: @contratosperfcontrol.fecha } }
    assert_redirected_to contratosperfcontrol_url(@contratosperfcontrol)
  end

  test "should destroy contratosperfcontrol" do
    assert_difference('Contratosperfcontrol.count', -1) do
      delete contratosperfcontrol_url(@contratosperfcontrol)
    end

    assert_redirected_to contratosperfcontroles_url
  end
end
