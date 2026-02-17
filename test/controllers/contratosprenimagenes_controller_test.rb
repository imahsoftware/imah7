require 'test_helper'

class ContratosprenimagenesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosprenimagen = contratosprenimagenes(:one)
  end

  test "should get index" do
    get contratosprenimagenes_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosprenimagen_url
    assert_response :success
  end

  test "should create contratosprenimagen" do
    assert_difference('Contratosprenimagen.count') do
      post contratosprenimagenes_url, params: { contratosprenimagen: { contrato_id: @contratosprenimagen.contrato_id, contratosgrupo_id: @contratosprenimagen.contratosgrupo_id, nominasimagen: @contratosprenimagen.nominasimagen, user_id: @contratosprenimagen.user_id } }
    end

    assert_redirected_to contratosprenimagen_url(Contratosprenimagen.last)
  end

  test "should show contratosprenimagen" do
    get contratosprenimagen_url(@contratosprenimagen)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosprenimagen_url(@contratosprenimagen)
    assert_response :success
  end

  test "should update contratosprenimagen" do
    patch contratosprenimagen_url(@contratosprenimagen), params: { contratosprenimagen: { contrato_id: @contratosprenimagen.contrato_id, contratosgrupo_id: @contratosprenimagen.contratosgrupo_id, nominasimagen: @contratosprenimagen.nominasimagen, user_id: @contratosprenimagen.user_id } }
    assert_redirected_to contratosprenimagen_url(@contratosprenimagen)
  end

  test "should destroy contratosprenimagen" do
    assert_difference('Contratosprenimagen.count', -1) do
      delete contratosprenimagen_url(@contratosprenimagen)
    end

    assert_redirected_to contratosprenimagenes_url
  end
end
