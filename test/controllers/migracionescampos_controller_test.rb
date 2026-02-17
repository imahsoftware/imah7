require 'test_helper'

class MigracionescamposControllerTest < ActionDispatch::IntegrationTest
  setup do
    @migracionescampo = migracionescampos(:one)
  end

  test "should get index" do
    get migracionescampos_url
    assert_response :success
  end

  test "should get new" do
    get new_migracionescampo_url
    assert_response :success
  end

  test "should create migracionescampo" do
    assert_difference('Migracionescampo.count') do
      post migracionescampos_url, params: { migracionescampo: { campo: @migracionescampo.campo, encabezado: @migracionescampo.encabezado, migracion_id: @migracionescampo.migracion_id, orden: @migracionescampo.orden, tipo: @migracionescampo.tipo } }
    end

    assert_redirected_to migracionescampo_url(Migracionescampo.last)
  end

  test "should show migracionescampo" do
    get migracionescampo_url(@migracionescampo)
    assert_response :success
  end

  test "should get edit" do
    get edit_migracionescampo_url(@migracionescampo)
    assert_response :success
  end

  test "should update migracionescampo" do
    patch migracionescampo_url(@migracionescampo), params: { migracionescampo: { campo: @migracionescampo.campo, encabezado: @migracionescampo.encabezado, migracion_id: @migracionescampo.migracion_id, orden: @migracionescampo.orden, tipo: @migracionescampo.tipo } }
    assert_redirected_to migracionescampo_url(@migracionescampo)
  end

  test "should destroy migracionescampo" do
    assert_difference('Migracionescampo.count', -1) do
      delete migracionescampo_url(@migracionescampo)
    end

    assert_redirected_to migracionescampos_url
  end
end
