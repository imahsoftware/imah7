require 'test_helper'

class ContratosactnovusersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosactnovuser = contratosactnovusers(:one)
  end

  test "should get index" do
    get contratosactnovusers_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosactnovuser_url
    assert_response :success
  end

  test "should create contratosactnovuser" do
    assert_difference('Contratosactnovuser.count') do
      post contratosactnovusers_url, params: { contratosactnovuser: { contratosactnovedad_id: @contratosactnovuser.contratosactnovedad_id, user_id: @contratosactnovuser.user_id } }
    end

    assert_redirected_to contratosactnovuser_url(Contratosactnovuser.last)
  end

  test "should show contratosactnovuser" do
    get contratosactnovuser_url(@contratosactnovuser)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosactnovuser_url(@contratosactnovuser)
    assert_response :success
  end

  test "should update contratosactnovuser" do
    patch contratosactnovuser_url(@contratosactnovuser), params: { contratosactnovuser: { contratosactnovedad_id: @contratosactnovuser.contratosactnovedad_id, user_id: @contratosactnovuser.user_id } }
    assert_redirected_to contratosactnovuser_url(@contratosactnovuser)
  end

  test "should destroy contratosactnovuser" do
    assert_difference('Contratosactnovuser.count', -1) do
      delete contratosactnovuser_url(@contratosactnovuser)
    end

    assert_redirected_to contratosactnovusers_url
  end
end
