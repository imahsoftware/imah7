require 'test_helper'

class MigracionesprorrogasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @migracionesprorroga = migracionesprorrogas(:one)
  end

  test "should get index" do
    get migracionesprorrogas_url
    assert_response :success
  end

  test "should get new" do
    get new_migracionesprorroga_url
    assert_response :success
  end

  test "should create migracionesprorroga" do
    assert_difference('Migracionesprorroga.count') do
      post migracionesprorrogas_url, params: { migracionesprorroga: { archivo_id: @migracionesprorroga.archivo_id, contratosperfecha_id: @migracionesprorroga.contratosperfecha_id, contratospersona_id: @migracionesprorroga.contratospersona_id, estado: @migracionesprorroga.estado, fecha_fin: @migracionesprorroga.fecha_fin, identificacion: @migracionesprorroga.identificacion, user_id: @migracionesprorroga.user_id } }
    end

    assert_redirected_to migracionesprorroga_url(Migracionesprorroga.last)
  end

  test "should show migracionesprorroga" do
    get migracionesprorroga_url(@migracionesprorroga)
    assert_response :success
  end

  test "should get edit" do
    get edit_migracionesprorroga_url(@migracionesprorroga)
    assert_response :success
  end

  test "should update migracionesprorroga" do
    patch migracionesprorroga_url(@migracionesprorroga), params: { migracionesprorroga: { archivo_id: @migracionesprorroga.archivo_id, contratosperfecha_id: @migracionesprorroga.contratosperfecha_id, contratospersona_id: @migracionesprorroga.contratospersona_id, estado: @migracionesprorroga.estado, fecha_fin: @migracionesprorroga.fecha_fin, identificacion: @migracionesprorroga.identificacion, user_id: @migracionesprorroga.user_id } }
    assert_redirected_to migracionesprorroga_url(@migracionesprorroga)
  end

  test "should destroy migracionesprorroga" do
    assert_difference('Migracionesprorroga.count', -1) do
      delete migracionesprorroga_url(@migracionesprorroga)
    end

    assert_redirected_to migracionesprorrogas_url
  end
end
