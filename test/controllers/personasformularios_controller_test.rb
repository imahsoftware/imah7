require 'test_helper'

class PersonasformulariosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @personasformulario = personasformularios(:one)
  end

  test "should get index" do
    get personasformularios_url
    assert_response :success
  end

  test "should get new" do
    get new_personasformulario_url
    assert_response :success
  end

  test "should create personasformulario" do
    assert_difference('Personasformulario.count') do
      post personasformularios_url, params: { personasformulario: { migracionespersona_id: @personasformulario.migracionespersona_id } }
    end

    assert_redirected_to personasformulario_url(Personasformulario.last)
  end

  test "should show personasformulario" do
    get personasformulario_url(@personasformulario)
    assert_response :success
  end

  test "should get edit" do
    get edit_personasformulario_url(@personasformulario)
    assert_response :success
  end

  test "should update personasformulario" do
    patch personasformulario_url(@personasformulario), params: { personasformulario: { migracionespersona_id: @personasformulario.migracionespersona_id } }
    assert_redirected_to personasformulario_url(@personasformulario)
  end

  test "should destroy personasformulario" do
    assert_difference('Personasformulario.count', -1) do
      delete personasformulario_url(@personasformulario)
    end

    assert_redirected_to personasformularios_url
  end
end
