require 'test_helper'

class TareasactividadesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tareasactividad = tareasactividades(:one)
  end

  test "should get index" do
    get tareasactividades_url
    assert_response :success
  end

  test "should get new" do
    get new_tareasactividad_url
    assert_response :success
  end

  test "should create tareasactividad" do
    assert_difference('Tareasactividad.count') do
      post tareasactividades_url, params: { tareasactividad: { area: @tareasactividad.area, descripcion: @tareasactividad.descripcion, estado: @tareasactividad.estado, resultado: @tareasactividad.resultado, tarea_id: @tareasactividad.tarea_id } }
    end

    assert_redirected_to tareasactividad_url(Tareasactividad.last)
  end

  test "should show tareasactividad" do
    get tareasactividad_url(@tareasactividad)
    assert_response :success
  end

  test "should get edit" do
    get edit_tareasactividad_url(@tareasactividad)
    assert_response :success
  end

  test "should update tareasactividad" do
    patch tareasactividad_url(@tareasactividad), params: { tareasactividad: { area: @tareasactividad.area, descripcion: @tareasactividad.descripcion, estado: @tareasactividad.estado, resultado: @tareasactividad.resultado, tarea_id: @tareasactividad.tarea_id } }
    assert_redirected_to tareasactividad_url(@tareasactividad)
  end

  test "should destroy tareasactividad" do
    assert_difference('Tareasactividad.count', -1) do
      delete tareasactividad_url(@tareasactividad)
    end

    assert_redirected_to tareasactividades_url
  end
end
