require 'test_helper'

class TiposnaportesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tiposnaporte = tiposnaportes(:one)
  end

  test "should get index" do
    get tiposnaportes_url
    assert_response :success
  end

  test "should get new" do
    get new_tiposnaporte_url
    assert_response :success
  end

  test "should create tiposnaporte" do
    assert_difference('Tiposnaporte.count') do
      post tiposnaportes_url, params: { tiposnaporte: { descripcion: @tiposnaporte.descripcion, subtipo: @tiposnaporte.subtipo, tipo: @tiposnaporte.tipo } }
    end

    assert_redirected_to tiposnaporte_url(Tiposnaporte.last)
  end

  test "should show tiposnaporte" do
    get tiposnaporte_url(@tiposnaporte)
    assert_response :success
  end

  test "should get edit" do
    get edit_tiposnaporte_url(@tiposnaporte)
    assert_response :success
  end

  test "should update tiposnaporte" do
    patch tiposnaporte_url(@tiposnaporte), params: { tiposnaporte: { descripcion: @tiposnaporte.descripcion, subtipo: @tiposnaporte.subtipo, tipo: @tiposnaporte.tipo } }
    assert_redirected_to tiposnaporte_url(@tiposnaporte)
  end

  test "should destroy tiposnaporte" do
    assert_difference('Tiposnaporte.count', -1) do
      delete tiposnaporte_url(@tiposnaporte)
    end

    assert_redirected_to tiposnaportes_url
  end
end
