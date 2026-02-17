require 'test_helper'

class ContratospersonasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contratospersona = contratospersonas(:one)
  end

  test "should get index" do
    get contratospersonas_url
    assert_response :success
  end

  test "should get new" do
    get new_contratospersona_url
    assert_response :success
  end

  test "should create contratospersona" do
    assert_difference('Contratospersona.count') do
      post contratospersonas_url, params: { contratospersona: { activo: @contratospersona.activo, apellidos: @contratospersona.apellidos, area: @contratospersona.area, autobuscar: @contratospersona.autobuscar, banco: @contratospersona.banco, cargo: @contratospersona.cargo, ciudad: @contratospersona.ciudad, consignar: @contratospersona.consignar, contrato_id: @contratospersona.contrato_id, correo: @contratospersona.correo, cuenta_bancolombia: @contratospersona.cuenta_bancolombia, direccion: @contratospersona.direccion, eps: @contratospersona.eps, estado_civil: @contratospersona.estado_civil, estrato: @contratospersona.estrato, etapa: @contratospersona.etapa, fecha_expedicion: @contratospersona.fecha_expedicion, fecha_fin: @contratospersona.fecha_fin, fecha_ingreso: @contratospersona.fecha_ingreso, fecha_nacimiento: @contratospersona.fecha_nacimiento, fecha_periodo_prueba: @contratospersona.fecha_periodo_prueba, fecha_retiro: @contratospersona.fecha_retiro, fondo_pension: @contratospersona.fondo_pension, genero: @contratospersona.genero, grupo_nomina: @contratospersona.grupo_nomina, identificacion: @contratospersona.identificacion, lugar_expedicion: @contratospersona.lugar_expedicion, lugar_nacimiento: @contratospersona.lugar_nacimiento, movil: @contratospersona.movil, nivel_educacion: @contratospersona.nivel_educacion, nombres: @contratospersona.nombres, numero_hijos: @contratospersona.numero_hijos, oficio: @contratospersona.oficio, registra_familiares: @contratospersona.registra_familiares, salario: @contratospersona.salario, seccion: @contratospersona.seccion, talla_camisa: @contratospersona.talla_camisa, talla_camisa: @contratospersona.talla_camisa, talla_pantalon: @contratospersona.talla_pantalon, talla_pantalon: @contratospersona.talla_pantalon, talla_zapatos: @contratospersona.talla_zapatos, talla_zapatos: @contratospersona.talla_zapatos, telefono: @contratospersona.telefono, tipo_contrato: @contratospersona.tipo_contrato, tipo_cuenta: @contratospersona.tipo_cuenta, tipo_identificacion: @contratospersona.tipo_identificacion, user_asignado: @contratospersona.user_asignado } }
    end

    assert_redirected_to contratospersona_url(Contratospersona.last)
  end

  test "should show contratospersona" do
    get contratospersona_url(@contratospersona)
    assert_response :success
  end

  test "should get edit" do
    get edit_contratospersona_url(@contratospersona)
    assert_response :success
  end

  test "should update contratospersona" do
    patch contratospersona_url(@contratospersona), params: { contratospersona: { activo: @contratospersona.activo, apellidos: @contratospersona.apellidos, area: @contratospersona.area, autobuscar: @contratospersona.autobuscar, banco: @contratospersona.banco, cargo: @contratospersona.cargo, ciudad: @contratospersona.ciudad, consignar: @contratospersona.consignar, contrato_id: @contratospersona.contrato_id, correo: @contratospersona.correo, cuenta_bancolombia: @contratospersona.cuenta_bancolombia, direccion: @contratospersona.direccion, eps: @contratospersona.eps, estado_civil: @contratospersona.estado_civil, estrato: @contratospersona.estrato, etapa: @contratospersona.etapa, fecha_expedicion: @contratospersona.fecha_expedicion, fecha_fin: @contratospersona.fecha_fin, fecha_ingreso: @contratospersona.fecha_ingreso, fecha_nacimiento: @contratospersona.fecha_nacimiento, fecha_periodo_prueba: @contratospersona.fecha_periodo_prueba, fecha_retiro: @contratospersona.fecha_retiro, fondo_pension: @contratospersona.fondo_pension, genero: @contratospersona.genero, grupo_nomina: @contratospersona.grupo_nomina, identificacion: @contratospersona.identificacion, lugar_expedicion: @contratospersona.lugar_expedicion, lugar_nacimiento: @contratospersona.lugar_nacimiento, movil: @contratospersona.movil, nivel_educacion: @contratospersona.nivel_educacion, nombres: @contratospersona.nombres, numero_hijos: @contratospersona.numero_hijos, oficio: @contratospersona.oficio, registra_familiares: @contratospersona.registra_familiares, salario: @contratospersona.salario, seccion: @contratospersona.seccion, talla_camisa: @contratospersona.talla_camisa, talla_camisa: @contratospersona.talla_camisa, talla_pantalon: @contratospersona.talla_pantalon, talla_pantalon: @contratospersona.talla_pantalon, talla_zapatos: @contratospersona.talla_zapatos, talla_zapatos: @contratospersona.talla_zapatos, telefono: @contratospersona.telefono, tipo_contrato: @contratospersona.tipo_contrato, tipo_cuenta: @contratospersona.tipo_cuenta, tipo_identificacion: @contratospersona.tipo_identificacion, user_asignado: @contratospersona.user_asignado } }
    assert_redirected_to contratospersona_url(@contratospersona)
  end

  test "should destroy contratospersona" do
    assert_difference('Contratospersona.count', -1) do
      delete contratospersona_url(@contratospersona)
    end

    assert_redirected_to contratospersonas_url
  end
end
