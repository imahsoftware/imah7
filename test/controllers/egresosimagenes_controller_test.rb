require 'test_helper'

class EgresosimagenesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @egresosimagen = egresosimagenes(:one)
  end

  test "should get index" do
    get egresosimagenes_url
    assert_response :success
  end

  test "should get new" do
    get new_egresosimagen_url
    assert_response :success
  end

  test "should create egresosimagen" do
    assert_difference('Egresosimagen.count') do
      post egresosimagenes_url, params: { egresosimagen: { egreso_id: @egresosimagen.egreso_id, egresoimagen: @egresosimagen.egresoimagen, user_id: @egresosimagen.user_id } }
    end

    assert_redirected_to egresosimagen_url(Egresosimagen.last)
  end

  test "should show egresosimagen" do
    get egresosimagen_url(@egresosimagen)
    assert_response :success
  end

  test "should get edit" do
    get edit_egresosimagen_url(@egresosimagen)
    assert_response :success
  end

  test "should update egresosimagen" do
    patch egresosimagen_url(@egresosimagen), params: { egresosimagen: { egreso_id: @egresosimagen.egreso_id, egresoimagen: @egresosimagen.egresoimagen, user_id: @egresosimagen.user_id } }
    assert_redirected_to egresosimagen_url(@egresosimagen)
  end

  test "should destroy egresosimagen" do
    assert_difference('Egresosimagen.count', -1) do
      delete egresosimagen_url(@egresosimagen)
    end

    assert_redirected_to egresosimagenes_url
  end
end
