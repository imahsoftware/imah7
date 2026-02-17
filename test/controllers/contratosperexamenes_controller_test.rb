require 'test_helper'

class ContratosperexamenesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosperexamen = contratosperexamenes(:one)
  end

  test "should get index" do
    get contratosperexamenes_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosperexamen_url
    assert_response :success
  end

  test "should create contratosperexamen" do
    assert_difference('Contratosperexamen.count') do
      post contratosperexamenes_url, params: { contratosperexamen: { contratospersona_id: @contratosperexamen.contratospersona_id, descripcion: @contratosperexamen.descripcion, estado: @contratosperexamen.estado, user_act: @contratosperexamen.user_act, user_id: @contratosperexamen.user_id } }
    end

    assert_redirected_to contratosperexamen_url(Contratosperexamen.last)
  end

  test "should show contratosperexamen" do
    get contratosperexamen_url(@contratosperexamen)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosperexamen_url(@contratosperexamen)
    assert_response :success
  end

  test "should update contratosperexamen" do
    patch contratosperexamen_url(@contratosperexamen), params: { contratosperexamen: { contratospersona_id: @contratosperexamen.contratospersona_id, descripcion: @contratosperexamen.descripcion, estado: @contratosperexamen.estado, user_act: @contratosperexamen.user_act, user_id: @contratosperexamen.user_id } }
    assert_redirected_to contratosperexamen_url(@contratosperexamen)
  end

  test "should destroy contratosperexamen" do
    assert_difference('Contratosperexamen.count', -1) do
      delete contratosperexamen_url(@contratosperexamen)
    end

    assert_redirected_to contratosperexamenes_url
  end
end
