require 'test_helper'

class ContratossoleppsdocsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratossoleppsdoc = contratossoleppsdocs(:one)
  end

  test "should get index" do
    get contratossoleppsdocs_url
    assert_response :success
  end

  test "should get new" do
    get new_contratossoleppsdoc_url
    assert_response :success
  end

  test "should create contratossoleppsdoc" do
    assert_difference('Contratossoleppsdoc.count') do
      post contratossoleppsdocs_url, params: { contratossoleppsdoc: { contratossolepp_id_id: @contratossoleppsdoc.contratossolepp_id_id, docepps: @contratossoleppsdoc.docepps, user_id: @contratossoleppsdoc.user_id } }
    end

    assert_redirected_to contratossoleppsdoc_url(Contratossoleppsdoc.last)
  end

  test "should show contratossoleppsdoc" do
    get contratossoleppsdoc_url(@contratossoleppsdoc)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratossoleppsdoc_url(@contratossoleppsdoc)
    assert_response :success
  end

  test "should update contratossoleppsdoc" do
    patch contratossoleppsdoc_url(@contratossoleppsdoc), params: { contratossoleppsdoc: { contratossolepp_id_id: @contratossoleppsdoc.contratossolepp_id_id, docepps: @contratossoleppsdoc.docepps, user_id: @contratossoleppsdoc.user_id } }
    assert_redirected_to contratossoleppsdoc_url(@contratossoleppsdoc)
  end

  test "should destroy contratossoleppsdoc" do
    assert_difference('Contratossoleppsdoc.count', -1) do
      delete contratossoleppsdoc_url(@contratossoleppsdoc)
    end

    assert_redirected_to contratossoleppsdocs_url
  end
end
