require 'test_helper'

class ContratospernovimagenesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratospernovimagen = contratospernovimagenes(:one)
  end

  test "should get index" do
    get contratospernovimagenes_url
    assert_response :success
  end

  test "should get new" do
    get new_contratospernovimagen_url
    assert_response :success
  end

  test "should create contratospernovimagen" do
    assert_difference('Contratospernovimagen.count') do
      post contratospernovimagenes_url, params: { contratospernovimagen: { contratospernovedad_id: @contratospernovimagen.contratospernovedad_id, novedadimagen: @contratospernovimagen.novedadimagen, user_id: @contratospernovimagen.user_id } }
    end

    assert_redirected_to contratospernovimagen_url(Contratospernovimagen.last)
  end

  test "should show contratospernovimagen" do
    get contratospernovimagen_url(@contratospernovimagen)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratospernovimagen_url(@contratospernovimagen)
    assert_response :success
  end

  test "should update contratospernovimagen" do
    patch contratospernovimagen_url(@contratospernovimagen), params: { contratospernovimagen: { contratospernovedad_id: @contratospernovimagen.contratospernovedad_id, novedadimagen: @contratospernovimagen.novedadimagen, user_id: @contratospernovimagen.user_id } }
    assert_redirected_to contratospernovimagen_url(@contratospernovimagen)
  end

  test "should destroy contratospernovimagen" do
    assert_difference('Contratospernovimagen.count', -1) do
      delete contratospernovimagen_url(@contratospernovimagen)
    end

    assert_redirected_to contratospernovimagenes_url
  end
end
