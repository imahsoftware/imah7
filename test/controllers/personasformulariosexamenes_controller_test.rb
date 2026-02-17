require 'test_helper'

class PersonasformulariosexamenesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @personasformulariosexamen = personasformulariosexamenes(:one)
  end

  test "should get index" do
    get personasformulariosexamenes_url
    assert_response :success
  end

  test "should get new" do
    get new_personasformulariosexamen_url
    assert_response :success
  end

  test "should create personasformulariosexamen" do
    assert_difference('Personasformulariosexamen.count') do
      post personasformulariosexamenes_url, params: { personasformulariosexamen: { descripcion: @personasformulariosexamen.descripcion, direccion: @personasformulariosexamen.direccion, estado: @personasformulariosexamen.estado, fecha: @personasformulariosexamen.fecha, hora: @personasformulariosexamen.hora, personasformulario_id: @personasformulariosexamen.personasformulario_id, recomendaciones: @personasformulariosexamen.recomendaciones } }
    end

    assert_redirected_to personasformulariosexamen_url(Personasformulariosexamen.last)
  end

  test "should show personasformulariosexamen" do
    get personasformulariosexamen_url(@personasformulariosexamen)
    assert_response :success
  end

  test "should get edit" do
    get edit_personasformulariosexamen_url(@personasformulariosexamen)
    assert_response :success
  end

  test "should update personasformulariosexamen" do
    patch personasformulariosexamen_url(@personasformulariosexamen), params: { personasformulariosexamen: { descripcion: @personasformulariosexamen.descripcion, direccion: @personasformulariosexamen.direccion, estado: @personasformulariosexamen.estado, fecha: @personasformulariosexamen.fecha, hora: @personasformulariosexamen.hora, personasformulario_id: @personasformulariosexamen.personasformulario_id, recomendaciones: @personasformulariosexamen.recomendaciones } }
    assert_redirected_to personasformulariosexamen_url(@personasformulariosexamen)
  end

  test "should destroy personasformulariosexamen" do
    assert_difference('Personasformulariosexamen.count', -1) do
      delete personasformulariosexamen_url(@personasformulariosexamen)
    end

    assert_redirected_to personasformulariosexamenes_url
  end
end
