namespace :coquetin do

  # --------------------------------------------------------------------------------------------------------------
  # Trasnmision de obligaciones
  # --------------------------------------------------------------------------------------------------------------

  task checkusers: :environment do
    User.checkuser
  end

  task download: :environment do
    #Solo para los errores
    nmPortafolio = ENV['p']
    nmIsAdmin = ENV['a']
    nmConse = ENV['c']
    vcProceso = ENV['r']
    Proceso.download(nmPortafolio, nmIsAdmin, nmConse, vcProceso)
  end

  # rake coquetin:enviodian a=1 b=13 c=24 d=16
  task enviodian: :environment do
    nmPortafolio = ENV['a']
    nmPeriodo = ENV['b']
    contrato = ENV['c']
    contratogrupo = ENV['d']
    WsController.enviar_nomina(nmPortafolio, nmPeriodo, contrato, contratogrupo)
  end

  # rake coquetin:enviodian a=1 b=13 c=24 d=16
  task enviodianbyperiodo: :environment do
    puts "Iniciando desde el rake Fase 1"
    Objeto.find_by_sql("SELECT p.periodosliquidacion_id,p.contrato_id,e.logo,e.portafolio_id,p.contratosgrupo_id,COUNT(9)
                        FROM  contratospernominas p,empresas e, contratos c
                        WHERE p.periodosliquidacion_id IN (SELECT id FROM periodosliquidaciones 
                                                           WHERE inicio >= '2024-04-01' AND fin <= '2025-06-30' ORDER BY inicio ASC)
                        AND   p.contrato_id = c.id
                        AND   c.empresa_id = e.id
                        AND   p.alegra_id IS NULL
                        GROUP BY p.periodosliquidacion_id,p.contrato_id,e.logo,p.contratosgrupo_id").each do |s|
      nmPortafolio = s.portafolio_id
      nmPeriodo = s.periodosliquidacion_id
      contrato = s.contrato_id
      contratogrupo = s.contratosgrupo_id
      puts "Iniciando desde el rake " + nmPortafolio.to_s + ' - ' + nmPeriodo.to_s + ' - ' + contrato.to_s + ' - ' + contratogrupo.to_s
      WsAlegraController.enviar_nomina(nmPortafolio, nmPeriodo, contrato, contratogrupo)
    end
  end

  task enviodianprogramado: :environment do
    Ejecucion.where("estado = 'PENDIENTE' and tipo = 'DIAN'").each do |s|
      Objeto.find_by_sql("SELECT p.periodosliquidacion_id,p.contrato_id,e.portafolio_id,p.contratosgrupo_id,COUNT(9)
                          FROM  contratospernominas p,empresas e, contratos c, periodosliquidaciones l
                          WHERE p.periodosliquidacion_id = #{s.periodosliquidacion_id}
                          AND   p.contrato_id = c.id
                          AND   c.empresa_id = e.id AND p.periodosliquidacion_id = l.id
                          AND   l.estado = 'C'
                          AND   p.estado = 'CONSOLIDADO'
                          AND   p.alegra_id IS NULL
                          GROUP BY p.periodosliquidacion_id,p.contrato_id,e.portafolio_id,p.contratosgrupo_id").each do |p|
        nmPortafolio = p.portafolio_id
        nmPeriodo = p.periodosliquidacion_id
        contrato = p.contrato_id
        contratogrupo = p.contratosgrupo_id
        WsAlegraController.enviar_nomina(nmPortafolio, nmPeriodo, contrato, contratogrupo)
      end
      s.update(estado: 'ENVIADO', updated_at: Time.now)
    end
  end

  task envioaportesprogramado: :environment do
    Ejecucion.where("estado = 'PENDIENTE' and tipo = 'APORTES'").each do |s|
      Objeto.find_by_sql("SELECT p.periodosliquidacion_id,p.contrato_id,e.portafolio_id,p.contratosgrupo_id,COUNT(9)
                          FROM  contratospernominas p,empresas e, contratos c
                          WHERE p.periodosliquidacion_id = #{s.periodosliquidacion_id}
                          AND   p.contrato_id = c.id
                          AND   c.empresa_id = e.id
                          GROUP BY p.periodosliquidacion_id,p.contrato_id,e.portafolio_id,p.contratosgrupo_id").each do |p|
        nmPortafolio = p.portafolio_id
        nmPeriodo = p.periodosliquidacion_id
        contrato = p.contrato_id
        contratogrupo = p.contratosgrupo_id
        WsAlegraController.creacion_masiva_novedades(nmPortafolio, nmPeriodo, contrato, contratogrupo)
      end
      s.update(estado: 'ENVIADO')
    end
  end

  task envioaporte: :environment do
    ActiveRecord::Base.connection.execute("CALL prc_dashcontratos")
    idprocesamiento = Time.now.strftime("%Y%m%d%H%M%S").to_s
    if Ejecucion.where("estado = 'PENDIENTE' and tipo = 'APORTESENLINEA' and idprocesamiento is null").exists?
      Ejecucion.where(["estado = 'PENDIENTE' and tipo = 'APORTESENLINEA' and idprocesamiento is null"]).update_all(idprocesamiento: idprocesamiento)
      Ejecucion.where("estado = 'PENDIENTE' and tipo = 'APORTESENLINEA' and idprocesamiento = '#{idprocesamiento}'").each do |e|
        Ejecucion.where(["id  = #{e.id}"]).update_all(estado: 'EN EJECUCION', inicioejecucion: Time.now)
        begin
          execute = e.controlador_metodo.to_s
          eval(execute)
          Ejecucion.where(["id  = #{e.id}"]).update_all(estado: 'EXITOSO', finejecucion: Time.now)
        rescue Exception => ex
          Ejecucion.where(["id  = #{e.id}"]).update_all(estado: 'ERROR', observacion: ex.message[0..995].to_s, finejecucion: Time.now)
        end
      end
    end
  end

  task enviocorreo: :environment do
    idprocesamiento = Time.now.strftime("%Y%m%d%H%M%S").to_s
    if Ejecucion.where("estado = 'PENDIENTE' and tipo in ('ENVIO CORREO','ENVIO SMS') and idprocesamiento is null and created_at <= now()").exists?
      Ejecucion.where(["estado = 'PENDIENTE' and tipo in ('ENVIO CORREO','ENVIO SMS') and idprocesamiento is null and created_at <= now()"]).update_all(idprocesamiento: idprocesamiento)
      Ejecucion.where("estado = 'PENDIENTE' and tipo in ('ENVIO CORREO','ENVIO SMS') and idprocesamiento = '#{idprocesamiento}' and created_at <= now()").each do |e|
        Ejecucion.where(["id  = #{e.id}"]).update_all(estado: 'EN EJECUCION', inicioejecucion: Time.now)
        begin
          execute = e.controlador_metodo.to_s
          eval(execute)
          Ejecucion.where(["id  = #{e.id}"]).update_all(estado: 'EXITOSO', finejecucion: Time.now)
        rescue Exception => ex
          Ejecucion.where(["id  = #{e.id}"]).update_all(estado: 'ERROR', observacion: ex.message[0..995].to_s, finejecucion: Time.now)
        end
      end
    end
    #if ['08','10','12','14','16','18','20','22'].include?(Time.now.strftime("%H").to_s)
    #  ActiveRecord::Base.connection.execute("CALL prc_personasformvalida();")
    #end
  end

  task update_dash: :environment do
    ContratosactnovedadesController.rake_dash_seguimientos
  end

  task mantenimiento: :environment do
    ActiveRecord::Base.connection.execute("CALL prc_mantenimiento();")
    ActiveRecord::Base.connection.execute("CALL prc_personasformvalida();")
  end

  task mantenimientoespecial: :environment do
    ActiveRecord::Base.connection.execute("CALL prc_mantenimientoespecial();")
  end

  task activanuevoemp: :environment do
    ActiveRecord::Base.connection.execute("CALL prc_mantenimientonuevo();")
  end

  task update_dash_nodo: :environment do
    ContratosactnovedadesController.rake_dash_seguimientosnodos
  end

  task alegra: :environment do
    if ['06','07','08','09','10'].include?(Time.now.strftime("%d").to_s)
      ContratospernominasController.rake_alegra
    end
  end

  task notificacioncontrato: :environment do
    if Time.now.strftime("%u").to_i < 7
      Objeto.find_by_sql("SELECT distinct 'X'
                          FROM   contratos c, empresas e, portafolios p
                          WHERE  c.`empresa_id` = e.id
                          AND    c.estado = 'EN EJECUCION'
                          and    (CASE WHEN c.fechamasmodi IS NOT NULL THEN c.fechamasmodi ELSE c.fecha_fin END) >= '2023-11-01'
                          AND    e.`portafolio_id` = p.id
                          AND    CURDATE() >= DATE_ADD((CASE WHEN c.fechamasmodi IS NOT NULL THEN c.fechamasmodi ELSE c.fecha_fin END), INTERVAL -25 DAY)").each do |p|
        Iparametrosuser.select("user_id, (select email from users where id = iparametrosusers.user_id) email").where(iparametro_id: 2179).each do |a|
          puts "Enviado al email...." +  a.email.to_s
          response = Asearmail::SendmailServices.new.general(a.email.to_s,
                                                              "Notificacion vencimiento de Contratos Asear S.A.S. E.S.P",
                                                              "asear_mailer/contratos.html.erb", nil, nil,
                                                              a.user_id)
          puts "Enviado.. con la siguiente respuesta... " + response.status_code.to_s
        end
      end
    end
  end

  task notificacionmonday: :environment do
    if Time.now.strftime("%u").to_i < 7
      Objeto.find_by_sql("SELECT DISTINCT d.user_persona user_id, u.email
                          FROM   tareas t, tareasactividades d, users u
                          WHERE  t.estado ='ACTIVO'
                          AND    t.id = d.tarea_id
                          AND    d.estado not in ('1.0','1')
                          AND    d.user_persona = u.id").each do |p|
          puts "Enviado al email...." +  p.email.to_s
          response = Asearmail::SendmailServices.new.general(p.email.to_s,
                                                             "Week - Actividades Pendientes",
                                                             "asear_mailer/monday.html.erb", nil, nil,
                                                             p.user_id)
          puts "Enviado.. con la siguiente respuesta... " + response.status_code.to_s
      end
    end
  end

  task notificacionvisita: :environment do
    if Time.now.strftime("%u").to_i < 7
      dato = Parametro.find(9).valor.to_s
      Objeto.find_by_sql("select id user_id, email from users where id in (#{dato})").each do |p|
        puts "Enviado al email...." +  p.email.to_s
        response = Asearmail::SendmailServices.new.general(p.email.to_s,
                                                           "Visitas - Seguimiento",
                                                           "asear_mailer/visitas.html.erb", nil, nil,
                                                           p.user_id)
        puts "Enviado.. con la siguiente respuesta... " + response.status_code.to_s
      end
      dato = Parametro.find(23).valor.to_s
      Objeto.find_by_sql("select id user_id, email from users where id in (#{dato})").each do |p|
        puts "Enviado al email...." +  p.email.to_s
        response = Asearmail::SendmailServices.new.general(p.email.to_s,
                                                           "Visitas - Seguimiento",
                                                           "asear_mailer/visitas_super.html.erb", nil, nil,
                                                           p.user_id)
        puts "Enviado.. con la siguiente respuesta... " + response.status_code.to_s
      end
    end
  end

  task notificacionvisitanocerrada: :environment do
    Objeto.find_by_sql("SELECT p.nombre_completo, p.movil
                        FROM   visitas v, users u, contratospersonas p
                        WHERE  v.finalizacion IS NULL
                        AND    v.user_id = u.id
                        AND    u.contratospersona_id = p.id").each do |p|
      mensaje = "ASEAR: Estimad@ #{p.nombre_completo}, pilas tienes visitas sin Cerrar".html_safe
      Asearsms::SendsmsServices.new.send_sms_procesos(p.movil, mensaje)
    end
  end

  task notificacionvisitanocerrada2: :environment do
    Objeto.find_by_sql("SELECT p.nombre_completo, p.movil
                        FROM   visitas v, users u, contratospersonas p
                        WHERE  v.finalizacion IS NULL
                        AND    v.user_id = u.id
                        AND    u.contratospersona_id = p.id").each do |p|
      mensaje = "ASEAR: Estimad@ #{p.nombre_completo}, te recuerdo nuevamente que tienes visitas sin Cerrar, hazlo ya!".html_safe
      Asearsms::SendsmsServices.new.send_sms_procesos(p.movil, mensaje)
    end
  end

  task notificacionvisitanocerrada3: :environment do
    dato = Parametro.find(9).valor.to_s
    Objeto.find_by_sql("select id user_id, email from users where id in (#{dato})").each do |p|
      puts "Enviado al email...." +  p.email.to_s
      response = Asearmail::SendmailServices.new.general(p.email.to_s,
                                                         "Visitas - No CERRADAS",
                                                         "asear_mailer/visitasnocerradas.html.erb", nil, nil,
                                                         p.user_id)
      puts "Enviado.. con la siguiente respuesta... " + response.status_code.to_s
    end
  end

  task visitascierre: :environment do
    ActiveRecord::Base.connection.execute("CALL prc_visitascierre()")
  end

  task contratosnofirmados: :environment do
    if Time.now.strftime("%u").to_i < 7
      Objeto.find_by_sql("SELECT distinct 'X'
                          FROM   contratosperfechas
                          WHERE  fecha_inicio >= '2024-01-01'
                          and    (sol_firma_digital = 'SI' or sol_firma_digital is null) AND estado = 'ACTIVO' AND (fecha_fin IS NULL OR fecha_fin >= CURDATE())").each do |p|
        Iparametrosuser.select("user_id, (select email from users where id = iparametrosusers.user_id) email").where(iparametro_id: 2310).each do |a|
          puts "Enviado al email...." +  a.email.to_s
          response = Asearmail::SendmailServices.new.general(a.email.to_s,
                                                             "Notificacion Contratos SIN FIRMAR",
                                                             "asear_mailer/contratosnofirmados.html.erb", nil, nil,
                                                             a.user_id)
          puts "Enviado.. con la siguiente respuesta... " + response.status_code.to_s
        end
      end
    end
  end

  task visitasininiciar: :environment do
    if Time.now.strftime("%u").to_i < 7
      #Objeto.find_by_sql("SELECT nombre, celular
      #                    FROM   users
      #                    WHERE  id not in (5870) and tipoconsulta = 'SUPERVISOR' AND id IN (SELECT DISTINCT user_id FROM userspermisos WHERE objeto_id = 129)
      #                    AND    contratospersona_id IN (SELECT DISTINCT contratospersona_id FROM contratosperfechas WHERE estado = 'ACTIVO')
      #                    and    id not in (select distinct user_id from visitas where DATE_FORMAT(created_at, '%Y-%m-%d') = DATE_FORMAT(now(), '%Y-%m-%d'))").each do |p|
      Objeto.find_by_sql("SELECT nombre, celular
                          FROM   users
                          WHERE  id in (SELECT user_id FROM view_supervisores)
                          and    id not in (select distinct user_id from visitas where DATE_FORMAT(created_at, '%Y-%m-%d') = DATE_FORMAT(now(), '%Y-%m-%d'))").each do |p|
        mensaje = "ASEAR: Estimad@ #{p.nombre}, no has iniciado visita hoy, que paso?, hazlo ya!".html_safe
        Asearsms::SendsmsServices.new.send_sms_procesos(p.celular, mensaje)
      end
    end
  end

  task personascontrato: :environment do
    if Time.now.strftime("%u").to_i < 7
      Objeto.find_by_sql("SELECT distinct 'X'
                          FROM   contratosperfechas
                          WHERE  fecha_fin >= CURDATE() AND estado = 'ACTIVO'
                          AND    fecha_fin >= DATE_ADD(CURDATE(), INTERVAL 5 DAY)
                          AND    fecha_fin <= DATE_ADD(CURDATE(), INTERVAL 30 DAY)").each do |p|
        Iparametrosuser.select("user_id, (select email from users where id = iparametrosusers.user_id) email").where(iparametro_id: 2310).each do |a|
          puts "Enviado al email...." +  a.email.to_s
          response = Asearmail::SendmailServices.new.general(a.email.to_s,
                                                             "Notificacion Contratos con proximos vencimientos",
                                                             "asear_mailer/personascontrato.html.erb", nil, nil,
                                                             a.user_id)
          puts "Enviado.. con la siguiente respuesta... " + response.status_code.to_s
        end
      end
    end
  end

  task notificacionterminacion: :environment do
    Objeto.find_by_sql("SELECT distinct fecha_aprobacion
                        FROM   solicitudesretiros
                        WHERE  fecha_aprobacion = DATE_ADD(CURDATE(), INTERVAL -1 DAY)").each do |p|
      Iparametrosuser.select("user_id, (select email from users where id = iparametrosusers.user_id) email").where(iparametro_id: 2310).each do |a|
        puts "Enviado al email...." +  a.email.to_s
        response = Asearmail::SendmailServices.new.general(a.email.to_s,
                                                           "Terminaciones del dia #{p.fecha_aprobacion.to_s}",
                                                           "asear_mailer/terminaciones.html.erb", nil, nil,
                                                           a.user_id)
        puts "Enviado.. con la siguiente respuesta... " + response.status_code.to_s
      end
    end
  end

  task notificaciondotacion: :environment do
    Objeto.find_by_sql("SELECT distinct 'X'
                        FROM   contratosperdotaciones
                        WHERE  estado = 'ENTREGADO'").each do |p|
      Iparametrosuser.select("user_id, (select email from users where id = iparametrosusers.user_id) email").where(iparametro_id: 2558).each do |a|
        puts "Enviado al email...." +  a.email.to_s
        response = Asearmail::SendmailServices.new.general(a.email.to_s,
                                                           "Dotaciones entregadas no Firmadas",
                                                           "asear_mailer/dotaciones.html.erb", nil, nil,
                                                           a.user_id)
        puts "Enviado.. con la siguiente respuesta... " + response.status_code.to_s
      end
    end
  end

  task generaciontirillas: :environment do
    ContratospernominasController.downloadtirilla
  end

  task generaciondotacion: :environment do
    ContratosperdotacionesController.carta_dotacionesp
  end

  task generaciontirillas2: :environment do
    ContratospernominasController.downloadtirilla2
  end

  task generacionliquidaciones: :environment do
    #ContratospernominasController.liquidacionesmasivas
    ContratospernominasController.liquidacionesmasivassolocomprobante
  end

  task predownloadactivos: :environment do
    DatasController.predownloadactivos
  end

end