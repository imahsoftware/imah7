require 'test_helper'

class ContratosinsimagenesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosinsimagen = contratosinsimagenes(:one)
  end

  test "should get index" do
    get contratosinsimagenes_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosinsimagen_url
    assert_response :success
  end

  test "should create contratosinsimagen" do
    assert_difference('Contratosinsimagen.count') do
      post contratosinsimagenes_url, params: { contratosinsimagen: { contratosinsumo_id: @contratosinsimagen.contratosinsumo_id, insumosimagen: @contratosinsimagen.insumosimagen, user_id: @contratosinsimagen.user_id } }
    end

    assert_redirected_to contratosinsimagen_url(Contratosinsimagen.last)
  end

  test "should show contratosinsimagen" do
    get contratosinsimagen_url(@contratosinsimagen)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosinsimagen_url(@contratosinsimagen)
    assert_response :success
  end

  test "should update contratosinsimagen" do
    patch contratosinsimagen_url(@contratosinsimagen), params: { contratosinsimagen: { contratosinsumo_id: @contratosinsimagen.contratosinsumo_id, insumosimagen: @contratosinsimagen.insumosimagen, user_id: @contratosinsimagen.user_id } }
    assert_redirected_to contratosinsimagen_url(@contratosinsimagen)
  end

  test "should destroy contratosinsimagen" do
    assert_difference('Contratosinsimagen.count', -1) do
      delete contratosinsimagen_url(@contratosinsimagen)
    end

    assert_redirected_to contratosinsimagenes_url
  end
end
