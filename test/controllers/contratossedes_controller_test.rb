require 'test_helper'

class ContratossedesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratossede = contratossedes(:one)
  end

  test "should get index" do
    get contratossedes_url
    assert_response :success
  end

  test "should get new" do
    get new_contratossede_url
    assert_response :success
  end

  test "should create contratossede" do
    assert_difference('Contratossede.count') do
      post contratossedes_url, params: { contratossede: { contrato_id: @contratossede.contrato_id, empresassede_id: @contratossede.empresassede_id, user_act: @contratossede.user_act, user_id: @contratossede.user_id } }
    end

    assert_redirected_to contratossede_url(Contratossede.last)
  end

  test "should show contratossede" do
    get contratossede_url(@contratossede)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratossede_url(@contratossede)
    assert_response :success
  end

  test "should update contratossede" do
    patch contratossede_url(@contratossede), params: { contratossede: { contrato_id: @contratossede.contrato_id, empresassede_id: @contratossede.empresassede_id, user_act: @contratossede.user_act, user_id: @contratossede.user_id } }
    assert_redirected_to contratossede_url(@contratossede)
  end

  test "should destroy contratossede" do
    assert_difference('Contratossede.count', -1) do
      delete contratossede_url(@contratossede)
    end

    assert_redirected_to contratossedes_url
  end
end
