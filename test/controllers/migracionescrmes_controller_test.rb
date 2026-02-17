require 'test_helper'

class MigracionescrmesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @migracionescrm = migracionescrmes(:one)
  end

  test "should get index" do
    get migracionescrmes_url
    assert_response :success
  end

  test "should get new" do
    get new_migracionescrm_url
    assert_response :success
  end

  test "should create migracionescrm" do
    assert_difference('Migracionescrm.count') do
      post migracionescrmes_url, params: { migracionescrm: { autor: @migracionescrm.autor, carrera: @migracionescrm.carrera, checksum: @migracionescrm.checksum, consecutivo: @migracionescrm.consecutivo, correo: @migracionescrm.correo, detalle: @migracionescrm.detalle, enrollment: @migracionescrm.enrollment, estado: @migracionescrm.estado, estudiante: @migracionescrm.estudiante, fecha_creacion: @migracionescrm.fecha_creacion, fecha_modificacion: @migracionescrm.fecha_modificacion, identificacion: @migracionescrm.identificacion, modalidad: @migracionescrm.modalidad, nombre: @migracionescrm.nombre, oportunidad: @migracionescrm.oportunidad, origen_carga: @migracionescrm.origen_carga, periodo: @migracionescrm.periodo, persona_id: @migracionescrm.persona_id, primer: @migracionescrm.primer, site: @migracionescrm.site, sub_enrollment: @migracionescrm.sub_enrollment, sub_periodo: @migracionescrm.sub_periodo, telefono: @migracionescrm.telefono, tipo_carrera: @migracionescrm.tipo_carrera, tipo_oportunidad: @migracionescrm.tipo_oportunidad, user_id: @migracionescrm.user_id } }
    end

    assert_redirected_to migracionescrm_url(Migracionescrm.last)
  end

  test "should show migracionescrm" do
    get migracionescrm_url(@migracionescrm)
    assert_response :success
  end

  test "should get edit" do
    get edit_migracionescrm_url(@migracionescrm)
    assert_response :success
  end

  test "should update migracionescrm" do
    patch migracionescrm_url(@migracionescrm), params: { migracionescrm: { autor: @migracionescrm.autor, carrera: @migracionescrm.carrera, checksum: @migracionescrm.checksum, consecutivo: @migracionescrm.consecutivo, correo: @migracionescrm.correo, detalle: @migracionescrm.detalle, enrollment: @migracionescrm.enrollment, estado: @migracionescrm.estado, estudiante: @migracionescrm.estudiante, fecha_creacion: @migracionescrm.fecha_creacion, fecha_modificacion: @migracionescrm.fecha_modificacion, identificacion: @migracionescrm.identificacion, modalidad: @migracionescrm.modalidad, nombre: @migracionescrm.nombre, oportunidad: @migracionescrm.oportunidad, origen_carga: @migracionescrm.origen_carga, periodo: @migracionescrm.periodo, persona_id: @migracionescrm.persona_id, primer: @migracionescrm.primer, site: @migracionescrm.site, sub_enrollment: @migracionescrm.sub_enrollment, sub_periodo: @migracionescrm.sub_periodo, telefono: @migracionescrm.telefono, tipo_carrera: @migracionescrm.tipo_carrera, tipo_oportunidad: @migracionescrm.tipo_oportunidad, user_id: @migracionescrm.user_id } }
    assert_redirected_to migracionescrm_url(@migracionescrm)
  end

  test "should destroy migracionescrm" do
    assert_difference('Migracionescrm.count', -1) do
      delete migracionescrm_url(@migracionescrm)
    end

    assert_redirected_to migracionescrmes_url
  end
end
