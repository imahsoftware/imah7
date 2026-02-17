require 'test_helper'

class ContratosperusersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosperuser = contratosperusers(:one)
  end

  test "should get index" do
    get contratosperusers_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosperuser_url
    assert_response :success
  end

  test "should create contratosperuser" do
    assert_difference('Contratosperuser.count') do
      post contratosperusers_url, params: { contratosperuser: { contratospersona_id: @contratosperuser.contratospersona_id, fecha_fin: @contratosperuser.fecha_fin, fecha_inicio: @contratosperuser.fecha_inicio, user_id: @contratosperuser.user_id } }
    end

    assert_redirected_to contratosperuser_url(Contratosperuser.last)
  end

  test "should show contratosperuser" do
    get contratosperuser_url(@contratosperuser)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosperuser_url(@contratosperuser)
    assert_response :success
  end

  test "should update contratosperuser" do
    patch contratosperuser_url(@contratosperuser), params: { contratosperuser: { contratospersona_id: @contratosperuser.contratospersona_id, fecha_fin: @contratosperuser.fecha_fin, fecha_inicio: @contratosperuser.fecha_inicio, user_id: @contratosperuser.user_id } }
    assert_redirected_to contratosperuser_url(@contratosperuser)
  end

  test "should destroy contratosperuser" do
    assert_difference('Contratosperuser.count', -1) do
      delete contratosperuser_url(@contratosperuser)
    end

    assert_redirected_to contratosperusers_url
  end
end
