require 'test_helper'

class VisitashallazgosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @visitashallazgo = visitashallazgos(:one)
  end

  test "should get index" do
    get visitashallazgos_url
    assert_response :success
  end

  test "should get new" do
    get new_visitashallazgo_url
    assert_response :success
  end

  test "should create visitashallazgo" do
    assert_difference('Visitashallazgo.count') do
      post visitashallazgos_url, params: { visitashallazgo: { docvisitashallazgo: @visitashallazgo.docvisitashallazgo, tipo: @visitashallazgo.tipo, user_id: @visitashallazgo.user_id, visita_id: @visitashallazgo.visita_id } }
    end

    assert_redirected_to visitashallazgo_url(Visitashallazgo.last)
  end

  test "should show visitashallazgo" do
    get visitashallazgo_url(@visitashallazgo)
    assert_response :success
  end

  test "should get edit" do
    get edit_visitashallazgo_url(@visitashallazgo)
    assert_response :success
  end

  test "should update visitashallazgo" do
    patch visitashallazgo_url(@visitashallazgo), params: { visitashallazgo: { docvisitashallazgo: @visitashallazgo.docvisitashallazgo, tipo: @visitashallazgo.tipo, user_id: @visitashallazgo.user_id, visita_id: @visitashallazgo.visita_id } }
    assert_redirected_to visitashallazgo_url(@visitashallazgo)
  end

  test "should destroy visitashallazgo" do
    assert_difference('Visitashallazgo.count', -1) do
      delete visitashallazgo_url(@visitashallazgo)
    end

    assert_redirected_to visitashallazgos_url
  end
end
