require 'test_helper'

class ContratosperchequeosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratosperchequeo = contratosperchequeos(:one)
  end

  test "should get index" do
    get contratosperchequeos_url
    assert_response :success
  end

  test "should get new" do
    get new_contratosperchequeo_url
    assert_response :success
  end

  test "should create contratosperchequeo" do
    assert_difference('Contratosperchequeo.count') do
      post contratosperchequeos_url, params: { contratosperchequeo: { actividad: @contratosperchequeo.actividad, contratospersona_id: @contratosperchequeo.contratospersona_id, encargado_obra: @contratosperchequeo.encargado_obra, encargado_seguridad: @contratosperchequeo.encargado_seguridad, fecha: @contratosperchequeo.fecha, n_trabajadores: @contratosperchequeo.n_trabajadores, nombre_empresa: @contratosperchequeo.nombre_empresa, nombre_obra: @contratosperchequeo.nombre_obra, responsable: @contratosperchequeo.responsable } }
    end

    assert_redirected_to contratosperchequeo_url(Contratosperchequeo.last)
  end

  test "should show contratosperchequeo" do
    get contratosperchequeo_url(@contratosperchequeo)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratosperchequeo_url(@contratosperchequeo)
    assert_response :success
  end

  test "should update contratosperchequeo" do
    patch contratosperchequeo_url(@contratosperchequeo), params: { contratosperchequeo: { actividad: @contratosperchequeo.actividad, contratospersona_id: @contratosperchequeo.contratospersona_id, encargado_obra: @contratosperchequeo.encargado_obra, encargado_seguridad: @contratosperchequeo.encargado_seguridad, fecha: @contratosperchequeo.fecha, n_trabajadores: @contratosperchequeo.n_trabajadores, nombre_empresa: @contratosperchequeo.nombre_empresa, nombre_obra: @contratosperchequeo.nombre_obra, responsable: @contratosperchequeo.responsable } }
    assert_redirected_to contratosperchequeo_url(@contratosperchequeo)
  end

  test "should destroy contratosperchequeo" do
    assert_difference('Contratosperchequeo.count', -1) do
      delete contratosperchequeo_url(@contratosperchequeo)
    end

    assert_redirected_to contratosperchequeos_url
  end
end
