require 'test_helper'

class SoportesnotasimagenesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @soportesnotasimagen = soportesnotasimagenes(:one)
  end

  test "should get index" do
    get soportesnotasimagenes_url
    assert_response :success
  end

  test "should get new" do
    get new_soportesnotasimagen_url
    assert_response :success
  end

  test "should create soportesnotasimagen" do
    assert_difference('Soportesnotasimagen.count') do
      post soportesnotasimagenes_url, params: { soportesnotasimagen: { descripcion: @soportesnotasimagen.descripcion, docsoportesnota: @soportesnotasimagen.docsoportesnota, soportesnota_id: @soportesnotasimagen.soportesnota_id, user_id: @soportesnotasimagen.user_id } }
    end

    assert_redirected_to soportesnotasimagen_url(Soportesnotasimagen.last)
  end

  test "should show soportesnotasimagen" do
    get soportesnotasimagen_url(@soportesnotasimagen)
    assert_response :success
  end

  test "should get edit" do
    get edit_soportesnotasimagen_url(@soportesnotasimagen)
    assert_response :success
  end

  test "should update soportesnotasimagen" do
    patch soportesnotasimagen_url(@soportesnotasimagen), params: { soportesnotasimagen: { descripcion: @soportesnotasimagen.descripcion, docsoportesnota: @soportesnotasimagen.docsoportesnota, soportesnota_id: @soportesnotasimagen.soportesnota_id, user_id: @soportesnotasimagen.user_id } }
    assert_redirected_to soportesnotasimagen_url(@soportesnotasimagen)
  end

  test "should destroy soportesnotasimagen" do
    assert_difference('Soportesnotasimagen.count', -1) do
      delete soportesnotasimagen_url(@soportesnotasimagen)
    end

    assert_redirected_to soportesnotasimagenes_url
  end
end
