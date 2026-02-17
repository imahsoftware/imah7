require 'test_helper'

class ContratosperlaborasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosperlabora = contratosperlaboras(:one)
  end

  test "should get index" do
    get contratosperlaboras_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosperlabora_url
    assert_response :success
  end

  test "should create contratosperlabora" do
    assert_difference('Contratosperlabora.count') do
      post contratosperlaboras_url, params: { contratosperlabora: { anno: @contratosperlabora.anno, contratosperfecha_id: @contratosperlabora.contratosperfecha_id, contratospersona_id: @contratosperlabora.contratospersona_id, labora: @contratosperlabora.labora, mes: @contratosperlabora.mes, user_asigna: @contratosperlabora.user_asigna } }
    end

    assert_redirected_to contratosperlabora_url(Contratosperlabora.last)
  end

  test "should show contratosperlabora" do
    get contratosperlabora_url(@contratosperlabora)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosperlabora_url(@contratosperlabora)
    assert_response :success
  end

  test "should update contratosperlabora" do
    patch contratosperlabora_url(@contratosperlabora), params: { contratosperlabora: { anno: @contratosperlabora.anno, contratosperfecha_id: @contratosperlabora.contratosperfecha_id, contratospersona_id: @contratosperlabora.contratospersona_id, labora: @contratosperlabora.labora, mes: @contratosperlabora.mes, user_asigna: @contratosperlabora.user_asigna } }
    assert_redirected_to contratosperlabora_url(@contratosperlabora)
  end

  test "should destroy contratosperlabora" do
    assert_difference('Contratosperlabora.count', -1) do
      delete contratosperlabora_url(@contratosperlabora)
    end

    assert_redirected_to contratosperlaboras_url
  end
end
