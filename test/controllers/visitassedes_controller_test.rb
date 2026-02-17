require 'test_helper'

class VisitassedesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @visitassede = visitassedes(:one)
  end

  test "should get index" do
    get visitassedes_url
    assert_response :success
  end

  test "should get new" do
    get new_visitassede_url
    assert_response :success
  end

  test "should create visitassede" do
    assert_difference('Visitassede.count') do
      post visitassedes_url, params: { visitassede: { contratossede_id: @visitassede.contratossede_id, user_id: @visitassede.user_id, visita_id: @visitassede.visita_id } }
    end

    assert_redirected_to visitassede_url(Visitassede.last)
  end

  test "should show visitassede" do
    get visitassede_url(@visitassede)
    assert_response :success
  end

  test "should get edit" do
    get edit_visitassede_url(@visitassede)
    assert_response :success
  end

  test "should update visitassede" do
    patch visitassede_url(@visitassede), params: { visitassede: { contratossede_id: @visitassede.contratossede_id, user_id: @visitassede.user_id, visita_id: @visitassede.visita_id } }
    assert_redirected_to visitassede_url(@visitassede)
  end

  test "should destroy visitassede" do
    assert_difference('Visitassede.count', -1) do
      delete visitassede_url(@visitassede)
    end

    assert_redirected_to visitassedes_url
  end
end
