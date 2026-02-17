require 'test_helper'

class ContratoscargosdetallesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratoscargosdetall = contratoscargosdetalles(:one)
  end

  test "should get index" do
    get contratoscargosdetalles_url
    assert_response :success
  end

  test "should get new" do
    get new_contratoscargosdetall_url
    assert_response :success
  end

  test "should create contratoscargosdetall" do
    assert_difference('Contratoscargosdetalle.count') do
      post contratoscargosdetalles_url, params: { contratoscargosdetall: { contratoscargo_id: @contratoscargosdetall.contratoscargo_id, nota: @contratoscargosdetall.nota, user_id: @contratoscargosdetall.user_id } }
    end

    assert_redirected_to contratoscargosdetall_url(Contratoscargosdetalle.last)
  end

  test "should show contratoscargosdetall" do
    get contratoscargosdetall_url(@contratoscargosdetall)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratoscargosdetall_url(@contratoscargosdetall)
    assert_response :success
  end

  test "should update contratoscargosdetall" do
    patch contratoscargosdetall_url(@contratoscargosdetall), params: { contratoscargosdetall: { contratoscargo_id: @contratoscargosdetall.contratoscargo_id, nota: @contratoscargosdetall.nota, user_id: @contratoscargosdetall.user_id } }
    assert_redirected_to contratoscargosdetall_url(@contratoscargosdetall)
  end

  test "should destroy contratoscargosdetall" do
    assert_difference('Contratoscargosdetalle.count', -1) do
      delete contratoscargosdetall_url(@contratoscargosdetall)
    end

    assert_redirected_to contratoscargosdetalles_url
  end
end
