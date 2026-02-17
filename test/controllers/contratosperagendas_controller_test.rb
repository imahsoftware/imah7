require 'test_helper'

class ContratosperagendasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosperagenda = contratosperagendas(:one)
  end

  test "should get index" do
    get contratosperagendas_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosperagenda_url
    assert_response :success
  end

  test "should create contratosperagenda" do
    assert_difference('Contratosperagenda.count') do
      post contratosperagendas_url, params: { contratosperagenda: { contratospersona_id: @contratosperagenda.contratospersona_id, fecha: @contratosperagenda.fecha, hora: @contratosperagenda.hora, user_id: @contratosperagenda.user_id } }
    end

    assert_redirected_to contratosperagenda_url(Contratosperagenda.last)
  end

  test "should show contratosperagenda" do
    get contratosperagenda_url(@contratosperagenda)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosperagenda_url(@contratosperagenda)
    assert_response :success
  end

  test "should update contratosperagenda" do
    patch contratosperagenda_url(@contratosperagenda), params: { contratosperagenda: { contratospersona_id: @contratosperagenda.contratospersona_id, fecha: @contratosperagenda.fecha, hora: @contratosperagenda.hora, user_id: @contratosperagenda.user_id } }
    assert_redirected_to contratosperagenda_url(@contratosperagenda)
  end

  test "should destroy contratosperagenda" do
    assert_difference('Contratosperagenda.count', -1) do
      delete contratosperagenda_url(@contratosperagenda)
    end

    assert_redirected_to contratosperagendas_url
  end
end
