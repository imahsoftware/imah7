require 'test_helper'

class PersonasformulariosdocsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @personasformulariosdoc = personasformulariosdocs(:one)
  end

  test "should get index" do
    get personasformulariosdocs_url
    assert_response :success
  end

  test "should get new" do
    get new_personasformulariosdoc_url
    assert_response :success
  end

  test "should create personasformulariosdoc" do
    assert_difference('Personasformulariosdoc.count') do
      post personasformulariosdocs_url, params: { personasformulariosdoc: { documento: @personasformulariosdoc.documento, parcargosdoc_id: @personasformulariosdoc.parcargosdoc_id, personasformulario_id: @personasformulariosdoc.personasformulario_id } }
    end

    assert_redirected_to personasformulariosdoc_url(Personasformulariosdoc.last)
  end

  test "should show personasformulariosdoc" do
    get personasformulariosdoc_url(@personasformulariosdoc)
    assert_response :success
  end

  test "should get edit" do
    get edit_personasformulariosdoc_url(@personasformulariosdoc)
    assert_response :success
  end

  test "should update personasformulariosdoc" do
    patch personasformulariosdoc_url(@personasformulariosdoc), params: { personasformulariosdoc: { documento: @personasformulariosdoc.documento, parcargosdoc_id: @personasformulariosdoc.parcargosdoc_id, personasformulario_id: @personasformulariosdoc.personasformulario_id } }
    assert_redirected_to personasformulariosdoc_url(@personasformulariosdoc)
  end

  test "should destroy personasformulariosdoc" do
    assert_difference('Personasformulariosdoc.count', -1) do
      delete personasformulariosdoc_url(@personasformulariosdoc)
    end

    assert_redirected_to personasformulariosdocs_url
  end
end
