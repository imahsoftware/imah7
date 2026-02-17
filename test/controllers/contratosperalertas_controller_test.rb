require 'test_helper'

class ContratosperalertasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosperalerta = contratosperalertas(:one)
  end

  test "should get index" do
    get contratosperalertas_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosperalerta_url
    assert_response :success
  end

  test "should create contratosperalerta" do
    assert_difference('Contratosperalerta.count') do
      post contratosperalertas_url, params: { contratosperalerta: { contratospersona_id: @contratosperalerta.contratospersona_id, estado: @contratosperalerta.estado, fecha: @contratosperalerta.fecha, observacion: @contratosperalerta.observacion, user_id: @contratosperalerta.user_id } }
    end

    assert_redirected_to contratosperalerta_url(Contratosperalerta.last)
  end

  test "should show contratosperalerta" do
    get contratosperalerta_url(@contratosperalerta)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosperalerta_url(@contratosperalerta)
    assert_response :success
  end

  test "should update contratosperalerta" do
    patch contratosperalerta_url(@contratosperalerta), params: { contratosperalerta: { contratospersona_id: @contratosperalerta.contratospersona_id, estado: @contratosperalerta.estado, fecha: @contratosperalerta.fecha, observacion: @contratosperalerta.observacion, user_id: @contratosperalerta.user_id } }
    assert_redirected_to contratosperalerta_url(@contratosperalerta)
  end

  test "should destroy contratosperalerta" do
    assert_difference('Contratosperalerta.count', -1) do
      delete contratosperalerta_url(@contratosperalerta)
    end

    assert_redirected_to contratosperalertas_url
  end
end
