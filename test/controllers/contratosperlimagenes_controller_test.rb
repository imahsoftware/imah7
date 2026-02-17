require 'test_helper'

class ContratosperlimagenesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosperlimagen = contratosperlimagenes(:one)
  end

  test "should get index" do
    get contratosperlimagenes_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosperlimagen_url
    assert_response :success
  end

  test "should create contratosperlimagen" do
    assert_difference('Contratosperlimagen.count') do
      post contratosperlimagenes_url, params: { contratosperlimagen: { contratosperfecha_id: @contratosperlimagen.contratosperfecha_id, liquidacionesimagen: @contratosperlimagen.liquidacionesimagen } }
    end

    assert_redirected_to contratosperlimagen_url(Contratosperlimagen.last)
  end

  test "should show contratosperlimagen" do
    get contratosperlimagen_url(@contratosperlimagen)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosperlimagen_url(@contratosperlimagen)
    assert_response :success
  end

  test "should update contratosperlimagen" do
    patch contratosperlimagen_url(@contratosperlimagen), params: { contratosperlimagen: { contratosperfecha_id: @contratosperlimagen.contratosperfecha_id, liquidacionesimagen: @contratosperlimagen.liquidacionesimagen } }
    assert_redirected_to contratosperlimagen_url(@contratosperlimagen)
  end

  test "should destroy contratosperlimagen" do
    assert_difference('Contratosperlimagen.count', -1) do
      delete contratosperlimagen_url(@contratosperlimagen)
    end

    assert_redirected_to contratosperlimagenes_url
  end
end
