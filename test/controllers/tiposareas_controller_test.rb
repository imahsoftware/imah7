require 'test_helper'

class TiposareasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tiposarea = tiposareas(:one)
  end

  test "should get index" do
    get tiposareas_url
    assert_response :success
  end

  test "should get new" do
    get new_tiposarea_url
    assert_response :success
  end

  test "should create tiposarea" do
    assert_difference('Tiposarea.count') do
      post tiposareas_url, params: { tiposarea: { descripcion: @tiposarea.descripcion } }
    end

    assert_redirected_to tiposarea_url(Tiposarea.last)
  end

  test "should show tiposarea" do
    get tiposarea_url(@tiposarea)
    assert_response :success
  end

  test "should get edit" do
    get edit_tiposarea_url(@tiposarea)
    assert_response :success
  end

  test "should update tiposarea" do
    patch tiposarea_url(@tiposarea), params: { tiposarea: { descripcion: @tiposarea.descripcion } }
    assert_redirected_to tiposarea_url(@tiposarea)
  end

  test "should destroy tiposarea" do
    assert_difference('Tiposarea.count', -1) do
      delete tiposarea_url(@tiposarea)
    end

    assert_redirected_to tiposareas_url
  end
end
