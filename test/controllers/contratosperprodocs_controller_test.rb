require 'test_helper'

class ContratosperprodocsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosperprodoc = contratosperprodocs(:one)
  end

  test "should get index" do
    get contratosperprodocs_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosperprodoc_url
    assert_response :success
  end

  test "should create contratosperprodoc" do
    assert_difference('Contratosperprodoc.count') do
      post contratosperprodocs_url, params: { contratosperprodoc: { contratosperproceso_id: @contratosperprodoc.contratosperproceso_id, contratospersona_id: @contratosperprodoc.contratospersona_id, docproceso: @contratosperprodoc.docproceso, tipo: @contratosperprodoc.tipo, user_id: @contratosperprodoc.user_id } }
    end

    assert_redirected_to contratosperprodoc_url(Contratosperprodoc.last)
  end

  test "should show contratosperprodoc" do
    get contratosperprodoc_url(@contratosperprodoc)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosperprodoc_url(@contratosperprodoc)
    assert_response :success
  end

  test "should update contratosperprodoc" do
    patch contratosperprodoc_url(@contratosperprodoc), params: { contratosperprodoc: { contratosperproceso_id: @contratosperprodoc.contratosperproceso_id, contratospersona_id: @contratosperprodoc.contratospersona_id, docproceso: @contratosperprodoc.docproceso, tipo: @contratosperprodoc.tipo, user_id: @contratosperprodoc.user_id } }
    assert_redirected_to contratosperprodoc_url(@contratosperprodoc)
  end

  test "should destroy contratosperprodoc" do
    assert_difference('Contratosperprodoc.count', -1) do
      delete contratosperprodoc_url(@contratosperprodoc)
    end

    assert_redirected_to contratosperprodocs_url
  end
end
