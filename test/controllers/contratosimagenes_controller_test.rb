require 'test_helper'

class ContratosimagenesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosimagen = contratosimagenes(:one)
  end

  test "should get index" do
    get contratosimagenes_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosimagen_url
    assert_response :success
  end

  test "should create contratosimagen" do
    assert_difference('Contratosimagen.count') do
      post contratosimagenes_url, params: { contratosimagen: { contrato_id: @contratosimagen.contrato_id, imagen: @contratosimagen.imagen, tiposimagen_id: @contratosimagen.tiposimagen_id, user_id: @contratosimagen.user_id } }
    end

    assert_redirected_to contratosimagen_url(Contratosimagen.last)
  end

  test "should show contratosimagen" do
    get contratosimagen_url(@contratosimagen)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosimagen_url(@contratosimagen)
    assert_response :success
  end

  test "should update contratosimagen" do
    patch contratosimagen_url(@contratosimagen), params: { contratosimagen: { contrato_id: @contratosimagen.contrato_id, imagen: @contratosimagen.imagen, tiposimagen_id: @contratosimagen.tiposimagen_id, user_id: @contratosimagen.user_id } }
    assert_redirected_to contratosimagen_url(@contratosimagen)
  end

  test "should destroy contratosimagen" do
    assert_difference('Contratosimagen.count', -1) do
      delete contratosimagen_url(@contratosimagen)
    end

    assert_redirected_to contratosimagenes_url
  end
end
