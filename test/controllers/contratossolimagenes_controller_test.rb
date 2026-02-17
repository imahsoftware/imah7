require 'test_helper'

class ContratossolimagenesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratossolimagen = contratossolimagenes(:one)
  end

  test "should get index" do
    get contratossolimagenes_url
    assert_response :success
  end

  test "should get new" do
    get new_contratossolimagen_url
    assert_response :success
  end

  test "should create contratossolimagen" do
    assert_difference('Contratossolimagen.count') do
      post contratossolimagenes_url, params: { contratossolimagen: { contratossolicitud_id: @contratossolimagen.contratossolicitud_id, descripcion: @contratossolimagen.descripcion, solimagenes: @contratossolimagen.solimagenes, user_id: @contratossolimagen.user_id } }
    end

    assert_redirected_to contratossolimagen_url(Contratossolimagen.last)
  end

  test "should show contratossolimagen" do
    get contratossolimagen_url(@contratossolimagen)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratossolimagen_url(@contratossolimagen)
    assert_response :success
  end

  test "should update contratossolimagen" do
    patch contratossolimagen_url(@contratossolimagen), params: { contratossolimagen: { contratossolicitud_id: @contratossolimagen.contratossolicitud_id, descripcion: @contratossolimagen.descripcion, solimagenes: @contratossolimagen.solimagenes, user_id: @contratossolimagen.user_id } }
    assert_redirected_to contratossolimagen_url(@contratossolimagen)
  end

  test "should destroy contratossolimagen" do
    assert_difference('Contratossolimagen.count', -1) do
      delete contratossolimagen_url(@contratossolimagen)
    end

    assert_redirected_to contratossolimagenes_url
  end
end
