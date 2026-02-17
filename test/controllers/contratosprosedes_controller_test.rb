require 'test_helper'

class ContratosprosedesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosprosede = contratosprosedes(:one)
  end

  test "should get index" do
    get contratosprosedes_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosprosede_url
    assert_response :success
  end

  test "should create contratosprosede" do
    assert_difference('Contratosprosede.count') do
      post contratosprosedes_url, params: { contratosprosede: { contratosproyecto_id: @contratosprosede.contratosproyecto_id, contratossede_id: @contratosprosede.contratossede_id, user_id: @contratosprosede.user_id } }
    end

    assert_redirected_to contratosprosede_url(Contratosprosede.last)
  end

  test "should show contratosprosede" do
    get contratosprosede_url(@contratosprosede)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosprosede_url(@contratosprosede)
    assert_response :success
  end

  test "should update contratosprosede" do
    patch contratosprosede_url(@contratosprosede), params: { contratosprosede: { contratosproyecto_id: @contratosprosede.contratosproyecto_id, contratossede_id: @contratosprosede.contratossede_id, user_id: @contratosprosede.user_id } }
    assert_redirected_to contratosprosede_url(@contratosprosede)
  end

  test "should destroy contratosprosede" do
    assert_difference('Contratosprosede.count', -1) do
      delete contratosprosede_url(@contratosprosede)
    end

    assert_redirected_to contratosprosedes_url
  end
end
