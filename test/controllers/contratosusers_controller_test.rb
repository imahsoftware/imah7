require 'test_helper'

class ContratosusersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosuser = contratosusers(:one)
  end

  test "should get index" do
    get contratosusers_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosuser_url
    assert_response :success
  end

  test "should create contratosuser" do
    assert_difference('Contratosuser.count') do
      post contratosusers_url, params: { contratosuser: { contrato_id: @contratosuser.contrato_id, fecha_fin: @contratosuser.fecha_fin, fecha_inicio: @contratosuser.fecha_inicio, user_id: @contratosuser.user_id, user_interventor: @contratosuser.user_interventor } }
    end

    assert_redirected_to contratosuser_url(Contratosuser.last)
  end

  test "should show contratosuser" do
    get contratosuser_url(@contratosuser)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosuser_url(@contratosuser)
    assert_response :success
  end

  test "should update contratosuser" do
    patch contratosuser_url(@contratosuser), params: { contratosuser: { contrato_id: @contratosuser.contrato_id, fecha_fin: @contratosuser.fecha_fin, fecha_inicio: @contratosuser.fecha_inicio, user_id: @contratosuser.user_id, user_interventor: @contratosuser.user_interventor } }
    assert_redirected_to contratosuser_url(@contratosuser)
  end

  test "should destroy contratosuser" do
    assert_difference('Contratosuser.count', -1) do
      delete contratosuser_url(@contratosuser)
    end

    assert_redirected_to contratosusers_url
  end
end
