require 'test_helper'

class PersonasforexadocsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @personasforexadoc = personasforexadocs(:one)
  end

  test "should get index" do
    get personasforexadocs_url
    assert_response :success
  end

  test "should get new" do
    get new_personasforexadoc_url
    assert_response :success
  end

  test "should create personasforexadoc" do
    assert_difference('Personasforexadoc.count') do
      post personasforexadocs_url, params: { personasforexadoc: { descripcion: @personasforexadoc.descripcion, documento_examen: @personasforexadoc.documento_examen, personasformulariosexamen_id: @personasforexadoc.personasformulariosexamen_id } }
    end

    assert_redirected_to personasforexadoc_url(Personasforexadoc.last)
  end

  test "should show personasforexadoc" do
    get personasforexadoc_url(@personasforexadoc)
    assert_response :success
  end

  test "should get edit" do
    get edit_personasforexadoc_url(@personasforexadoc)
    assert_response :success
  end

  test "should update personasforexadoc" do
    patch personasforexadoc_url(@personasforexadoc), params: { personasforexadoc: { descripcion: @personasforexadoc.descripcion, documento_examen: @personasforexadoc.documento_examen, personasformulariosexamen_id: @personasforexadoc.personasformulariosexamen_id } }
    assert_redirected_to personasforexadoc_url(@personasforexadoc)
  end

  test "should destroy personasforexadoc" do
    assert_difference('Personasforexadoc.count', -1) do
      delete personasforexadoc_url(@personasforexadoc)
    end

    assert_redirected_to personasforexadocs_url
  end
end
