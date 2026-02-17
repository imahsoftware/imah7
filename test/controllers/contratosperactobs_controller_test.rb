require 'test_helper'

class ContratosperactobsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosperactob = contratosperactobs(:one)
  end

  test "should get index" do
    get contratosperactobs_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosperactob_url
    assert_response :success
  end

  test "should create contratosperactob" do
    assert_difference('Contratosperactob.count') do
      post contratosperactobs_url, params: { contratosperactob: { anno: @contratosperactob.anno, contratoscargo_id: @contratosperactob.contratoscargo_id, contratosperfecha_id: @contratosperactob.contratosperfecha_id, contratospersona_id: @contratosperactob.contratospersona_id, mes: @contratosperactob.mes, resultado: @contratosperactob.resultado, user_interventor: @contratosperactob.user_interventor } }
    end

    assert_redirected_to contratosperactob_url(Contratosperactob.last)
  end

  test "should show contratosperactob" do
    get contratosperactob_url(@contratosperactob)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosperactob_url(@contratosperactob)
    assert_response :success
  end

  test "should update contratosperactob" do
    patch contratosperactob_url(@contratosperactob), params: { contratosperactob: { anno: @contratosperactob.anno, contratoscargo_id: @contratosperactob.contratoscargo_id, contratosperfecha_id: @contratosperactob.contratosperfecha_id, contratospersona_id: @contratosperactob.contratospersona_id, mes: @contratosperactob.mes, resultado: @contratosperactob.resultado, user_interventor: @contratosperactob.user_interventor } }
    assert_redirected_to contratosperactob_url(@contratosperactob)
  end

  test "should destroy contratosperactob" do
    assert_difference('Contratosperactob.count', -1) do
      delete contratosperactob_url(@contratosperactob)
    end

    assert_redirected_to contratosperactobs_url
  end
end
