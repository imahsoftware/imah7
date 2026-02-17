class MenusController < ApplicationController
  layout :set_layout
  # before_action :verificardatos, if: :user_signed_in?
  before_action :validatesession
  before_action :authenticate_user!, except: [:consultaexterna, :consultaliq, :cartapresentacion, :search_contrato, :search_contratopre, :search_contratoliq]

  def consultaexterna

  end

  require 'rqrcode'

  def show_detalle_contratos
    @ruta = params[:ruta]
    @consultarallconv = params[:consultarallconv]
    @estado = params[:estado]
    @contrato = Contrato.find(params[:contrato_id])
    @contratoparams = @estado.downcase.gsub(" ",'_')
    @is_auth_c_contratacionaprobar =  params[:is_auth_c_contratacionaprobar]

    isadmin = is_admin
    user_asignado = -1
    if Personasformulario.where("(user_asignado = #{isadmin} or user_asignado2 = #{isadmin} or user_asignado3 = #{isadmin} or user_asignado4 = #{isadmin} or user_asignado5 = #{isadmin})").present?
      user_asignado = isadmin
    end
    if is_auth_c("consultarallconv")
      user_asignado = -1
    end
    @personasformularios = nil

    if user_asignado == -1
      sqlAdd = ""
      if @estado.to_s == 'CONTRATACION'
        sqlAdd = " and (id in (select distinct personasformulario_id from contratosperfechas where codigo_firma is null and personasformulario_id is not null)
                       or id not in (select distinct personasformulario_id from contratosperfechas where estado = 'ACTIVO' AND personasformulario_id is not null))"
      end
      @personasformularios = Personasformulario.select("personasformularios.*, (select descripcion from parcargos where id = personasformularios.parcargo_id) cargo_descripcion,
                                                       (select username from users where id = personasformularios.user_id ) username,
                                                       (select id from contratospersonas where identificacion = personasformularios.identificacion limit 1 ) idpersona,
                                                       (select distinct 'X' from contratosperfechas where codigo_firma is not null and estado = 'ACTIVO' and contratospersona_id = (select id from contratospersonas where identificacion = personasformularios.identificacion limit 1 )) idvalidacioncontratocreado")
                                               .where("estado = '#{@estado}'").paginate(:page => params[:page], :per_page => 15).order("id desc")
      puts 'Aiooooooo Fabian'
    else
      @personasformularios = Personasformulario.select("personasformularios.*, (select descripcion from parcargos where id = personasformularios.parcargo_id) cargo_descripcion,
                                                       (select username from users where id = personasformularios.user_id ) username,
                                                       (select id from contratospersonas where identificacion = personasformularios.identificacion limit 1 ) idpersona,
                                                       (select distinct 'X' from contratosperfechas where codigo_firma is not null and estado = 'ACTIVO' and contratospersona_id = (select id from contratospersonas where identificacion = personasformularios.identificacion limit 1 )) idvalidacioncontratocreado")
                                               .where("estado = '#{@estado}' and (user_asignado = #{user_asignado} or user_asignado2 = #{user_asignado} or user_asignado3 = #{user_asignado} or user_asignado4 = #{user_asignado} or user_asignado5 = #{user_asignado})").paginate(:page => params[:page], :per_page => 15).order("id desc")
    end
  end

  def codigo_qr
    @user = current_user
    @secret = ROTP::Base32.random_base32
    @uri = "otpauth://totp/#{Rails.application.config.app_name}:#{@user.email}?secret=#{@secret}&issuer=#{Rails.application.config.app_name}"
    @qr = RQRCode::QRCode.new(@uri)
    session[:otp_secret] = @secret
  end

  def abrir_datos
    user = User.find(is_admin)
    if user.id != 15910 and user.id != 4561
      dato = Objeto.find_by_sql("SELECT DISTINCT 'X' existe FROM viw_consolidabloqueo WHERE user_id = #{user.id}")[0] rescue nil
    end
    if dato.present?
      flash[:warning] = 'Hola!!! Para donde vas si no has terminado los temas pendientes'
      redirect_to root_path
    else
      @contratospersona = Contratospersona.where("identificacion = '#{user.identificacion}'").first rescue nil
    end
  end

  def consultaliq
  end

  def cartapresentacion
  end

  def observacion_salud
    @contratospernota = Contratospernota.new
    @contratosperfecha = Contratosperfecha.find(params[:id])
    @contratospersona = @contratosperfecha.contratospersona
    @tipo = params[:tipo]
    @estado = params[:estado]
  end

  def search_contrato
    #@contratosperfechas = Contratosperfecha.where("contratospersona_id in (SELECT id FROM contratospersonas WHERE identificacion = '#{params[:documento]}') AND estado = 'ACTIVO'").paginate(:page => params[:page], :per_page => 10).order("id desc")
    @contratosperfechas = Contratosperfecha.where("codigo_firma = '#{params[:documento]}'").paginate(:page => params[:page], :per_page => 10).order("id desc")
  end

  def search_contratopre
    @contratosperfechas = Contratosperfecha.where("contratospersona_id in (SELECT id FROM contratospersonas WHERE identificacion = '#{params[:documento]}') AND estado = 'ACTIVO'").paginate(:page => params[:page], :per_page => 10).order("id desc")
  end

  def search_contratoliq
    @contratosperfechas = Contratosperfecha.select("contratosperfechas.*, (select distinct contratosperliquidacion_id from solicitudesretiros where contratosperfecha_id = contratosperfechas.id and estado_final = 'PAGADO' and fecha_final is not null) idliquidacion")
                            .where("contratospersona_id in (SELECT id FROM contratospersonas WHERE identificacion = '#{params[:documento]}' and fecha_nacimiento = '#{params[:fecha_nac].to_date}')").order("id desc")
  end

  def menu
  end

  def show_detalle
    @ruta = params[:ruta]
    @consecutivo = params[:eproveedor_id]
    @datosobj = Eproveedorescompra.select(["eproveedorescompras.*, (select distinct egreso_id from egresosdetalles where eproveedorescompra_id = eproveedorescompras.id limit 1) egresoId,
                                          IFNULL((select sum(valor) from eproveedorescompretenciones where eproveedorescompra_id = eproveedorescompras.id),0) valorretencion,
                                          (select distinct 'X' from eproveedorescimagenes where eproveedorescompra_id = eproveedorescompras.id) existeimagen"])
                                  .includes([:user, :portafolio])
                                  .where(eproveedor_id: @consecutivo, estado: 'PENDIENTE')
                                  .order(fecha: :desc)
    @datos = @datosobj.paginate(:page => params[:page], :per_page => 20)
  end

  def show_detallef
    @ruta = params[:ruta]
    @consecutivo = params[:contrato_id]
    @estado = params[:estado]
    @datos = Contratosprefactura.joins(:contrato)
                                .select("contratosprefacturas.*, (select autobuscar from empresas where id = contratos.empresa_id) identnombre")
                                .where(contrato_id: @consecutivo, estado: @estado)
                                .order("contratosprefacturas.id desc")
  end

  def show_detalles
    @ruta = params[:ruta]
    @consecutivo = params[:periodo]
    @estado = params[:estado]
    @datos = Contratossolicitud.joins(:contrato)
                               .select("contratossolicitudes.*, (select nombre from empresas where id = contratos.empresa_id) identnombre, contratos.nro_contrato, (select concat(nombre,' - ',email) from users where id = contratossolicitudes.user_id) usernombre")
                               .where(periodo: @consecutivo, estado: @estado)
                               .order("contratossolicitudes.id desc")
  end

  def show_detalles_epp
    @ruta = params[:ruta]
    @consecutivo = params[:periodo]
    @estado = params[:estado]
    @datos = Contratossolepp.joins(:contrato)
                            .select("contratossolepps.*,
                                 empresas.nombre AS identnombre,
                                 contratos.nro_contrato,
                                 CONCAT(users.nombre, ' - ', users.email) AS usernombre")
                            .joins("INNER JOIN empresas ON empresas.id = contratos.empresa_id")
                            .joins("INNER JOIN users ON users.id = contratossolepps.user_id")
                            .where("DATE_FORMAT(contratossolepps.created_at, '%Y-%m') = ?", @consecutivo)
                            .where("contratossolepps.estado = ?", @estado)
                            .order("contratossolepps.id DESC")
  end

  def verificardatos
    if User.find(is_admin).sign_in_count == 1
      redirect_to edit_user_registration_path
      flash[:warning] = 'Por favor actualiza tus datos'
    end
  end

  def aceptartratamiento
    @user = User.find(is_admin)
    @user.autotratamiento_fecha = Time.now
    @user.autotratamiento_ip = @user.current_sign_in_ip
    @user.save(validate: false)
    redirect_to root_path
  end

  def validatesession
    if current_user
      idc = cookies.signed[:user_id]
      usernamec = cookies.signed[:username]
      if idc.to_s == "" and usernamec.to_s == ""
        redirect_to logout_path
      elsif idc != current_user.id and usernamec != current_user.username
        redirect_to logout_path
      end
    end
  end

  def actividades
    isadmin = is_admin
    @usr = User.find(isadmin)
    @dayofweek = is_dayofweek
    contratossedereturn = params[:contratossedereturn].to_s rescue ""
    contratossede = params[:u][:c].to_s rescue ""
    if contratossede.to_s == ""
      if contratossedereturn.to_s != ""
        contratossede = contratossedereturn
      else
        contratossede = -1
      end
    end
    if @usr.tipoconsulta.to_s == 'METRO'
      dato = Contratosactcodigo.where(["user_id = #{@usr.id} and date(created_at) = curdate() and validacion = 1"]).select("contratossede_id, nodo, user_id").distinct[0] rescue nil
      dato2 = Contratosactmcodigo.where(["user_id = #{@usr.id} and date(created_at) = curdate() and validacion = 1"]).select("contratossede_id, nodo, user_id").distinct[0] rescue nil
      if dato
        flash[:danger] = "Hola... Aun no has terminado esta verificación"
        redirect_to edit_individual_contratosactcodigos_path(contratossede_id: dato.contratossede_id, nodo: dato.nodo, user_id: @usr.id)
      elsif dato2
        flash[:danger] = "Hola... Aun no has terminado esta verificación"
        redirect_to edit_individual_contratosactmcodigos_path(contratossede_id: dato2.contratossede_id, nodo: dato2.nodo, user_id: @usr.id)
      else
        @contratosedes = Contratossede.where(["id = #{contratossede} and contrato_id = #{@usr.contrato_id}"]).order("nombre")[0]
      end
    else
      @contratosedes = Contratosnodo.where(["id = #{contratossede} and contrato_id = #{@usr.contrato_id} and (clase_aseo = '#{@usr.clase_aseo.to_s}' or clase_aseo2 = '#{@usr.clase_aseo.to_s}' or clase_aseo3 = '#{@usr.clase_aseo.to_s}' or clase_aseo4 = '#{@usr.clase_aseo.to_s}' or clase_aseo5 = '#{@usr.clase_aseo.to_s}')"]).order("nombre")[0]
      if contratossede != -1
        @contratosacts = Contratosactividad.where(contrato_id: @contratosedes.contrato_id, clase: 'ASEO FUERTE', contratosnodo_id: @contratosedes.id, dia_semana: @dayofweek).order("turno,orden asc")
        @contratosactividades = Contratosactividad.where(["contrato_id = #{@usr.contrato_id} and clase = 'ASEO NORMAL' and tipo = '#{@usr.clase_aseo}' and contratosnodo_id = #{@contratosedes.id}
                                                           and  dia_semana in ('DIARIO','#{@dayofweek}')"]).order("turno, orden asc")
      end
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @contratosedes }
    end
  end

  def firmadigital
    isadmin = is_admin
    @usr = User.find(isadmin)
    if Contratosperfecha.where("contratospersona_id = (select id from contratospersonas where identificacion = '#{@usr.identificacion}') and sol_firma_digital = 'SI'").present?
      @existeContratoPendiente = 'SI'
    end
    if Controlfirma.where("estado = 'PENDIENTE' and user_firma = #{isadmin}").present?
      @existeContratoFirmaPendiente = 'SI'
    end
  end

  def index
    @ruta_paginador = ""
    isadmin = is_admin
    # Metodologia nueva de Dash con opciones en la parte izquierda
    idxObjetoId = params[:idob].to_s
    if idxObjetoId.present?
      ActiveRecord::Base.connection.execute("update users set objeto_id = #{idxObjetoId} where id = #{isadmin}")
    end
    @usr = User.find(isadmin)
    bloqueoporfirma = 'NO'
    bloqueoporcapa = 'NO'
    bloqueoporweek = 'NO'
    bloqueoporepp = 'NO'
    bloqueoporcapan = 'NO'
    validaVisita = 'NO'
    # 2024-04-04 Bloqueo por NO atencion de temas pendientes...
    if @usr.tipoconsulta.to_s == 'SUPERVISOR'
      if Parametro.find(19).valor.to_s == 'SI'
        if Objeto.find_by_sql("SELECT user_id FROM view_docsinfirmar WHERE user_id = #{@usr.id}").present?
          bloqueoporfirma = 'SI'
          puts "********** ingreso 1"
        end
      end
      if is_auth_c('excluir_primera_visita') == false
        if Objeto.find_by_sql("SELECT user_id FROM view_supervisores WHERE user_id = #{@usr.id}").present?
          if Visita.where(user_id: isadmin).where('DATE(created_at) = ?', Date.today).present? == false
            validaVisita = 'SI'
            puts "********** ingreso 2"
          end
        end
      end
    end
    if ['PERSONA', 'CANDIDATO', 'METRO','RECTOR','CONTRATO'].exclude?(@usr.tipoconsulta.to_s)
      if Parametro.where("id = 21 and valor = '#{@usr.id}'").present?
        contratossinfirmar = @contratossinfirmar_cantidad = Objeto.find_by_sql("select cantidad from view_contratossinfirmar")[0].cantidad rescue 0
        if contratossinfirmar.to_i > 0
          bloqueoporfirma = 'SI'
          puts "********** ingreso 3"
        end
      end
      if Objeto.find_by_sql("SELECT * FROM view_evaluacionesnorealizadas WHERE user_id = #{@usr.id}").present?
        bloqueoporcapa = 'SI'
        puts "********** ingreso 4"
      end
      if Objeto.find_by_sql("SELECT * FROM view_tareasactividades WHERE user_id = #{@usr.id}").present?
        bloqueoporweek = 'SI'
        puts "********** ingreso 5"
      end
      if Objeto.find_by_sql("SELECT * FROM view_eppsinfirmar WHERE user_id = #{@usr.id}").present?
        bloqueoporepp = 'SI'
        puts "********** ingreso 6"
      end
      if Objeto.find_by_sql("SELECT * FROM view_compromisossinatender WHERE user_id = #{@usr.id}").present?
        bloqueoporfirma = 'SI'
        puts "********** ingreso 7"
      end
      if Objeto.find_by_sql("SELECT * FROM view_dotacionsinfirmar WHERE user_id = #{@usr.id}").present?
        bloqueoporfirma = 'SI'
        puts "********** ingreso 8"
      end
      if Objeto.find_by_sql("SELECT * FROM view_dotacionsinrecoger WHERE user_id = #{@usr.id}").present?
        bloqueoporfirma = 'SI'
        puts "********** ingreso 9"
      end
      if Objeto.find_by_sql("SELECT * FROM view_capacitacionessinterminar WHERE user_id = #{@usr.id}").present?
        bloqueoporfirma = 'SI'
        puts "********** ingreso 10"
      end
    end

    contratospersonaId = -1
    if @usr.contratospersona_id.present?
      contratospersonaId = @usr.contratospersona_id
    end

    @validatAdm = ""
    @validat = ""
    @cadper = []
    @tipoconsulta = @usr.tipoconsulta.to_s
    @existeContratoPendiente = ""
    @existeContratoFirmaPendiente = ""

    #if @usr.id == 15910 or @usr.id == 4561 # 2025-05-02 regla especial solicitada por lilly
    if [4998,22117].include?(@usr.id)
      bloqueoporfirma = 'NO'
      bloqueoporcapa = 'NO'
      bloqueoporweek = 'NO'
      bloqueoporepp = 'NO'
      validaVisita = 'NO'
    end
    if [15910].include?(@usr.id)
      bloqueoporweek = 'NO'
    end

    if @usr.tipoconsulta.to_s == 'CANDIDATO'
      if Contratosperfecha.where("contratospersona_id = #{contratospersonaId} and sol_firma_digital = 'SI'").present?
        redirect_to controlfirmas_path
      elsif Controlfirma.where("estado = 'PENDIENTE' and user_firma = #{isadmin}").present?
        redirect_to controlfirmas_path
      else
        redirect_to registro_personasformularios_path(personasformulario_id: current_user.personasformulario_id)
      end
    else

      @procesos = Contratosperproceso.where("firma_usuario is null and contratospersona_id = #{contratospersonaId}") rescue nil
      @testigos1 = Contratosperproceso.where("firma_testigo1 is null and user_testigo1 = #{@usr.id}") rescue nil
      @testigos2 = Contratosperproceso.where("firma_testigo2 is null and user_testigo2 = #{@usr.id}") rescue nil

      if Contratosperdotacion.where("contratospersona_id = #{contratospersonaId} and estado = 'ENTREGADO'").present?
        redirect_to firmar_entrega_contratosperdotaciones_path(contratospersona_id: contratospersonaId)
      elsif Contratosperfecha.where("contratospersona_id = #{contratospersonaId} and sol_firma_digital = 'SI'").present?
        redirect_to controlfirmas_path
      elsif Controlfirma.where("estado = 'PENDIENTE' and user_firma = #{isadmin}").present?
        redirect_to controlfirmas_path
      elsif @procesos.present? or @testigos1.present? or @testigos2.present?
        redirect_to controlfirmas_path
      elsif Contratoscapapersona.where("estado_evaluacion = 'INICIAR CAPACITACION' and contratospersona_id = #{contratospersonaId}").present?
        redirect_to capacitacionesusuario_contratos_path(contratospersona_id: contratospersonaId)
      elsif validaVisita == 'SI'
        redirect_to visitas_path
      elsif bloqueoporfirma == 'SI'
        redirect_to bloqueofirma_controlfirmas_path
      elsif bloqueoporcapa == 'SI'
        redirect_to gestion_evaluaciones_path
      elsif bloqueoporweek == 'SI'
        redirect_to gestion_tareas_path
      elsif bloqueoporepp == 'SI'
        redirect_to procesos_contratossolepps_path
      end
    end

    if @usr.tipoconsulta.to_s == 'PERSONA' # is_persona
      @validat = true
      @existeHoy = ""
    else
      cadpermisos = []
      Userspermiso.joins(:objeto).where(["userspermisos.user_id = #{isadmin} and userspermisos.crea = 'S' and userspermisos.objeto_id in (14,110,95,67,117,109,115,111,24,21,19,22,23,13,35,36,16) "])
                  .select("objetos.descripcion").each do |a|
        cadpermisos << a.descripcion
      end
      if cadpermisos.include?('dashboard')
        @cadper.push 'dashboard'
        ActiveRecord::Base.connection.execute("CALL validacion")
        @dbLaterales1 = Objeto.find_by_sql(["select 'Total Estratificacion' nombre, count(9) cant, '3' as infgrupo, portafolio_id from antecedentes where portafolio_id = 1
                                              union all
                                              select 'Total Autoevaluaciones', count(9), '4' as infgrupo, 1 portafolio_id from personasevaluaciones where portafolio = 'ASEAR S.A. E.S.P'
                                              union all
                                              select 'Estratificacion Hoy', count(9) cant, '5' as infgrupo, portafolio_id from antecedentes where portafolio_id = 1 and date(created_at) = date(now())
                                              union all
                                              select 'Autoevaluaciones Hoy', count(9) cant, '6' as infgrupo, 1 portafolio_id from personasevaluaciones where portafolio = 'ASEAR S.A. E.S.P' and date(created_at) = date(now())
                                              union all
                                              select 'Autoevaluacione en Riesgo', count(9) cant, '7' as infgrupo, 1 portafolio_id from  personasevaluaciones where portafolio = 'ASEAR S.A. E.S.P' and cantidad >= 2 "])
        @dbLaterales2 = Objeto.find_by_sql(["select 'Total Estratificacion' nombre, count(9) cant, '3' as infgrupo, portafolio_id from antecedentes where portafolio_id = 2
                                              union all
                                              select 'Total Autoevaluaciones', count(9), '4' as infgrupo, 2 portafolio_id from personasevaluaciones where portafolio = 'MICROCINCO'
                                              union all
                                              select 'Estratificacion Hoy', count(9) cant, '5' as infgrupo, portafolio_id from antecedentes where portafolio_id = 2 and date(created_at) = date(now())
                                              union all
                                              select 'Autoevaluaciones Hoy', count(9) cant, '6' as infgrupo, 2 portafolio_id from personasevaluaciones where portafolio = 'MICROCINCO' and date(created_at) = date(now())
                                              union all
                                              select 'Autoevaluacione en Riesgo', count(9) cant, '7' as infgrupo, 2 portafolio_id from  personasevaluaciones where portafolio = 'MICROCINCO' and cantidad >= 2"])
        @dbLaterales3 = Objeto.find_by_sql(["select 'Total Estratificacion' nombre, count(9) cant, '3' as infgrupo, portafolio_id from antecedentes where portafolio_id = 3
                                              union all
                                              select 'Total Autoevaluaciones', count(9), '4' as infgrupo, 3 portafolio_id from personasevaluaciones where portafolio = 'CONSTRUMATER'
                                              union all
                                              select 'Estratificacion Hoy', count(9) cant, '5' as infgrupo, portafolio_id from antecedentes where portafolio_id = 3 and date(created_at) = date(now())
                                              union all
                                              select 'Autoevaluaciones Hoy', count(9) cant, '6' as infgrupo, 3 portafolio_id from personasevaluaciones where portafolio = 'CONSTRUMATER' and date(created_at) = date(now())
                                              union all
                                              select 'Autoevaluacione en Riesgo', count(9) cant, '7' as infgrupo, 3 portafolio_id from  personasevaluaciones where portafolio = 'CONSTRUMATER' and cantidad >= 2"])
        @personasevaluaciones = Personasevaluacion.where(["date(created_at) = date(now())"]).order("id desc")
        @antecedentes = Antecedente.where(["date(created_at) = date(now())"]).order("id desc")
        @totaleva = Personasevaluacion.count rescue 0
        @totalant = Antecedente.count rescue 0
        @totalriesgo = Personasevaluacion.where(["cantidad >= 2 and descartado is null"]).count rescue 0

        @personasevaluacionesr = Personasevaluacion.joins(:persona)
                                                   .select("personasevaluaciones.*, personas.identificacion, personas.nombre,
                                                       (case when personas.portafolio_id = 1 then 'ASEAR S.A. E.S.P'
                                                            when personas.portafolio_id = 2 then 'MICROCINCO'
                                                            when personas.portafolio_id = 3 then 'CONSTRUMATER'
                                                       end) nombreportafolio,
                                                       (select concat('( ',descripcion,' )') from centros where id = (select centro_id from antecedentes where persona_id = personas.id)) centrodetrabajo")
                                                   .where("personasevaluaciones.cantidad >= 2 and personasevaluaciones.descartado is null")
                                                   .order("personasevaluaciones.id desc").paginate(:page => params[:page], :per_page => 10)
        @personasevaluacionesra = Personasevaluacion.joins(:persona)
                                                    .select("personasevaluaciones.*, personas.identificacion, personas.nombre,
                                                       (case when personas.portafolio_id = 1 then 'ASEAR S.A. E.S.P'
                                                            when personas.portafolio_id = 2 then 'MICROCINCO'
                                                            when personas.portafolio_id = 3 then 'CONSTRUMATER'
                                                       end) nombreportafolio,
                                                       (select concat('( ',descripcion,' )') from centros where id = (select centro_id from antecedentes where persona_id = personas.id)) centrodetrabajo")
                                                    .where("personasevaluaciones.cantidad >= 2 and (personasevaluaciones.persona_id in (select persona_id from personasobservaciones) or personasevaluaciones.persona_id in (select persona_id from personasimagenes))")
                                                    .order("personasevaluaciones.id desc").paginate(:page => params[:riesgo], :per_page => 10)
        ActiveRecord::Base.connection.execute("CALL registrodiario(now());")
        @personasevaladmin_m = Personasevaluacion.find_by_sql(["select * from informediario order by manana desc"])
      end

      if cadpermisos.include?('dashseguimientocontrato')
        @cadper << 'dashseguimientocontrato'
        if cadpermisos.include?('dashseguimientototal')
          @cadper << 'dashseguimientototal'
          @contratosperexamenesp = Contratosperexamen.where("estado = 'PENDIENTE' and contratospersona_id in (select id from contratospersonas where contrato_id in (select id from contratos where publicado = 'SI') and tienecontrato is null and user_asignado is not null)
                                                              and contratospersona_id not in (select distinct contratospersona_id from contratosperestados)").order("created_at desc")
          @contratosperexamenesra = Contratosperexamen.where("estado = 'APROBADO' and contratospersona_id in (select id from contratospersonas where contrato_id in (select id from contratos where publicado = 'SI') and tienecontrato is null and user_asignado is not null)
                                                              and contratospersona_id not in (select distinct contratospersona_id from contratosperestados)").order("created_at desc")
          @contratosperexamenesrc = Contratosperexamen.where("estado = 'RECHAZADO' and contratospersona_id in (select id from contratospersonas where contrato_id in (select id from contratos where publicado = 'SI') and tienecontrato is null and user_asignado is not null)
                                                              and contratospersona_id not in (select distinct contratospersona_id from contratosperestados)").order("created_at desc")
          @contratosperexamenesra2 = Contratosperexamen.where("contratospersona_id in (select id from contratospersonas where contrato_id in (select id from contratos where publicado = 'SI') and tienecontrato is null and user_asignado is not null)
                                                              and contratospersona_id in (select distinct contratospersona_id from contratosperestados)").order("created_at desc")
          @contratados = Contratospersona.where("contrato_id in (select id from contratos where publicado = 'SI') and tienecontrato = 'SI' and id not in (select distinct contratospersona_id from contratosperestados)").order("updated_at asc")
        else
          @contratosperexamenesp = Contratosperexamen.where("estado = 'PENDIENTE' and contratospersona_id in (select id from contratospersonas where contrato_id in (select id from contratos where publicado = 'SI') and tienecontrato is null and user_asignado = #{isadmin})
                                                              and contratospersona_id not in (select distinct contratospersona_id from contratosperestados)").order("created_at desc")
          @contratosperexamenesra = Contratosperexamen.where("estado = 'APROBADO' and contratospersona_id in (select id from contratospersonas where contrato_id in (select id from contratos where publicado = 'SI') and tienecontrato is null and user_asignado = #{isadmin})
                                                              and contratospersona_id not in (select distinct contratospersona_id from contratosperestados)").order("created_at desc")
          @contratosperexamenesrc = Contratosperexamen.where("estado = 'RECHAZADO' and contratospersona_id in (select id from contratospersonas where contrato_id in (select id from contratos where publicado = 'SI') and tienecontrato is null and user_asignado = #{isadmin})
                                                              and contratospersona_id not in (select distinct contratospersona_id from contratosperestados)").order("created_at desc")
          @contratosperexamenesra2 = Contratosperexamen.where("contratospersona_id in (select id from contratospersonas where contrato_id in (select id from contratos where publicado = 'SI') and tienecontrato is null and user_asignado = #{isadmin})
                                                              and contratospersona_id in (select distinct contratospersona_id from contratosperestados)").order("created_at desc")
          @contratados = Contratospersona.where("contrato_id in (select id from contratos where publicado = 'SI') and tienecontrato = 'SI' and user_asignado = #{isadmin} and id not in (select distinct contratospersona_id from contratosperestados)").order("updated_at desc")
        end
      end
      if cadpermisos.include?('solicitudescontrato')
        # ActiveRecord::Base.connection.execute("CALL prc_solicitudconsol")
        @cadper << 'solicitudescontrato'
        @objetos = Contratosuser.joins(:contrato)
                                .where("contratos.estado = 'EN EJECUCION' and contratosusers.user_interventor = ? and (contratosusers.fecha_fin is null or contratosusers.fecha_fin > now())", isadmin)
                                .select("distinct contratos.id, contratos.empresa_id, contratosusers.multiples_solicitudes, contratosusers.user_interventor, contratosusers.marca_noreal, contratosusers.marca_entrega_sitio, contratosusers.tipo")
                                .order("contratos.id desc ")
      end
      # Nuevo DASH
      a = Userspermiso.joins(:objeto).where(["userspermisos.user_id = #{isadmin} and userspermisos.crea = 'S' and userspermisos.objeto_id = #{@usr.objeto_id}"])
                      .select("objetos.descripcion")[0] rescue nil
      cadpermisos = []
      if a.present?
        cadpermisos << a.descripcion
        if cadpermisos.include?('solicitudseguimiento')
          # ActiveRecord::Base.connection.execute("CALL prc_solicitudconsol")
          @cadper << 'solicitudseguimiento'
          @contratossolicitudes = Contratossolicitud.joins(:contrato)
                                                    .select("contratossolicitudes.*, (select nombre from empresas where id = contratos.empresa_id) identnombre, contratos.nro_contrato, (select concat(nombre,' - ',email) from users where id = contratossolicitudes.user_id) usernombre")
                                                    .order("contratossolicitudes.id desc")
          #@contratossolicitudes = Contratossolicitud.all.order("id desc")
          @solicitudes = Contratossolicitud.select("distinct periodo").distinct.order("periodo desc")
        elsif cadpermisos.include?('solicitudesprefactura')
          @cadper << 'solicitudesprefactura'
          @objetos = Contratosuser.joins(:contrato)
                                  .where("contratosusers.user_interventor = #{isadmin} and (contratosusers.fecha_fin is null or contratosusers.fecha_fin > now())")
                                  .select("distinct contratos.id, contratos.empresa_id, contratosusers.multiples_solicitudes, contratosusers.user_interventor, contratosusers.marca_noreal, contratosusers.marca_entrega_sitio, contratosusers.tipo")
        elsif cadpermisos.include?('solicitudesprefacturaesp')
          @cadper << 'solicitudesprefacturaesp'
          @contratosprefacturas = Contratosprefactura.joins(:contrato)
                                                     .select("contratosprefacturas.*, (select autobuscar from empresas where id = contratos.empresa_id) identnombre")
                                                     .order("contratosprefacturas.id desc")
        elsif cadpermisos.include?('dashcompromisos')
          @cadper << 'dashcompromisos'
          @fechas = Compromiso.select("DISTINCT DATE_FORMAT(fecha_entrega, '%Y-%m') AS periodo,
                                      (SELECT COUNT(s.id) FROM compromisos s WHERE estado = 'PENDIENTE' AND DATE_FORMAT(s.fecha_entrega, '%Y-%m') = DATE_FORMAT(compromisos.fecha_entrega, '%Y-%m')) AS cnt_pendientes,
                                      (SELECT COUNT(s.id) FROM compromisos s WHERE estado = 'RECHAZADO' AND DATE_FORMAT(s.fecha_entrega, '%Y-%m') = DATE_FORMAT(compromisos.fecha_entrega, '%Y-%m')) AS cnt_rechazados,
                                      (SELECT COUNT(s.id) FROM compromisos s WHERE estado = 'FINALIZADO' AND DATE_FORMAT(s.fecha_entrega, '%Y-%m') = DATE_FORMAT(compromisos.fecha_entrega, '%Y-%m')) AS cnt_finalizados"
                                        ).where(estado: 'PENDIENTE').order("DATE_FORMAT(fecha_entrega, '%Y-%m') DESC")


        elsif cadpermisos.include?('dashdotacionentrega')
          @cadper << 'dashdotacionentrega'
          fecha_inicio = 5.months.ago.to_date  # Dos meses atrás
          fecha_fin = 2.months.from_now.to_date  # Dos meses adelante

          @fechas = Contratosperdotacion.select("contratosperdotaciones.fecha_prox_entrega,
                                                 (select count(s.id) from contratosperdotaciones s
                                                  where fecha_prox_entrega = contratosperdotaciones.fecha_prox_entrega and estado = 'PENDIENTE') cnt_pendientes,
                                                 (select count(s.id) from contratosperdotaciones s
                                                  where fecha_prox_entrega = contratosperdotaciones.fecha_prox_entrega and estado = 'ENTREGADO') cnt_entregados,
                                                 (select count(s.id) from contratosperdotaciones s
                                                  where fecha_prox_entrega = contratosperdotaciones.fecha_prox_entrega and estado not in ('ENTREGADO','PENDIENTE')) cnt_otros")
                                        .distinct
                                        .where(estado: ['ENTREGADO','PENDIENTE'])
                                        .where(fecha_prox_entrega: fecha_inicio..fecha_fin)
                                        .order(fecha_prox_entrega: :asc)
          # Realiza la consulta utilizando ActiveRecord
=begin
          @fechas = Contratosperdotacion.select("contratosperdotaciones.fecha_prox_entrega,
                                                 (select count(s.id) from contratosperdotaciones s
                                                  where fecha_prox_entrega = contratosperdotaciones.fecha_prox_entrega and estado = 'PENDIENTE') cnt_pendientes,
                                                 (select count(s.id) from contratosperdotaciones s
                                                  where fecha_prox_entrega = contratosperdotaciones.fecha_prox_entrega and estado = 'ENTREGADO') cnt_entregados,
                                                 (select count(s.id) from contratosperdotaciones s
                                                  where fecha_prox_entrega = contratosperdotaciones.fecha_prox_entrega and estado not in ('ENTREGADO','PENDIENTE')) cnt_otros")
                                        .distinct
                                        .where(fecha_prox_entrega: fecha_inicio..fecha_fin)
                                        .order(fecha_prox_entrega: :asc)
=end
        elsif cadpermisos.include?('dashdotacion')
          @ruta_paginador = "paginate_dotacion"
          @cadper << 'dashdotacion'
          etapa = current_user.etapa.gsub("DOTA_", "")
          etapa = etapa.gsub(" ", "_")
          @paginadordotacion = eval("params[:dota_#{etapa.downcase}]") rescue nil
          @contratosprefechasdotacion = Contratosperfecha.where("val_dotacion = '#{etapa}' and dotacion = 'SI' and estado = 'ACTIVO'").order("id asc").paginate(:page => @paginadordotacion, :per_page => 10)
        elsif cadpermisos.include?('dashcarnet')
          @ruta_paginador = "paginate_carnet"
          @cadper << 'dashcarnet'
          etapa = current_user.etapa.gsub("CAR_", "")
          etapa = etapa.gsub(" ", "_")
          @paginadorcarnet = eval("params[:car_#{etapa.downcase}]") rescue nil
          @contratosprefechascarnet = Contratosperfecha.where("val_carne = '#{etapa}' and carne = 'SI' and estado = 'ACTIVO'").order("id asc").paginate(:page => @paginadorcarnet, :per_page => 10)
        elsif cadpermisos.include?('dashdocumentosFirma')
          @cadper << 'dashdocumentosFirma'
          etapa = current_user.etapa.gsub("DOC_", "")
          etapa = etapa.gsub(" ", "_")
          @paginadordocfirma = eval("params[:doc_#{etapa.downcase}]") rescue nil
          if current_user.etapa == "DOC_PENDIENTE"
            params[:doc_pendiente] = params[:doc_pendiente].present? ? params[:doc_pendiente] : '1'
            @ruta_paginador = "paginate_docfirma_pendiente"
            @contratosprefechasdocfirma = Contratosperfecha.where("id in (select id_registro from controlfirmas where controlador = 'contratosperfechas' and fecha_firma is null)")
                                                           .paginate(:page => params[:doc_pendiente], :per_page => 15)
          elsif current_user.etapa == "DOC_FIRMADO"
            @ruta_paginador = "paginate_docfirma_firmado"
            params[:doc_firmado] = params[:doc_firmado].present? ? params[:doc_firmado] : '1'
            @contratosprefechasdocfirma = Contratosperfecha.where("id in (select id_registro from controlfirmas where controlador = 'contratosperfechas' and fecha_firma is not null)")
                                                           .paginate(:page => params[:doc_firmado], :per_page => 15)
          elsif current_user.etapa == "DOC_CONTRATO"
            @ruta_paginador = "paginate_docfirma_contrato"
            params[:doc_contrato] = params[:doc_contrato].present? ? params[:doc_contrato] : '1'
            @contratosprefechasdocfirma = Contratosperfecha.where("sol_firma_digital = 'SI'")
                                                           .paginate(:page => params[:doc_contrato], :per_page => 20)
          end
        elsif cadpermisos.include?('dashsalud')
          @cadper << 'dashsalud'
          etapa = current_user.etapa.gsub("SAL_", "")
          etapa = etapa.gsub(" ", "_")
          @paginadorsalud = eval("params[:sal_#{etapa.downcase}]") rescue nil
          if current_user.etapa == "SAL_PENDIENTE"
            params[:sal_pendiente] = params[:sal_pendiente].present? ? params[:sal_pendiente] : '1'
            @ruta_paginador = "paginate_salud_pendiente"
            @contratosprefechassalud = Contratosperfecha.where("(eps = 'SI' or arl = 'SI' or afp = 'SI' or ccaf = 'SI')  and estado = 'ACTIVO' and DATE_FORMAT(created_at,'%Y-%m-%d') >= '2023-02-23' and val_salud = 'PENDIENTE'").
              paginate(:page => params[:sal_pendiente], :per_page => 10)
          else
            @ruta_paginador = "paginate_salud_afiliado"
            params[:sal_afiliado] = params[:sal_afiliado].present? ? params[:sal_pendiente] : '1'
            @contratosprefechassalud = Contratosperfecha.where("(eps = 'SI' or arl = 'SI' or afp = 'SI' or ccaf = 'SI')  and estado = 'ACTIVO' and DATE_FORMAT(created_at,'%Y-%m-%d') >= '2023-02-23' and val_salud = 'AFILIADO'").
              paginate(:page => params[:sal_afiliado], :per_page => 10)
          end
        elsif cadpermisos.include?('dashevaluadocumentos')
          @cadper << 'dashevaluadocumentos'
          estado1 = current_user.etapa.gsub("EVAL_", "")
          estado = estado1.gsub(" ", "")
          evaluador = "params[:eval_#{estado.downcase}]"
          paginador = eval(evaluador) rescue nil
          @contratosperimagenes = Contratosperimagen.where("estado = '#{estado}' AND descripcion IN (SELECT descripcion FROM iparametros WHERE id IN (SELECT iparametro_id FROM iparametrosusers WHERE user_id = #{isadmin}))").order("id asc").paginate(:page => paginador, :per_page => 8)
        elsif cadpermisos.include?('dashcausaciones')
          @cadper << 'dashcausaciones'
          @compras = Eproveedorescompra.select("eproveedor_id, (select autobuscar from eproveedores where id = eproveedorescompras.eproveedor_id) identnombre, count(9) cantidad,
                                             sum(total) valortotal ")
                                       .where("estado = 'PENDIENTE'")
                                       .group("eproveedor_id").order("3 desc").distinct
        elsif cadpermisos.include?('dashcontratoscargo')
          @cadper << 'dashcontratoscargo'
        elsif cadpermisos.include?('dashcontratosproceso')
          @clase = params[:clase].present? ? params[:clase] : 'ABANDONO DE PUESTO'
          @etapaproceso = params[:etapa_proceso].present? ? params[:etapa_proceso] : 'ABANDONO_DE_PUESTO'
          if @etapaproceso == 'EVALUACION_PERIODO'
            @etapa_prueba = params[:etapa_prueba].present? ? params[:etapa_prueba] : 'P' rescue nil
            if @etapa_prueba.to_s == 'P'
              #@datos = Evaluacionescontrato.where("estado <= 2.52 and estado_juridico = 'PENDIENTE' and codigo_firma is not null")
              @datos = Evaluacionescontrato.where("estado_juridico = 'PENDIENTE' and codigo_firma is not null")
            elsif @etapa_prueba.to_s == 'A'
              @datos = Evaluacionescontrato.where("estado_juridico = 'ATENDIDO'")
            elsif @etapa_prueba.to_s == 'N'
              @datos = Evaluacionescontrato.where("estado_juridico = 'NO APLICA'")
            end
          else
            if @usr.subetapa.to_s == 'PENDIENTE'
              @contratosperprocesos = Contratosperproceso.includes([:contratospersona, :user]).where("date_format(contratosperprocesos.created_at,'%%Y-%%m') = date_format(curdate(),'%%Y-%%m') and clase = '#{@clase}'").order("id asc")
            else
              @contratosperprocesos = Contratosperproceso.includes([:contratospersona, :user]).where("date_format(contratosperprocesos.created_at,'%%Y-%%m') = date_format(curdate(),'%%Y-%%m') and clase = '#{@clase}'").order("id desc")
            end
          end

          @cadper << 'dashcontratosproceso'
        elsif cadpermisos.include?('dashsolicitudesepp')
          @cadper << 'dashsolicitudesepp'
        elsif cadpermisos.include?('dashverificacion')
          @cadper << 'dashverificacion'
          @fechas = Veriserviciosagenda.select("fecha_reprogramacion").
            where("veriservicio_id in (select id from veriservicios where estado_proceso = 'EN PROCESO')").
            distinct.order("fecha_reprogramacion desc")
        end

      end
    end
  end

  def searchsalud
    @contrato = Contrato.find(params[:contrato_id])
    @p = params[:val_salud]
    @variable = "sal_#{@p.downcase.gsub("-", "")}_#{@contrato.id}"
    paginador = eval("params[:sal_#{@p.downcase.gsub("-", "")}_#{@contrato.id}]")
    if params[:autobuscar].present?
      if current_user.etapa == "SAL_PENDIENTE"
        sql = 'Contratosperfecha.where("contrato_id = #{@contrato.id} and estado = ' + "'" + 'ACTIVO' + "'" + 'and (eps = ' + "'" + 'SI' + "'" + ' or arl = ' + "'" + 'SI' + "'" + ' or afp = ' "'" + 'SI' + "'" + ' or ccaf = ' + "'" + 'SI' + "'" + ') and DATE_FORMAT(created_at,' + "'" + '%Y-%m-%d' + "') >= " + "'" + '2023-02-23' + "'" + +' and val_salud = ' + "'" + 'PENDIENTE' + "'" + ' and contratospersona_id in (select id from contratospersonas where  autobuscar like ' + "'" + "%#{params[:autobuscar]}%" + "'" + ')").paginate(:page => paginador, :per_page => 10)'
        eval("@#{@variable} = #{sql}")
      else
        sql = 'Contratosperfecha.where("contrato_id = #{@contrato.id} and estado = ' + "'" + 'ACTIVO' + "'" + 'and (eps = ' + "'" + 'SI' + "'" + ' or arl = ' + "'" + 'SI' + "'" + ' or afp = ' "'" + 'SI' + "'" + ' or ccaf = ' + "'" + 'SI' + "'" + ') and DATE_FORMAT(created_at,' + "'" + '%Y-%m-%d' + "') >= " + "'" + '2023-02-23' + "'" + +' and val_salud = ' + "'" + 'AFILIADO' + "'" ' and contratospersona_id in (select id from contratospersonas where  autobuscar like ' + "'" + "%#{params[:autobuscar]}%" + "'" + ')").paginate(:page => paginador, :per_page => 10)'
        eval("@#{@variable} = #{sql}")
      end
    else
      if current_user.etapa == "SAL_PENDIENTE"
        sql = 'Contratosperfecha.where("contrato_id = #{@contrato.id} and estado = ' + "'" + 'ACTIVO' + "'" + 'and (eps = ' + "'" + 'SI' + "'" + ' or arl = ' + "'" + 'SI' + "'" + ' or afp = ' "'" + 'SI' + "'" + ' or ccaf = ' + "'" + 'SI' + "'" + ') and DATE_FORMAT(created_at,' + "'" + '%Y-%m-%d' + "') >= " + "'" + '2023-02-23' + "'" + +' and val_salud = ' + "'" + 'PENDIENTE' + "'" + '").paginate(:page => paginador, :per_page => 10)'
        eval("@#{@variable} = #{sql}")

      else
        sql = 'Contratosperfecha.where("contrato_id = #{@contrato.id} and estado = ' + "'" + 'ACTIVO' + "'" + 'and (eps = ' + "'" + 'SI' + "'" + ' or arl = ' + "'" + 'SI' + "'" + ' or afp = ' "'" + 'SI' + "'" + ' or ccaf = ' + "'" + 'SI' + "'" + ') and DATE_FORMAT(created_at,' + "'" + '%Y-%m-%d' + "') >= " + "'" + '2023-02-23' + "'" + +' and val_salud = ' + "'" + 'AFILIADO' + "'" + '").paginate(:page => paginador, :per_page => 10)'
        eval("@#{@variable} = #{sql}")
      end
    end
  end

  def pasar_afiliado
    @contratosperfecha = Contratosperfecha.find(params[:contratosperfecha_id])
    @estado = params[:estado]
    @contratosperfecha.val_salud = 'AFILIADO'
    @contratosperfecha.user_val_salud = is_admin
    @contratosperfecha.fecha_val_salud = Time.now
    @contratosperfecha.save(validate: false)
  end

  def pasari_afiliado
    @contratosperfecha = Contratosperfecha.find(params[:contratosperfecha_id])
    @estado = params[:estado]
    @contratosperfecha.val_salud = 'INTERMEDIO'
    @contratosperfecha.user_val_salud = is_admin
    @contratosperfecha.fecha_val_salud = Time.now
    @contratosperfecha.save(validate: false)
  end

  def hab_doc
    @contratosperfecha = Contratosperfecha.find(params[:contratosperfecha_id])
    if @contratosperfecha.ver_doc.to_s == 'SI'
      @contratosperfecha.ver_doc = 'NO'
    else
      @contratosperfecha.ver_doc = 'SI'
    end
    @contratosperfecha.save(validate: false)
    respond_to do |format|
      format.js { render inline: "location.reload();" }
    end
  end

  def searchcarnet_todo
    @p = params[:estado]
    paginador = eval("params[:car_#{@p.downcase.gsub("-", "")}]")
    if params[:autobuscar].present?
      @contratosprefechascarnet_todo = Contratosperfecha.where("val_carne = '#{@p}' and carne = 'SI' and estado = 'ACTIVO' and contratospersona_id in (select id from contratospersonas where autobuscar like '%#{params[:autobuscar]}%')").order("id asc").paginate(:page => paginador, :per_page => 10)
    end
  end

  def searchdocumento_todo
    @p = params[:estado]
    paginador = eval("params[:doc_#{@p.downcase.gsub("-", "")}]")
    if params[:autobuscar].present?
      @controlfirmas = Controlfirma.where("portafolio_id = #{is_portafolio} and id_registro in (select id from contratosperfechas where contratospersona_id in (select id from contratospersonas where autobuscar like '%#{params[:autobuscar]}%'))").order("id asc").paginate(:page => paginador, :per_page => 10)
    end
  end

  def searchcarnet
    @contrato = Contrato.find(params[:contrato_id])
    @p = params[:val_carne]
    @variable = "car_#{@p.downcase.gsub("-", "")}_#{@contrato.id}"
    paginador = eval("params[:car_#{@p.downcase.gsub("-", "")}_#{@contrato.id}]")
    eval("@contratosprefechascarnet#{@contrato.id}#{@p.downcase}")
    if params[:autobuscar].present?
      sql = 'Contratosperfecha.where("contrato_id = #{@contrato.id} and val_carne = ' + "'" + "#{params[:val_carne]}" + "'" + ' and carne = ' + "'" + 'SI' + "'" + "and estado = " + "'" + 'ACTIVO' + "' and contratospersona_id in (select id from contratospersonas where autobuscar like " + "'" + "%#{params[:autobuscar]}%" + "'" + ')").paginate(:page => paginador, :per_page => 10)'
      eval("@#{@variable} = #{sql}")
    else
      sql = 'Contratosperfecha.where("contrato_id = #{@contrato.id} and val_carne = ' + "'" + "#{params[:val_carne]}" + "'" + ' and carne = ' + "'" + 'SI' + "'" + "and estado = " + "'" + 'ACTIVO' + "'" + '").paginate(:page => paginador, :per_page => 10)'
      eval("@#{@variable} = #{sql}")
    end
  end

  def show_detalle_carnet
    @p = params[:val_carne]
    @ruta = params[:ruta]
    @estado_car = params[:estado]
    @contrato = Contrato.find(params[:contrato_id])
    paginador = eval("params[:car_#{@p.downcase.gsub("-", "")}_#{@contrato.id}]")
    @contratosprefechascarnet = Contratosperfecha.where("val_carne = '#{@p}' and carne = 'SI' and estado = 'ACTIVO'").order("id asc").paginate(:page => paginador, :per_page => 10)
  end

  def show_detalle_dotacion_entrega
    @ruta = params[:ruta]
    @fecha = params[:fecha]
    @fechaparams = @fecha.gsub('-', '_')
    @contratosperdotaciones = Contratosperdotacion.select("DISTINCT CONCAT(empresas.autobuscar, ' - ', contratos.nro_contrato) AS identcontrato, contratosperdotaciones.contrato_id")
                                                  .joins("INNER JOIN contratos ON contratos.id = contratosperdotaciones.contrato_id")
                                                  .joins("INNER JOIN empresas ON empresas.id = contratos.empresa_id")
                                                  .where("contratosperdotaciones.fecha_prox_entrega = ?", @fecha)
                                                  .where("contratosperdotaciones.estado IN ('PENDIENTE', 'ENTREGADO')")
                                                  .order("1 ASC")

  end

  def show_detalle_compromiso
    @ruta = params[:ruta]
    @fecha = params[:fecha]
    @fechaparams = @fecha.gsub('-', '_')
    vcConsultaAdd = ""
    if is_auth_a('compromisosfull') == false
      isadmin = is_admin
      vcConsultaAdd = "and (c.user_compromiso = #{isadmin} or c.user_contrato = #{isadmin}
                            or c.contratospersona_id in (select contratospersona_id from contratosperusers where user_id = #{isadmin} and fecha_fin is null))"
    end
     @compromisosp = Compromiso.find_by_sql("SELECT
                                                c.*,
                                                -- Marca si existe al menos una imagen
                                                CASE WHEN ci.compromiso_id IS NOT NULL THEN 'X' END AS imagen,
                                                pd.descripcion                               AS docdesc,
                                                cc.perfil                                     AS cargo,
                                                cg.descripcion                                 AS grupo,
                                                co.nro_contrato,
                                                e.autobuscar                                   AS empresa,
                                                cp.autobuscar                                  AS identinombre,
                                                CONCAT(cp.direccion, ' Tel: ', cp.movil)       AS direcciontelefono,
                                                cs.descripcion2                                AS seccion,
                                                CONCAT(pf.identificacion, ' - ', pf.nombre)    AS formulario
                                              FROM compromisos c
                                              LEFT JOIN parcargosdocs       pd ON pd.id = c.parcargosdoc_id
                                              LEFT JOIN contratosperfechas  f  ON f.id = c.contratosperfecha_id
                                              LEFT JOIN contratoscargos     cc ON cc.id = f.contratoscargo_id
                                              LEFT JOIN contratosgrupos     cg ON cg.id = f.contratosgrupo_id
                                              LEFT JOIN contratos           co ON co.id = f.contrato_id
                                              LEFT JOIN empresas            e  ON e.id = co.empresa_id
                                              LEFT JOIN contratospersonas   cp ON cp.id = f.contratospersona_id
                                              LEFT JOIN contratossecciones  cs ON cs.id = f.contratosseccion_id
                                              LEFT JOIN personasformularios pf ON pf.id = c.personasformulario_id
                                              -- Única fila por compromiso_id para evitar duplicados si hay varias imágenes
                                              LEFT JOIN (
                                                  SELECT DISTINCT compromiso_id
                                                  FROM contratosperimagenes
                                              ) ci ON ci.compromiso_id = c.id
                                              WHERE c.estado = 'PENDIENTE' and DATE_FORMAT(c.fecha_entrega, '%Y-%m') = '#{@fecha}' #{vcConsultaAdd}
                                              order by c.fecha_entrega asc")
      @compromisosr = Compromiso.find_by_sql("SELECT
                                                c.*,
                                                -- Marca si existe al menos una imagen
                                                CASE WHEN ci.compromiso_id IS NOT NULL THEN 'X' END AS imagen,
                                                pd.descripcion                               AS docdesc,
                                                cc.perfil                                     AS cargo,
                                                cg.descripcion                                 AS grupo,
                                                co.nro_contrato,
                                                e.autobuscar                                   AS empresa,
                                                cp.autobuscar                                  AS identinombre,
                                                CONCAT(cp.direccion, ' Tel: ', cp.movil)       AS direcciontelefono,
                                                cs.descripcion2                                AS seccion,
                                                CONCAT(pf.identificacion, ' - ', pf.nombre)    AS formulario
                                              FROM compromisos c
                                              LEFT JOIN parcargosdocs       pd ON pd.id = c.parcargosdoc_id
                                              LEFT JOIN contratosperfechas  f  ON f.id = c.contratosperfecha_id
                                              LEFT JOIN contratoscargos     cc ON cc.id = f.contratoscargo_id
                                              LEFT JOIN contratosgrupos     cg ON cg.id = f.contratosgrupo_id
                                              LEFT JOIN contratos           co ON co.id = f.contrato_id
                                              LEFT JOIN empresas            e  ON e.id = co.empresa_id
                                              LEFT JOIN contratospersonas   cp ON cp.id = f.contratospersona_id
                                              LEFT JOIN contratossecciones  cs ON cs.id = f.contratosseccion_id
                                              LEFT JOIN personasformularios pf ON pf.id = c.personasformulario_id
                                              -- Única fila por compromiso_id para evitar duplicados si hay varias imágenes
                                              LEFT JOIN (
                                                  SELECT DISTINCT compromiso_id
                                                  FROM contratosperimagenes
                                              ) ci ON ci.compromiso_id = c.id
                                              WHERE c.estado = 'RECHAZADO' and DATE_FORMAT(c.fecha_entrega, '%Y-%m') = '#{@fecha}' #{vcConsultaAdd}
                                              order by c.fecha_entrega asc")
      @compromisosf = Compromiso.find_by_sql("SELECT
                                                c.*,
                                                -- Marca si existe al menos una imagen
                                                CASE WHEN ci.compromiso_id IS NOT NULL THEN 'X' END AS imagen,
                                                pd.descripcion                               AS docdesc,
                                                cc.perfil                                     AS cargo,
                                                cg.descripcion                                 AS grupo,
                                                co.nro_contrato,
                                                e.autobuscar                                   AS empresa,
                                                cp.autobuscar                                  AS identinombre,
                                                CONCAT(cp.direccion, ' Tel: ', cp.movil)       AS direcciontelefono,
                                                cs.descripcion2                                AS seccion,
                                                CONCAT(pf.identificacion, ' - ', pf.nombre)    AS formulario
                                              FROM compromisos c
                                              LEFT JOIN parcargosdocs       pd ON pd.id = c.parcargosdoc_id
                                              LEFT JOIN contratosperfechas  f  ON f.id = c.contratosperfecha_id
                                              LEFT JOIN contratoscargos     cc ON cc.id = f.contratoscargo_id
                                              LEFT JOIN contratosgrupos     cg ON cg.id = f.contratosgrupo_id
                                              LEFT JOIN contratos           co ON co.id = f.contrato_id
                                              LEFT JOIN empresas            e  ON e.id = co.empresa_id
                                              LEFT JOIN contratospersonas   cp ON cp.id = f.contratospersona_id
                                              LEFT JOIN contratossecciones  cs ON cs.id = f.contratosseccion_id
                                              LEFT JOIN personasformularios pf ON pf.id = c.personasformulario_id
                                              -- Única fila por compromiso_id para evitar duplicados si hay varias imágenes
                                              LEFT JOIN (
                                                  SELECT DISTINCT compromiso_id
                                                  FROM contratosperimagenes
                                              ) ci ON ci.compromiso_id = c.id
                                              WHERE c.estado = 'FINALIZADO' and DATE_FORMAT(c.fecha_entrega, '%Y-%m') = '#{@fecha}' #{vcConsultaAdd}
                                              order by c.fecha_entrega asc")
                                                                                     
=begin    
    @compromisos = Compromiso.select("compromisos.*,
                                      (select distinct 'X' from contratosperimagenes where compromiso_id = compromisos.id) imagen,
                                       (select descripcion from parcargosdocs where id = compromisos.parcargosdoc_id) docdesc,
                                      (select c.perfil from contratosperfechas f, contratoscargos c
                                       where f.id = (case when compromisos.contratosperfecha_id is null then -1 else compromisos.contratosperfecha_id end)
                                       and   f.contratoscargo_id = c.id) cargo,
                                      (select c.descripcion from contratosperfechas f, contratosgrupos c
                                       where f.id = (case when compromisos.contratosperfecha_id is null then -1 else compromisos.contratosperfecha_id end)
                                       and   f.contratosgrupo_id = c.id) grupo,
                                      (select c.nro_contrato from contratosperfechas f, contratos c
                                       where f.id = (case when compromisos.contratosperfecha_id is null then -1 else compromisos.contratosperfecha_id end)
                                       and   f.contrato_id = c.id) nro_contrato,
                                      (select e.autobuscar from contratosperfechas f, contratos c, empresas e
                                       where f.id = (case when compromisos.contratosperfecha_id is null then -1 else compromisos.contratosperfecha_id end)
                                       and   f.contrato_id = c.id and   c.empresa_id = e.id) empresa,
                                      (select p.autobuscar from contratosperfechas f, contratospersonas p
                                       where f.id = compromisos.contratosperfecha_id
                                       and   f.contratospersona_id = p.id) identinombre,
                                       (select concat(p.direccion,' Tel: ',p.movil) from contratosperfechas f, contratospersonas p
                                         where f.id = compromisos.contratosperfecha_id
                                         and   f.contratospersona_id = p.id) direcciontelefono,
                                       (select p.descripcion2 from contratosperfechas f, contratossecciones p
                                         where f.id = compromisos.contratosperfecha_id
                                         and   f.contratosseccion_id = p.id) seccion,
                                       (select concat(f.identificacion,' - ',f.nombre) from personasformularios f
                                        where f.id = compromisos.personasformulario_id) formulario")
                             .where("DATE_FORMAT(fecha_entrega, '%Y-%m') = '#{@fecha}' #{vcConsultaAdd}")
=end                             
  end

  def show_detalle_contrato_entrega
    @ruta = params[:ruta]
    @fecha = params[:fecha]
    @contratoId = params[:contrato_id]
    @fechaparams = @fecha.gsub('-', '_')
    @contratosperdotaciones = Contratosperdotacion.select("(select autobuscar from contratospersonas where id = contratosperdotaciones.contratospersona_id) nombreemp,
                                                           (select autobuscar from empresas where id = (select empresa_id from contratos where id = contratosperdotaciones.contrato_id)) identnombre,
                                                           (select nro_contrato from contratos where id = contratosperdotaciones.contrato_id) nro_contrato,
                                                           contratosperdotaciones.*")
                                                  .where("contratosperdotaciones.estado in ('PENDIENTE','ENTREGADO') and contratosperdotaciones.fecha_prox_entrega = '#{@fecha}' and contratosperdotaciones.contrato_id = #{@contratoId}").order("1 asc")
  end

  def searchdotacion_todo
    @p = params[:estado]
    paginador = eval("params[:dota_#{@p.downcase.gsub("-", "")}]")
    if params[:autobuscar].present?
      @contratosprefechasdotacion_todo = Contratosperfecha.where("val_dotacion = '#{@p}' and dotacion = 'SI' and estado = 'ACTIVO' and contratospersona_id in (select id from contratospersonas where autobuscar like '%#{params[:autobuscar]}%')").order("id asc").paginate(:page => paginador, :per_page => 10)
    end
  end

  def show_detalle_dotacion
    @p = params[:val_dotacion]
    @ruta = params[:ruta]
    @estado_car = params[:estado]
    @contrato = Contrato.find(params[:contrato_id])
    paginador = eval("params[:dota_#{@p.downcase.gsub("-", "")}_#{@contrato.id}]")
    @contratosprefechasdotacion = Contratosperfecha.where("val_dotacion = '#{@p}' and dotacion = 'SI' and estado = 'ACTIVO'").order("id asc").paginate(:page => paginador, :per_page => 10)
  end

  def searchdotacion
    @contrato = Contrato.find(params[:contrato_id])
    @p = params[:val_dotacion]
    @variable = "dota_#{@p.downcase.gsub("-", "")}_#{@contrato.id}"
    paginador = eval("params[:dota_#{@p.downcase.gsub("-", "")}_#{@contrato.id}]")
    eval("@contratosprefechasdotacion#{@contrato.id}#{@p.downcase}")
    if params[:autobuscar].present?
      sql = 'Contratosperfecha.where("contrato_id = #{@contrato.id} and val_dotacion = ' + "'" + "#{params[:val_dotacion]}" + "'" + ' and dotacion = ' + "'" + 'SI' + "'" + "and estado = " + "'" + 'ACTIVO' + "' and contratospersona_id in (select id from contratospersonas where autobuscar like " + "'" + "%#{params[:autobuscar]}%" + "'" + ')").paginate(:page => paginador, :per_page => 10)'
      eval("@#{@variable} = #{sql}")
    else
      sql = 'Contratosperfecha.where("contrato_id = #{@contrato.id} and val_dotacion = ' + "'" + "#{params[:val_dotacion]}" + "'" + ' and dotacion = ' + "'" + 'SI' + "'" + "and estado = " + "'" + 'ACTIVO' + "'" + '").paginate(:page => paginador, :per_page => 10)'
      eval("@#{@variable} = #{sql}")
    end
  end

  def searchsalud_todo
    @p = params[:estado]
    paginador = eval("params[:sal_#{@p.downcase.gsub("-", "")}]")
    if params[:autobuscar].present?
      if current_user.etapa == "SAL_PENDIENTE"
        @contratosprefechassalud_todo = Contratosperfecha.where("estado = 'ACTIVO' and (eps = 'SI' or arl = 'SI' or afp = 'SI' or ccaf = 'SI') and DATE_FORMAT(created_at,'%Y-%m-%d') >= '2023-02-23' and val_salud = 'PENDIENTE' and contratospersona_id in (select id from contratospersonas where autobuscar like '%#{params[:autobuscar]}%')").
          paginate(:page => paginador, :per_page => 10)
      else
        @contratosprefechassalud_todo = Contratosperfecha.where("estado = 'ACTIVO' and (eps = 'SI' or arl = 'SI' or afp = 'SI' or ccaf = 'SI') and DATE_FORMAT(created_at,'%Y-%m-%d') >= '2023-02-23' and val_salud = 'AFILIADO'  and contratospersona_id in (select id from contratospersonas where  autobuscar like '%#{params[:autobuscar]}%')").
          paginate(:page => paginador, :per_page => 10)
      end
    end
  end

  def searchevalua_documento
    @p = params[:estado]
    paginador = eval("params[:eval_#{@p.downcase.gsub("-", "")}]")
    estado = current_user.etapa.gsub("EVAL_", "")
    if params[:autobuscar].present?
      @contratosperimagenes = Contratosperimagen.where("contratospersona_id in (select id from contratospersonas where autobuscar like '%#{params[:autobuscar]}%') and estado = '#{estado}' AND descripcion IN (SELECT descripcion FROM iparametros WHERE id IN (SELECT iparametro_id FROM iparametrosusers WHERE user_id = #{is_admin}))").order("id asc").paginate(:page => paginador, :per_page => 10)
    else
      @contratosperimagenes = Contratosperimagen.where("estado = '#{estado}' AND descripcion IN (SELECT descripcion FROM iparametros WHERE id IN (SELECT iparametro_id FROM iparametrosusers WHERE user_id = #{is_admin}))").order("id asc").paginate(:page => paginador, :per_page => 10)
    end
  end

  def show_detalle_salud
    @p = params[:val_salud]
    @ruta = params[:ruta]
    @estado_car = params[:estado]
    @contrato = Contrato.find(params[:contrato_id])
    paginador = eval("params[:sal_#{@p.downcase.gsub("-", "")}_#{@contrato.id}]")
    if current_user.etapa == "SAL_PENDIENTE"
      @contratosprefechassalud = Contratosperfecha.where("contrato_id = #{@contrato.id} and estado = 'ACTIVO' and (eps = 'SI' or arl = 'SI' or afp = 'SI' or ccaf = 'SI') and DATE_FORMAT(created_at,'%Y-%m-%d') >= '2023-02-23' and val_salud = 'PENDIENTE' and contratospersona_id in (select id from contratospersonas where autobuscar like '%#{params[:autobuscar]}%')").
        paginate(:page => paginador, :per_page => 10)
    else
      @contratosprefechassalud = Contratosperfecha.where("contrato_id = #{@contrato.id} and estado = 'ACTIVO' and (eps = 'SI' or arl = 'SI' or afp = 'SI' or ccaf = 'SI') and DATE_FORMAT(created_at,'%Y-%m-%d') >= '2023-02-23' and val_salud = 'AFILIADO' and contratospersona_id in (select id from contratospersonas where  autobuscar like '%#{params[:autobuscar]}%')").
        paginate(:page => paginador, :per_page => 10)
    end
  end

  def show_detalle_salud_contratos
    @ruta = params[:ruta]
    @estado = params[:estado]
    @contratosperfecha = Contratosperfecha.find(params[:id])
    @contratosperfechasdocs = @contratosperfecha.contratosperfechasdocs
  end

  def show_detalle_salud_observacion
    @ruta = params[:ruta]
    @estado = params[:estado]
    @contratosperfecha = Contratosperfecha.find(params[:id])
    @contratospernotas = Contratospernota.where("contratosperfecha_id = #{@contratosperfecha.id} and contratospersona_id = #{@contratosperfecha.contratospersona_id}")
  end

  def show_detalle_docfirma
    @p = params[:val_docfirma]
    @ruta = params[:ruta]
    @estado_car = params[:estado]
    @contrato = Contrato.find(params[:contrato_id])
    paginador = eval("params[:doc_#{@p.downcase.gsub("-", "")}_#{@contrato.id}]")
    if current_user.etapa == "DOC_PENDIENTE"
      @contratosprefechasdocfirma = Contratosperfecha.where("contrato_id = #{@contrato.id} and id in (select id_registro from controlfirmas where controlador = 'contratosperfechas' and fecha_firma is null)")
                                                     .paginate(:page => paginador, :per_page => 10)
    elsif current_user.etapa == "DOC_FIRMADO"
      @contratosprefechasdocfirma = Contratosperfecha.where("contrato_id = #{@contrato.id} and id in (select id_registro from controlfirmas where controlador = 'contratosperfechas' and fecha_firma is not null)")
                                                     .paginate(:page => paginador, :per_page => 10)
    elsif current_user.etapa == "DOC_CONTRATO"
      @contratosprefechasdocfirma = Contratosperfecha.where("contrato_id = #{@contrato.id} and sol_firma_digital = 'SI'")
                                                     .paginate(:page => paginador, :per_page => 20)
    end
  end

  def searchdocfirma
    @contrato = Contrato.find(params[:contrato_id])
    @p = params[:val_docfirma]
    @variable = "doc_#{@p.downcase.gsub("-", "")}_#{@contrato.id}"
    paginador = eval("params[:doc_#{@p.downcase.gsub("-", "")}_#{@contrato.id}]")
    if params[:autobuscar].present?
      if current_user.etapa == "DOC_PENDIENTE"
        sql = 'Contratosperfecha.where("contrato_id = #{@contrato.id} and id in (select id_registro from controlfirmas where fecha_firma is null) and contratospersona_id in (select id from contratospersonas where autobuscar like ' + "'" + "%#{params[:autobuscar]}%" + "'" + ')").paginate(:page => paginador, :per_page => 10)'
        eval("@#{@variable} = #{sql}")
      elsif current_user.etapa == "DOC_FIRMADO"
        sql = 'Contratosperfecha.where("contrato_id = #{@contrato.id} and id in (select id_registro from controlfirmas where fecha_firma is not null) and contratospersona_id in (select id from contratospersonas where autobuscar like ' + "'" + "%#{params[:autobuscar]}%" + "'" + ')").paginate(:page => paginador, :per_page => 10)'
        eval("@#{@variable} = #{sql}")
      elsif current_user.etapa == "DOC_CONTRATO"
        sql = 'Contratosperfecha.where("contrato_id = #{@contrato.id} and sol_firma_digital = ' + "'" + 'SI' + "'" + ' and contratospersona_id in (select id from contratospersonas where autobuscar like ' + "'" + "%#{params[:autobuscar]}%" + "'" + ')").paginate(:page => paginador, :per_page => 20)'
        eval("@#{@variable} = #{sql}")
      end
    else
      if current_user.etapa == "DOC_PENDIENTE"
        sql = 'Contratosperfecha.where("contrato_id = #{@contrato.id} and id in (select id_registro from controlfirmas where fecha_firma is null)").paginate(:page => paginador, :per_page => 10)'
        eval("@#{@variable} = #{sql}")
      elsif current_user.etapa == "DOC_FIRMADO"
        sql = 'Contratosperfecha.where("contrato_id = #{@contrato.id} and id in (select id_registro from controlfirmas where fecha_firma is not null)").paginate(:page => paginador, :per_page => 10)'
        eval("@#{@variable} = #{sql}")
      elsif current_user.etapa == "DOC_CONTRATO"
        sql = 'Contratosperfecha.where("contrato_id = #{@contrato.id} and sol_firma_digital = ' + "'" + 'SI' + "'" + '").paginate(:page => paginador, :per_page => 20)'
        eval("@#{@variable} = #{sql}")
      end
    end
  end

  def searchdocfirma_todo
    @p = params[:estado]
    paginador = eval("params[:doc_#{@p.downcase.gsub("-", "")}]")
    if params[:autobuscar].present?
      if current_user.etapa == "DOC_PENDIENTE"
        @contratosprefechasdocfirma_todo = Contratosperfecha.where("id in (select id_registro from controlfirmas where fecha_firma is null) and contratospersona_id in (select id from contratospersonas where autobuscar like '%#{params[:autobuscar]}%')")
                                                            .paginate(:page => paginador, :per_page => 10)
      elsif current_user.etapa == "DOC_FIRMADO"
        @contratosprefechasdocfirma_todo = Contratosperfecha.where("id in (select id_registro from controlfirmas where fecha_firma is not null) and contratospersona_id in (select id from contratospersonas where autobuscar like '%#{params[:autobuscar]}%')")
                                                            .paginate(:page => paginador, :per_page => 10)
      elsif current_user.etapa == "DOC_CONTRATO"
        @contratosprefechasdocfirma_todo = Contratosperfecha.where("sol_firma_digital = 'SI' and contratospersona_id in (select id from contratospersonas where autobuscar like '%#{params[:autobuscar]}%')")
                                                            .paginate(:page => paginador, :per_page => 20)
      end
    end
  end

  def abrir_documentos
    @contratosperfecha = Contratosperfecha.find(params[:id])
  end

  def abrir_documentos_contrato
    @contratosperfecha = Contratosperfecha.find(params[:id])
  end

  def abrir_formatos
    @contratosperfecha = Contratosperfecha.find(params[:id])
  end

  def call
    #@call = "http://google.com"
  end

  def etapar
    if params[:etapa].present?
      User.where(id: is_admin).update_all(etapa: params[:etapa].to_s, updated_at: Time.now)
    end
    redirect_to root_path
  end

  def etapac
    if params[:etapa].present?
      User.where(id: is_admin).update_all(etapa: params[:etapa].to_s, updated_at: Time.now)
    end
    redirect_to root_path
  end

  def marcar_visto
    @personasformulariosdoc = Personasformulariosdoc.find(params[:id])
    @personasformulariosdoc.visualizado = 'SI'
    @personasformulariosdoc.save(validate: false)
  end

  def control_firma_digital
    cf = Controlformato.find(params[:controlfirma_id])
    contratospersonaId = Contratosperfecha.find(params[:id_registro]).contratospersona_id
    @controlador = cf.controlador
    @url = cf.url
    @modelo = cf.modelo
    @tipo_documento = cf.tipo_documento
    @idRegistro = params[:id_registro]
    @user_firma = params[:user_firma]
    @portafolio = is_portafolio
    user = User.find(@user_firma)
    @control = Controlfirma.where(controlador: @controlador, id_registro: @idRegistro, estado: 'PENDIENTE',
                                  url: @url, tipo_documento: @tipo_documento, modelo: @modelo, portafolio_id: @portafolio,
                                  user_firma: @user_firma, controlformato_id: cf.id, user_solicitante: is_admin).first_or_create
    mensaje = "ASEAR: Estimad@ #{user.nombre rescue nil}, se ha solicitado la firma del documento (#{cf.tipo_documento.to_s rescue nil}), recuerda que debes de iniciar sesión para firmarlo, animo pues!".html_safe
    Asearsms::SendsmsServices.new.send_sms_procesos(user.celular, mensaje)
    Asearmail::SendmailServices.new.sendEmailCodigo(user.email, "Solicitud Firma de Documento", "asear_mailer/envio_informacion.html.erb", nil, nil, user.id,cf.tipo_documento.to_s)
    redirect_to edit_contratospersona_path(contratospersonaId)
  end

  private

  def set_layout
    if ['consultaexterna', 'consultaliq', 'cartapresentacion', 'search_contrato', 'search_contratopre', 'search_contratoliq'].include?(action_name)
      "consulta_carta_layouts"
    elsif ['call'].include?(action_name)
      "call"
    elsif ['PERSONA', 'METRO'].include?(User.find(is_admin).tipoconsulta.to_s)
      # if ['actividades','firmadigital'].include?(action_name)
      #  "inscripcion_layoutmetro"
      # else
      'application'
      # end
    else
      'application_admin'
    end
  end
end
