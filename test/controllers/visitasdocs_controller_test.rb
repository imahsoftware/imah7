require 'test_helper'

class VisitasdocsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @visitasdoc = visitasdocs(:one)
  end

  test "should get index" do
    get visitasdocs_url
    assert_response :success
  end

  test "should get new" do
    get new_visitasdoc_url
    assert_response :success
  end

  test "should create visitasdoc" do
    assert_difference('Visitasdoc.count') do
      post visitasdocs_url, params: { visitasdoc: {  } }
    end

    assert_redirected_to visitasdoc_url(Visitasdoc.last)
  end

  test "should show visitasdoc" do
    get visitasdoc_url(@visitasdoc)
    assert_response :success
  end

  test "should get edit" do
    get edit_visitasdoc_url(@visitasdoc)
    assert_response :success
  end

  test "should update visitasdoc" do
    patch visitasdoc_url(@visitasdoc), params: { visitasdoc: {  } }
    assert_redirected_to visitasdoc_url(@visitasdoc)
  end

  test "should destroy visitasdoc" do
    assert_difference('Visitasdoc.count', -1) do
      delete visitasdoc_url(@visitasdoc)
    end

    assert_redirected_to visitasdocs_url
  end
end
