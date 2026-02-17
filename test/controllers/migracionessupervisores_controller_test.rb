require 'test_helper'

class MigracionessupervisoresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @migracionessupervisor = migracionessupervisores(:one)
  end

  test "should get index" do
    get migracionessupervisores_url
    assert_response :success
  end

  test "should get new" do
    get new_migracionessupervisor_url
    assert_response :success
  end

  test "should create migracionessupervisor" do
    assert_difference('Migracionessupervisor.count') do
      post migracionessupervisores_url, params: { migracionessupervisor: { archivo_id: @migracionessupervisor.archivo_id, estado: @migracionessupervisor.estado, identificacion: @migracionessupervisor.identificacion, user_id: @migracionessupervisor.user_id, userasig_id: @migracionessupervisor.userasig_id } }
    end

    assert_redirected_to migracionessupervisor_url(Migracionessupervisor.last)
  end

  test "should show migracionessupervisor" do
    get migracionessupervisor_url(@migracionessupervisor)
    assert_response :success
  end

  test "should get edit" do
    get edit_migracionessupervisor_url(@migracionessupervisor)
    assert_response :success
  end

  test "should update migracionessupervisor" do
    patch migracionessupervisor_url(@migracionessupervisor), params: { migracionessupervisor: { archivo_id: @migracionessupervisor.archivo_id, estado: @migracionessupervisor.estado, identificacion: @migracionessupervisor.identificacion, user_id: @migracionessupervisor.user_id, userasig_id: @migracionessupervisor.userasig_id } }
    assert_redirected_to migracionessupervisor_url(@migracionessupervisor)
  end

  test "should destroy migracionessupervisor" do
    assert_difference('Migracionessupervisor.count', -1) do
      delete migracionessupervisor_url(@migracionessupervisor)
    end

    assert_redirected_to migracionessupervisores_url
  end
end
