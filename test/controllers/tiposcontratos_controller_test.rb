require 'test_helper'

class TiposcontratosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tiposcontrato = tiposcontratos(:one)
  end

  test "should get index" do
    get tiposcontratos_url
    assert_response :success
  end

  test "should get new" do
    get new_tiposcontrato_url
    assert_response :success
  end

  test "should create tiposcontrato" do
    assert_difference('Tiposcontrato.count') do
      post tiposcontratos_url, params: { tiposcontrato: { descripcion: @tiposcontrato.descripcion } }
    end

    assert_redirected_to tiposcontrato_url(Tiposcontrato.last)
  end

  test "should show tiposcontrato" do
    get tiposcontrato_url(@tiposcontrato)
    assert_response :success
  end

  test "should get edit" do
    get edit_tiposcontrato_url(@tiposcontrato)
    assert_response :success
  end

  test "should update tiposcontrato" do
    patch tiposcontrato_url(@tiposcontrato), params: { tiposcontrato: { descripcion: @tiposcontrato.descripcion } }
    assert_redirected_to tiposcontrato_url(@tiposcontrato)
  end

  test "should destroy tiposcontrato" do
    assert_difference('Tiposcontrato.count', -1) do
      delete tiposcontrato_url(@tiposcontrato)
    end

    assert_redirected_to tiposcontratos_url
  end
end
