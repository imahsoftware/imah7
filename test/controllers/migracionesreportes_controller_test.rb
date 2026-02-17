require 'test_helper'

class MigracionesreportesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @migracionesreporte = migracionesreportes(:one)
  end

  test "should get index" do
    get migracionesreportes_url
    assert_response :success
  end

  test "should get new" do
    get new_migracionesreporte_url
    assert_response :success
  end

  test "should create migracionesreporte" do
    assert_difference('Migracionesreporte.count') do
      post migracionesreportes_url, params: { migracionesreporte: { ano_grado_colegio: @migracionesreporte.ano_grado_colegio, barrio: @migracionesreporte.barrio, caus_virtual: @migracionesreporte.caus_virtual, ciudad_csu: @migracionesreporte.ciudad_csu, ciudad_res: @migracionesreporte.ciudad_res, cli_nombre_comp: @migracionesreporte.cli_nombre_comp, cli_numdcto: @migracionesreporte.cli_numdcto, cod_jornada: @migracionesreporte.cod_jornada, cod_programa: @migracionesreporte.cod_programa, consecutivo: @migracionesreporte.consecutivo, correo_institucional: @migracionesreporte.correo_institucional, correo_personal: @migracionesreporte.correo_personal, departamento: @migracionesreporte.departamento, departamento_csu: @migracionesreporte.departamento_csu, depto: @migracionesreporte.depto, depto_conca: @migracionesreporte.depto_conca, direccion: @migracionesreporte.direccion, edad: @migracionesreporte.edad, est_codigo: @migracionesreporte.est_codigo, est_sem_academico2: @migracionesreporte.est_sem_academico2, est_sem_academico: @migracionesreporte.est_sem_academico, est_sem_aprobado: @migracionesreporte.est_sem_aprobado, estado_csu: @migracionesreporte.estado_csu, estado_liq: @migracionesreporte.estado_liq, extrae_ta: @migracionesreporte.extrae_ta, facultad: @migracionesreporte.facultad, fecha_generacion: @migracionesreporte.fecha_generacion, fecha_pago: @migracionesreporte.fecha_pago, genero: @migracionesreporte.genero, grupo_virtual: @migracionesreporte.grupo_virtual, identificacion: @migracionesreporte.identificacion, jornada: @migracionesreporte.jornada, liquidacion: @migracionesreporte.liquidacion, max_periodo_matric: @migracionesreporte.max_periodo_matric, metodologia: @migracionesreporte.metodologia, niv_formacion2: @migracionesreporte.niv_formacion2, niv_formacion: @migracionesreporte.niv_formacion, nivel_academico: @migracionesreporte.nivel_academico, nombre_csu: @migracionesreporte.nombre_csu, periodo_liq: @migracionesreporte.periodo_liq, periodo_real: @migracionesreporte.periodo_real, persona_id: @migracionesreporte.persona_id, programa: @migracionesreporte.programa, programa_ajustado: @migracionesreporte.programa_ajustado, promedio_acumulado: @migracionesreporte.promedio_acumulado, promedio_semestre: @migracionesreporte.promedio_semestre, red: @migracionesreporte.red, region_csu: @migracionesreporte.region_csu, seccional2: @migracionesreporte.seccional2, seccional: @migracionesreporte.seccional, semestre_pensum: @migracionesreporte.semestre_pensum, telefono_movil: @migracionesreporte.telefono_movil, telefono_residencia: @migracionesreporte.telefono_residencia, tip_estudiante: @migracionesreporte.tip_estudiante, tip_estudianteti: @migracionesreporte.tip_estudianteti, tipo_aspirante2: @migracionesreporte.tipo_aspirante2, tipo_aspirante: @migracionesreporte.tipo_aspirante, tipo_csu: @migracionesreporte.tipo_csu, transferencias_internas: @migracionesreporte.transferencias_internas, user_id: @migracionesreporte.user_id, valor_liq: @migracionesreporte.valor_liq, valor_matricula: @migracionesreporte.valor_matricula } }
    end

    assert_redirected_to migracionesreporte_url(Migracionesreporte.last)
  end

  test "should show migracionesreporte" do
    get migracionesreporte_url(@migracionesreporte)
    assert_response :success
  end

  test "should get edit" do
    get edit_migracionesreporte_url(@migracionesreporte)
    assert_response :success
  end

  test "should update migracionesreporte" do
    patch migracionesreporte_url(@migracionesreporte), params: { migracionesreporte: { ano_grado_colegio: @migracionesreporte.ano_grado_colegio, barrio: @migracionesreporte.barrio, caus_virtual: @migracionesreporte.caus_virtual, ciudad_csu: @migracionesreporte.ciudad_csu, ciudad_res: @migracionesreporte.ciudad_res, cli_nombre_comp: @migracionesreporte.cli_nombre_comp, cli_numdcto: @migracionesreporte.cli_numdcto, cod_jornada: @migracionesreporte.cod_jornada, cod_programa: @migracionesreporte.cod_programa, consecutivo: @migracionesreporte.consecutivo, correo_institucional: @migracionesreporte.correo_institucional, correo_personal: @migracionesreporte.correo_personal, departamento: @migracionesreporte.departamento, departamento_csu: @migracionesreporte.departamento_csu, depto: @migracionesreporte.depto, depto_conca: @migracionesreporte.depto_conca, direccion: @migracionesreporte.direccion, edad: @migracionesreporte.edad, est_codigo: @migracionesreporte.est_codigo, est_sem_academico2: @migracionesreporte.est_sem_academico2, est_sem_academico: @migracionesreporte.est_sem_academico, est_sem_aprobado: @migracionesreporte.est_sem_aprobado, estado_csu: @migracionesreporte.estado_csu, estado_liq: @migracionesreporte.estado_liq, extrae_ta: @migracionesreporte.extrae_ta, facultad: @migracionesreporte.facultad, fecha_generacion: @migracionesreporte.fecha_generacion, fecha_pago: @migracionesreporte.fecha_pago, genero: @migracionesreporte.genero, grupo_virtual: @migracionesreporte.grupo_virtual, identificacion: @migracionesreporte.identificacion, jornada: @migracionesreporte.jornada, liquidacion: @migracionesreporte.liquidacion, max_periodo_matric: @migracionesreporte.max_periodo_matric, metodologia: @migracionesreporte.metodologia, niv_formacion2: @migracionesreporte.niv_formacion2, niv_formacion: @migracionesreporte.niv_formacion, nivel_academico: @migracionesreporte.nivel_academico, nombre_csu: @migracionesreporte.nombre_csu, periodo_liq: @migracionesreporte.periodo_liq, periodo_real: @migracionesreporte.periodo_real, persona_id: @migracionesreporte.persona_id, programa: @migracionesreporte.programa, programa_ajustado: @migracionesreporte.programa_ajustado, promedio_acumulado: @migracionesreporte.promedio_acumulado, promedio_semestre: @migracionesreporte.promedio_semestre, red: @migracionesreporte.red, region_csu: @migracionesreporte.region_csu, seccional2: @migracionesreporte.seccional2, seccional: @migracionesreporte.seccional, semestre_pensum: @migracionesreporte.semestre_pensum, telefono_movil: @migracionesreporte.telefono_movil, telefono_residencia: @migracionesreporte.telefono_residencia, tip_estudiante: @migracionesreporte.tip_estudiante, tip_estudianteti: @migracionesreporte.tip_estudianteti, tipo_aspirante2: @migracionesreporte.tipo_aspirante2, tipo_aspirante: @migracionesreporte.tipo_aspirante, tipo_csu: @migracionesreporte.tipo_csu, transferencias_internas: @migracionesreporte.transferencias_internas, user_id: @migracionesreporte.user_id, valor_liq: @migracionesreporte.valor_liq, valor_matricula: @migracionesreporte.valor_matricula } }
    assert_redirected_to migracionesreporte_url(@migracionesreporte)
  end

  test "should destroy migracionesreporte" do
    assert_difference('Migracionesreporte.count', -1) do
      delete migracionesreporte_url(@migracionesreporte)
    end

    assert_redirected_to migracionesreportes_url
  end
end
