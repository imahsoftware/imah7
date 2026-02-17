require 'test_helper'

class MigracionestallasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @migracionestalla = migracionestallas(:one)
  end

  test "should get index" do
    get migracionestallas_url
    assert_response :success
  end

  test "should get new" do
    get new_migracionestalla_url
    assert_response :success
  end

  test "should create migracionestalla" do
    assert_difference('Migracionestalla.count') do
      post migracionestallas_url, params: { migracionestalla: { archivo_id: @migracionestalla.archivo_id, cant_camisa: @migracionestalla.cant_camisa, cant_pantalon: @migracionestalla.cant_pantalon, cant_zapatos: @migracionestalla.cant_zapatos, casco: @migracionestalla.casco, estado: @migracionestalla.estado, guantes: @migracionestalla.guantes, identificacion: @migracionestalla.identificacion, monogafas: @migracionestalla.monogafas, talla_camisa: @migracionestalla.talla_camisa, talla_pantalon: @migracionestalla.talla_pantalon, talla_zapatos: @migracionestalla.talla_zapatos, tapabocas: @migracionestalla.tapabocas, user_id: @migracionestalla.user_id, zapatos: @migracionestalla.zapatos } }
    end

    assert_redirected_to migracionestalla_url(Migracionestalla.last)
  end

  test "should show migracionestalla" do
    get migracionestalla_url(@migracionestalla)
    assert_response :success
  end

  test "should get edit" do
    get edit_migracionestalla_url(@migracionestalla)
    assert_response :success
  end

  test "should update migracionestalla" do
    patch migracionestalla_url(@migracionestalla), params: { migracionestalla: { archivo_id: @migracionestalla.archivo_id, cant_camisa: @migracionestalla.cant_camisa, cant_pantalon: @migracionestalla.cant_pantalon, cant_zapatos: @migracionestalla.cant_zapatos, casco: @migracionestalla.casco, estado: @migracionestalla.estado, guantes: @migracionestalla.guantes, identificacion: @migracionestalla.identificacion, monogafas: @migracionestalla.monogafas, talla_camisa: @migracionestalla.talla_camisa, talla_pantalon: @migracionestalla.talla_pantalon, talla_zapatos: @migracionestalla.talla_zapatos, tapabocas: @migracionestalla.tapabocas, user_id: @migracionestalla.user_id, zapatos: @migracionestalla.zapatos } }
    assert_redirected_to migracionestalla_url(@migracionestalla)
  end

  test "should destroy migracionestalla" do
    assert_difference('Migracionestalla.count', -1) do
      delete migracionestalla_url(@migracionestalla)
    end

    assert_redirected_to migracionestallas_url
  end
end
