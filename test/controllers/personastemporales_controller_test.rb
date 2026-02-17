require 'test_helper'

class PersonastemporalesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @personastemporal = personastemporales(:one)
  end

  test "should get index" do
    get personastemporales_url
    assert_response :success
  end

  test "should get new" do
    get new_personastemporal_url
    assert_response :success
  end

  test "should create personastemporal" do
    assert_difference('Personastemporal.count') do
      post personastemporales_url, params: { personastemporal: { apellidos: @personastemporal.apellidos, autobuscar: @personastemporal.autobuscar, cargo: @personastemporal.cargo, contrata_id: @personastemporal.contrata_id, identificacion: @personastemporal.identificacion, movil: @personastemporal.movil, nombre_completo: @personastemporal.nombre_completo, nombres: @personastemporal.nombres, telefono: @personastemporal.telefono, tipo_identificacion: @personastemporal.tipo_identificacion, tipo_usuario: @personastemporal.tipo_usuario, user_asignado: @personastemporal.user_asignado, user_id: @personastemporal.user_id } }
    end

    assert_redirected_to personastemporal_url(Personastemporal.last)
  end

  test "should show personastemporal" do
    get personastemporal_url(@personastemporal)
    assert_response :success
  end

  test "should get edit" do
    get edit_personastemporal_url(@personastemporal)
    assert_response :success
  end

  test "should update personastemporal" do
    patch personastemporal_url(@personastemporal), params: { personastemporal: { apellidos: @personastemporal.apellidos, autobuscar: @personastemporal.autobuscar, cargo: @personastemporal.cargo, contrata_id: @personastemporal.contrata_id, identificacion: @personastemporal.identificacion, movil: @personastemporal.movil, nombre_completo: @personastemporal.nombre_completo, nombres: @personastemporal.nombres, telefono: @personastemporal.telefono, tipo_identificacion: @personastemporal.tipo_identificacion, tipo_usuario: @personastemporal.tipo_usuario, user_asignado: @personastemporal.user_asignado, user_id: @personastemporal.user_id } }
    assert_redirected_to personastemporal_url(@personastemporal)
  end

  test "should destroy personastemporal" do
    assert_difference('Personastemporal.count', -1) do
      delete personastemporal_url(@personastemporal)
    end

    assert_redirected_to personastemporales_url
  end
end
