require 'test_helper'

class MigracionescontratosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @migracionescontrato = migracionescontratos(:one)
  end

  test "should get index" do
    get migracionescontratos_url
    assert_response :success
  end

  test "should get new" do
    get new_migracionescontrato_url
    assert_response :success
  end

  test "should create migracionescontrato" do
    assert_difference('Migracionescontrato.count') do
      post migracionescontratos_url, params: { migracionescontrato: { archivo_id: @migracionescontrato.archivo_id, contratoscargo_id: @migracionescontrato.contratoscargo_id, contratosgrupo_id: @migracionescontrato.contratosgrupo_id, estado: @migracionescontrato.estado, fecha_inicio: @migracionescontrato.fecha_inicio, identificacion: @migracionescontrato.identificacion, user_id: @migracionescontrato.user_id } }
    end

    assert_redirected_to migracionescontrato_url(Migracionescontrato.last)
  end

  test "should show migracionescontrato" do
    get migracionescontrato_url(@migracionescontrato)
    assert_response :success
  end

  test "should get edit" do
    get edit_migracionescontrato_url(@migracionescontrato)
    assert_response :success
  end

  test "should update migracionescontrato" do
    patch migracionescontrato_url(@migracionescontrato), params: { migracionescontrato: { archivo_id: @migracionescontrato.archivo_id, contratoscargo_id: @migracionescontrato.contratoscargo_id, contratosgrupo_id: @migracionescontrato.contratosgrupo_id, estado: @migracionescontrato.estado, fecha_inicio: @migracionescontrato.fecha_inicio, identificacion: @migracionescontrato.identificacion, user_id: @migracionescontrato.user_id } }
    assert_redirected_to migracionescontrato_url(@migracionescontrato)
  end

  test "should destroy migracionescontrato" do
    assert_difference('Migracionescontrato.count', -1) do
      delete migracionescontrato_url(@migracionescontrato)
    end

    assert_redirected_to migracionescontratos_url
  end
end
