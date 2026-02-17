require 'test_helper'

class MigracionessedesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @migracionessede = migracionessedes(:one)
  end

  test "should get index" do
    get migracionessedes_url
    assert_response :success
  end

  test "should get new" do
    get new_migracionessede_url
    assert_response :success
  end

  test "should create migracionessede" do
    assert_difference('Migracionessede.count') do
      post migracionessedes_url, params: { migracionessede: { archivo_id: @migracionessede.archivo_id, contrato_id: @migracionessede.contrato_id, departamento: @migracionessede.departamento, direccion: @migracionessede.direccion, estado: @migracionessede.estado, municipio: @migracionessede.municipio, nombre: @migracionessede.nombre, ordensede: @migracionessede.ordensede, user_id: @migracionessede.user_id } }
    end

    assert_redirected_to migracionessede_url(Migracionessede.last)
  end

  test "should show migracionessede" do
    get migracionessede_url(@migracionessede)
    assert_response :success
  end

  test "should get edit" do
    get edit_migracionessede_url(@migracionessede)
    assert_response :success
  end

  test "should update migracionessede" do
    patch migracionessede_url(@migracionessede), params: { migracionessede: { archivo_id: @migracionessede.archivo_id, contrato_id: @migracionessede.contrato_id, departamento: @migracionessede.departamento, direccion: @migracionessede.direccion, estado: @migracionessede.estado, municipio: @migracionessede.municipio, nombre: @migracionessede.nombre, ordensede: @migracionessede.ordensede, user_id: @migracionessede.user_id } }
    assert_redirected_to migracionessede_url(@migracionessede)
  end

  test "should destroy migracionessede" do
    assert_difference('Migracionessede.count', -1) do
      delete migracionessede_url(@migracionessede)
    end

    assert_redirected_to migracionessedes_url
  end
end
