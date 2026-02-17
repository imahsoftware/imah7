require 'test_helper'

class ContratosserviciosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosservicio = contratosservicios(:one)
  end

  test "should get index" do
    get contratosservicios_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosservicio_url
    assert_response :success
  end

  test "should create contratosservicio" do
    assert_difference('Contratosservicio.count') do
      post contratosservicios_url, params: { contratosservicio: { contrato_id: @contratosservicio.contrato_id, servicio: @contratosservicio.servicio, user_id: @contratosservicio.user_id } }
    end

    assert_redirected_to contratosservicio_url(Contratosservicio.last)
  end

  test "should show contratosservicio" do
    get contratosservicio_url(@contratosservicio)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosservicio_url(@contratosservicio)
    assert_response :success
  end

  test "should update contratosservicio" do
    patch contratosservicio_url(@contratosservicio), params: { contratosservicio: { contrato_id: @contratosservicio.contrato_id, servicio: @contratosservicio.servicio, user_id: @contratosservicio.user_id } }
    assert_redirected_to contratosservicio_url(@contratosservicio)
  end

  test "should destroy contratosservicio" do
    assert_difference('Contratosservicio.count', -1) do
      delete contratosservicio_url(@contratosservicio)
    end

    assert_redirected_to contratosservicios_url
  end
end
