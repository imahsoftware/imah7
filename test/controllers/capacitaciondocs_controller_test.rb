require 'test_helper'

class CapacitaciondocsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @capacitaciondoc = capacitaciondocs(:one)
  end

  test "should get index" do
    get capacitaciondocs_url
    assert_response :success
  end

  test "should get new" do
    get new_capacitaciondoc_url
    assert_response :success
  end

  test "should create capacitaciondoc" do
    assert_difference('Capacitaciondoc.count') do
      post capacitaciondocs_url, params: { capacitaciondoc: { capacitacion_id: @capacitaciondoc.capacitacion_id, capacitaciondoc: @capacitaciondoc.capacitaciondoc, user_id: @capacitaciondoc.user_id } }
    end

    assert_redirected_to capacitaciondoc_url(Capacitaciondoc.last)
  end

  test "should show capacitaciondoc" do
    get capacitaciondoc_url(@capacitaciondoc)
    assert_response :success
  end

  test "should get edit" do
    get edit_capacitaciondoc_url(@capacitaciondoc)
    assert_response :success
  end

  test "should update capacitaciondoc" do
    patch capacitaciondoc_url(@capacitaciondoc), params: { capacitaciondoc: { capacitacion_id: @capacitaciondoc.capacitacion_id, capacitaciondoc: @capacitaciondoc.capacitaciondoc, user_id: @capacitaciondoc.user_id } }
    assert_redirected_to capacitaciondoc_url(@capacitaciondoc)
  end

  test "should destroy capacitaciondoc" do
    assert_difference('Capacitaciondoc.count', -1) do
      delete capacitaciondoc_url(@capacitaciondoc)
    end

    assert_redirected_to capacitaciondocs_url
  end
end
