require 'test_helper'

class ContratosactnovdocsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosactnovdoc = contratosactnovdocs(:one)
  end

  test "should get index" do
    get contratosactnovdocs_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosactnovdoc_url
    assert_response :success
  end

  test "should create contratosactnovdoc" do
    assert_difference('Contratosactnovdoc.count') do
      post contratosactnovdocs_url, params: { contratosactnovdoc: { contratosactnovedad_id: @contratosactnovdoc.contratosactnovedad_id, descripcion: @contratosactnovdoc.descripcion, novedad: @contratosactnovdoc.novedad, user_id: @contratosactnovdoc.user_id } }
    end

    assert_redirected_to contratosactnovdoc_url(Contratosactnovdoc.last)
  end

  test "should show contratosactnovdoc" do
    get contratosactnovdoc_url(@contratosactnovdoc)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosactnovdoc_url(@contratosactnovdoc)
    assert_response :success
  end

  test "should update contratosactnovdoc" do
    patch contratosactnovdoc_url(@contratosactnovdoc), params: { contratosactnovdoc: { contratosactnovedad_id: @contratosactnovdoc.contratosactnovedad_id, descripcion: @contratosactnovdoc.descripcion, novedad: @contratosactnovdoc.novedad, user_id: @contratosactnovdoc.user_id } }
    assert_redirected_to contratosactnovdoc_url(@contratosactnovdoc)
  end

  test "should destroy contratosactnovdoc" do
    assert_difference('Contratosactnovdoc.count', -1) do
      delete contratosactnovdoc_url(@contratosactnovdoc)
    end

    assert_redirected_to contratosactnovdocs_url
  end
end
