require 'test_helper'

class ContratospergruposControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratospergrupo = contratospergrupos(:one)
  end

  test "should get index" do
    get contratospergrupos_url
    assert_response :success
  end

  test "should get new" do
    get new_contratospergrupo_url
    assert_response :success
  end

  test "should create contratospergrupo" do
    assert_difference('Contratospergrupo.count') do
      post contratospergrupos_url, params: { contratospergrupo: { contratospersona_id: @contratospergrupo.contratospersona_id, identificacion: @contratospergrupo.identificacion, nombre: @contratospergrupo.nombre, parentesco: @contratospergrupo.parentesco, tipo_identificacion: @contratospergrupo.tipo_identificacion, user_act: @contratospergrupo.user_act, user_id: @contratospergrupo.user_id } }
    end

    assert_redirected_to contratospergrupo_url(Contratospergrupo.last)
  end

  test "should show contratospergrupo" do
    get contratospergrupo_url(@contratospergrupo)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratospergrupo_url(@contratospergrupo)
    assert_response :success
  end

  test "should update contratospergrupo" do
    patch contratospergrupo_url(@contratospergrupo), params: { contratospergrupo: { contratospersona_id: @contratospergrupo.contratospersona_id, identificacion: @contratospergrupo.identificacion, nombre: @contratospergrupo.nombre, parentesco: @contratospergrupo.parentesco, tipo_identificacion: @contratospergrupo.tipo_identificacion, user_act: @contratospergrupo.user_act, user_id: @contratospergrupo.user_id } }
    assert_redirected_to contratospergrupo_url(@contratospergrupo)
  end

  test "should destroy contratospergrupo" do
    assert_difference('Contratospergrupo.count', -1) do
      delete contratospergrupo_url(@contratospergrupo)
    end

    assert_redirected_to contratospergrupos_url
  end
end
