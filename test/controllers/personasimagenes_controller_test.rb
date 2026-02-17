require 'test_helper'

class PersonasimagenesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @personasimagen = personasimagenes(:one)
  end

  test "should get index" do
    get personasimagenes_url
    assert_response :success
  end

  test "should get new" do
    get new_personasimagen_url
    assert_response :success
  end

  test "should create personasimagen" do
    assert_difference('Personasimagen.count') do
      post personasimagenes_url, params: { personasimagen: { documentos: @personasimagen.documentos, persona_id: @personasimagen.persona_id, user_id: @personasimagen.user_id } }
    end

    assert_redirected_to personasimagen_url(Personasimagen.last)
  end

  test "should show personasimagen" do
    get personasimagen_url(@personasimagen)
    assert_response :success
  end

  test "should get edit" do
    get edit_personasimagen_url(@personasimagen)
    assert_response :success
  end

  test "should update personasimagen" do
    patch personasimagen_url(@personasimagen), params: { personasimagen: { documentos: @personasimagen.documentos, persona_id: @personasimagen.persona_id, user_id: @personasimagen.user_id } }
    assert_redirected_to personasimagen_url(@personasimagen)
  end

  test "should destroy personasimagen" do
    assert_difference('Personasimagen.count', -1) do
      delete personasimagen_url(@personasimagen)
    end

    assert_redirected_to personasimagenes_url
  end
end
