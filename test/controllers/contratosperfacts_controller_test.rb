require 'test_helper'

class ContratosperfactsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosperfact = contratosperfacts(:one)
  end

  test "should get index" do
    get contratosperfacts_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosperfact_url
    assert_response :success
  end

  test "should create contratosperfact" do
    assert_difference('Contratosperfact.count') do
      post contratosperfacts_url, params: { contratosperfact: { contrato_id: @contratosperfact.contrato_id, contratoscargo_id: @contratosperfact.contratoscargo_id, contratosgrupo_id: @contratosperfact.contratosgrupo_id, contratosperfecha_id: @contratosperfact.contratosperfecha_id, contratospersona_id: @contratosperfact.contratospersona_id, estado: @contratosperfact.estado, oricontrato_id: @contratosperfact.oricontrato_id, oricontratoscargo_id: @contratosperfact.oricontratoscargo_id, oricontratosgrupo_id: @contratosperfact.oricontratosgrupo_id, user_id: @contratosperfact.user_id } }
    end

    assert_redirected_to contratosperfact_url(Contratosperfact.last)
  end

  test "should show contratosperfact" do
    get contratosperfact_url(@contratosperfact)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosperfact_url(@contratosperfact)
    assert_response :success
  end

  test "should update contratosperfact" do
    patch contratosperfact_url(@contratosperfact), params: { contratosperfact: { contrato_id: @contratosperfact.contrato_id, contratoscargo_id: @contratosperfact.contratoscargo_id, contratosgrupo_id: @contratosperfact.contratosgrupo_id, contratosperfecha_id: @contratosperfact.contratosperfecha_id, contratospersona_id: @contratosperfact.contratospersona_id, estado: @contratosperfact.estado, oricontrato_id: @contratosperfact.oricontrato_id, oricontratoscargo_id: @contratosperfact.oricontratoscargo_id, oricontratosgrupo_id: @contratosperfact.oricontratosgrupo_id, user_id: @contratosperfact.user_id } }
    assert_redirected_to contratosperfact_url(@contratosperfact)
  end

  test "should destroy contratosperfact" do
    assert_difference('Contratosperfact.count', -1) do
      delete contratosperfact_url(@contratosperfact)
    end

    assert_redirected_to contratosperfacts_url
  end
end
