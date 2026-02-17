require 'test_helper'

class ContratospermasdetallesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratospermasdetalle = contratospermasdetalles(:one)
  end

  test "should get index" do
    get contratospermasdetalles_url
    assert_response :success
  end

  test "should get new" do
    get new_contratospermasdetalle_url
    assert_response :success
  end

  test "should create contratospermasdetalle" do
    assert_difference('Contratospermasdetalle.count') do
      post contratospermasdetalles_url, params: { contratospermasdetalle: { contratosperfecha_id: @contratospermasdetalle.contratosperfecha_id, contratospermasiva_id: @contratospermasdetalle.contratospermasiva_id } }
    end

    assert_redirected_to contratospermasdetalle_url(Contratospermasdetalle.last)
  end

  test "should show contratospermasdetalle" do
    get contratospermasdetalle_url(@contratospermasdetalle)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratospermasdetalle_url(@contratospermasdetalle)
    assert_response :success
  end

  test "should update contratospermasdetalle" do
    patch contratospermasdetalle_url(@contratospermasdetalle), params: { contratospermasdetalle: { contratosperfecha_id: @contratospermasdetalle.contratosperfecha_id, contratospermasiva_id: @contratospermasdetalle.contratospermasiva_id } }
    assert_redirected_to contratospermasdetalle_url(@contratospermasdetalle)
  end

  test "should destroy contratospermasdetalle" do
    assert_difference('Contratospermasdetalle.count', -1) do
      delete contratospermasdetalle_url(@contratospermasdetalle)
    end

    assert_redirected_to contratospermasdetalles_url
  end
end
