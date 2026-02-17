require 'test_helper'

class FechasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fecha = fechas(:one)
  end

  test "should get index" do
    get fechas_url
    assert_response :success
  end

  test "should get new" do
    get new_fecha_url
    assert_response :success
  end

  test "should create fecha" do
    assert_difference('Fecha.count') do
      post fechas_url, params: { fecha: { fecha: @fecha.fecha } }
    end

    assert_redirected_to fecha_url(Fecha.last)
  end

  test "should show fecha" do
    get fecha_url(@fecha)
    assert_response :success
  end

  test "should get edit" do
    get edit_fecha_url(@fecha)
    assert_response :success
  end

  test "should update fecha" do
    patch fecha_url(@fecha), params: { fecha: { fecha: @fecha.fecha } }
    assert_redirected_to fecha_url(@fecha)
  end

  test "should destroy fecha" do
    assert_difference('Fecha.count', -1) do
      delete fecha_url(@fecha)
    end

    assert_redirected_to fechas_url
  end
end
