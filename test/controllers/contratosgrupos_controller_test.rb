require 'test_helper'

class ContratosgruposControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosgrupo = contratosgrupos(:one)
  end

  test "should get index" do
    get contratosgrupos_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosgrupo_url
    assert_response :success
  end

  test "should create contratosgrupo" do
    assert_difference('Contratosgrupo.count') do
      post contratosgrupos_url, params: { contratosgrupo: { contrato_id: @contratosgrupo.contrato_id, descripcion: @contratosgrupo.descripcion } }
    end

    assert_redirected_to contratosgrupo_url(Contratosgrupo.last)
  end

  test "should show contratosgrupo" do
    get contratosgrupo_url(@contratosgrupo)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosgrupo_url(@contratosgrupo)
    assert_response :success
  end

  test "should update contratosgrupo" do
    patch contratosgrupo_url(@contratosgrupo), params: { contratosgrupo: { contrato_id: @contratosgrupo.contrato_id, descripcion: @contratosgrupo.descripcion } }
    assert_redirected_to contratosgrupo_url(@contratosgrupo)
  end

  test "should destroy contratosgrupo" do
    assert_difference('Contratosgrupo.count', -1) do
      delete contratosgrupo_url(@contratosgrupo)
    end

    assert_redirected_to contratosgrupos_url
  end
end
