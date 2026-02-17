require 'test_helper'

class ContratosperdetallesdocsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosperdetallesdoc = contratosperdetallesdocs(:one)
  end

  test "should get index" do
    get contratosperdetallesdocs_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosperdetallesdoc_url
    assert_response :success
  end

  test "should create contratosperdetallesdoc" do
    assert_difference('Contratosperdetallesdoc.count') do
      post contratosperdetallesdocs_url, params: { contratosperdetallesdoc: { contratosperinvdetalle_id: @contratosperdetallesdoc.contratosperinvdetalle_id, descripcion: @contratosperdetallesdoc.descripcion, invdetalle_doc: @contratosperdetallesdoc.invdetalle_doc, user_id: @contratosperdetallesdoc.user_id } }
    end

    assert_redirected_to contratosperdetallesdoc_url(Contratosperdetallesdoc.last)
  end

  test "should show contratosperdetallesdoc" do
    get contratosperdetallesdoc_url(@contratosperdetallesdoc)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosperdetallesdoc_url(@contratosperdetallesdoc)
    assert_response :success
  end

  test "should update contratosperdetallesdoc" do
    patch contratosperdetallesdoc_url(@contratosperdetallesdoc), params: { contratosperdetallesdoc: { contratosperinvdetalle_id: @contratosperdetallesdoc.contratosperinvdetalle_id, descripcion: @contratosperdetallesdoc.descripcion, invdetalle_doc: @contratosperdetallesdoc.invdetalle_doc, user_id: @contratosperdetallesdoc.user_id } }
    assert_redirected_to contratosperdetallesdoc_url(@contratosperdetallesdoc)
  end

  test "should destroy contratosperdetallesdoc" do
    assert_difference('Contratosperdetallesdoc.count', -1) do
      delete contratosperdetallesdoc_url(@contratosperdetallesdoc)
    end

    assert_redirected_to contratosperdetallesdocs_url
  end
end
