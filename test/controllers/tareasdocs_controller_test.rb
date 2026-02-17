require 'test_helper'

class TareasdocsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tareasdoc = tareasdocs(:one)
  end

  test "should get index" do
    get tareasdocs_url
    assert_response :success
  end

  test "should get new" do
    get new_tareasdoc_url
    assert_response :success
  end

  test "should create tareasdoc" do
    assert_difference('Tareasdoc.count') do
      post tareasdocs_url, params: { tareasdoc: { descripcion: @tareasdoc.descripcion, tarea_id: @tareasdoc.tarea_id, tareadoc: @tareasdoc.tareadoc, user_id: @tareasdoc.user_id } }
    end

    assert_redirected_to tareasdoc_url(Tareasdoc.last)
  end

  test "should show tareasdoc" do
    get tareasdoc_url(@tareasdoc)
    assert_response :success
  end

  test "should get edit" do
    get edit_tareasdoc_url(@tareasdoc)
    assert_response :success
  end

  test "should update tareasdoc" do
    patch tareasdoc_url(@tareasdoc), params: { tareasdoc: { descripcion: @tareasdoc.descripcion, tarea_id: @tareasdoc.tarea_id, tareadoc: @tareasdoc.tareadoc, user_id: @tareasdoc.user_id } }
    assert_redirected_to tareasdoc_url(@tareasdoc)
  end

  test "should destroy tareasdoc" do
    assert_difference('Tareasdoc.count', -1) do
      delete tareasdoc_url(@tareasdoc)
    end

    assert_redirected_to tareasdocs_url
  end
end
