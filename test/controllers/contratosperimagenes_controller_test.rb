require 'test_helper'

class ContratosperimagenesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosperimagen = contratosperimagenes(:one)
  end

  test "should get index" do
    get contratosperimagenes_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosperimagen_url
    assert_response :success
  end

  test "should create contratosperimagen" do
    assert_difference('Contratosperimagen.count') do
      post contratosperimagenes_url, params: { contratosperimagen: { contratospersona_id: @contratosperimagen.contratospersona_id, personasimagen: @contratosperimagen.personasimagen, user_id: @contratosperimagen.user_id } }
    end

    assert_redirected_to contratosperimagen_url(Contratosperimagen.last)
  end

  test "should show contratosperimagen" do
    get contratosperimagen_url(@contratosperimagen)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosperimagen_url(@contratosperimagen)
    assert_response :success
  end

  test "should update contratosperimagen" do
    patch contratosperimagen_url(@contratosperimagen), params: { contratosperimagen: { contratospersona_id: @contratosperimagen.contratospersona_id, personasimagen: @contratosperimagen.personasimagen, user_id: @contratosperimagen.user_id } }
    assert_redirected_to contratosperimagen_url(@contratosperimagen)
  end

  test "should destroy contratosperimagen" do
    assert_difference('Contratosperimagen.count', -1) do
      delete contratosperimagen_url(@contratosperimagen)
    end

    assert_redirected_to contratosperimagenes_url
  end
end
