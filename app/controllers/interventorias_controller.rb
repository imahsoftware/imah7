class InterventoriasController < ApplicationController
  layout :determine_layout
  before_action :set_interventoria, only: %i[show edit update destroy envio enviofinalgh
                                              enviofinalint aprobarint rechazarint aprobar
                                              rechazar enviogh aprobargh_modal rechazargh_modal
                                              rechazarghfinal_modal aprobarghfinal_modal
                                              aprobarcont_modal aprobargh rechazargh
                                              aprobarghfinal rechazarghfinal aprobarcont
                                              rechazarcont firmar_digital firmar_informes
                                              revisioninter revisionfinal verificacionfinal
                                              verificacion validaresp recargar_actividades
                                              obs_calculofinal actualizacionact
                                              aprobar_supervisor_gh_modal generar_otp_supervisor_gh
                                              aprobar_supervisor_gh rechazar_supervisor_gh_modal
                                              rechazar_supervisor_gh]

  # ─── INDEX ─────────────────────────────────────────────────────────────────
  # Dashboard principal — el contenido varía según la etapa del usuario
  def index
    @user = current_user_obj
    # Cargar empleado para verificar contratos vigentes en el sidebar
    if @user.identificacion.present?
      @empleado = Contratospersona.find_by(identificacion: @user.identificacion)
    end
    cargar_datos_por_etapa(@user)

    if is_auth_c("interventoriagh")
      @objetos = Contratosperfecha
                   .joins(:contratospernominas)
                   .where(
                     "YEAR(contratosperfechas.fecha_inicio) = YEAR(CURDATE()) AND " \
                       "MONTH(contratosperfechas.fecha_inicio) = MONTH(CURDATE())"
                   )
                   .select(
                     "DISTINCT MONTH(contratosperfechas.fecha_inicio) AS mes, " \
                       "YEAR(contratosperfechas.fecha_inicio)           AS ano, " \
                       "LPAD(MONTH(contratosperfechas.fecha_inicio),2,'0') AS mesc"
                   )
                   .order("ano DESC, mes DESC")
    end

    if is_auth_c("interventoriacont")
      @objetos = Contratosperfecha
                   .joins(:contratospernominas)
                   .where(
                     "YEAR(contratosperfechas.fecha_inicio) = YEAR(CURDATE()) AND " \
                       "MONTH(contratosperfechas.fecha_inicio) <= MONTH(CURDATE())"
                   )
                   .select(
                     "DISTINCT MONTH(contratosperfechas.fecha_inicio) AS mes, " \
                       "YEAR(contratosperfechas.fecha_inicio)           AS ano, " \
                       "LPAD(MONTH(contratosperfechas.fecha_inicio),2,'0') AS mesc"
                   )
                   .order("ano DESC, mes DESC")
    end

    if is_auth_c("interventoriatesoreria")
      @objetos = Contratosperfecha
                   .joins(:contratospernominas)
                   .where(
                     "YEAR(contratosperfechas.fecha_inicio) = YEAR(CURDATE()) AND " \
                       "MONTH(contratosperfechas.fecha_inicio) <= MONTH(CURDATE())"
                   )
                   .select(
                     "DISTINCT MONTH(contratosperfechas.fecha_inicio) AS mes, " \
                       "YEAR(contratosperfechas.fecha_inicio)           AS ano, " \
                       "LPAD(MONTH(contratosperfechas.fecha_inicio),2,'0') AS mesc"
                   )
                   .order("ano DESC, mes DESC")
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  # ─── BUSCAR (AJAX) ─────────────────────────────────────────────────────────
  def buscar
    filtros = params.slice(:buscar, :anno, :mes, :estado)
    return unless filtros.values.any?(&:present?)

    scope = Interventoria.includes(contratosperfecha: :contratospersona, contrato: :tiposcontrato)

    if params[:buscar].present?
      termino = "%\#{params[:buscar].upcase.gsub(' ', '%')}%"
      scope = scope.joins(contratosperfecha: :contratospersona)
                   .where("UPPER(contratospersonas.identificacion) LIKE ? OR UPPER(contratospersonas.autobuscar) LIKE ?",
                          termino, termino)
    end

    scope = scope.where(anno: params[:anno]) if params[:anno].present?
    scope = scope.where(mes: params[:mes].to_s.rjust(2, '0')) if params[:mes].present?
    scope = scope.where(estado: params[:estado]) if params[:estado].present?

    @interventorias = scope.order(anno: :desc, mes: :desc).limit(100)
    @sin_resultados = @interventorias.empty?

    respond_to do |format|
      format.js
    end
  end

  # ─── CRUD BÁSICO ──────────────────────────────────────────────────────────
  def new
    @interventoria = Interventoria.new(
      contrato_id: params[:contrato_id],
      etapa: '1'
    )
    render :interventoria_form
  end

  def edit
    Interventoria.where(id: params[:id]).update_all(etapa: params[:etapa]) if params[:etapa].present?
    @interventoria = Interventoria.find(params[:id])
    render :interventoria_form
  end

  def create
    @interventoria = Interventoria.new(interventoria_params)
    @interventoria.user_id = is_admin
    if @interventoria.save
      @interventoria.registrar_bitacora(is_admin, "SE CREA EL PROCESO")
      flash[:notice] = "Informe creado con éxito."
      redirect_to edit_interventoria_path(@interventoria)
    else
      render :interventoria_form
    end
  end

  def update
    @interventoria.user_actualiza = is_admin
    if @interventoria.update(interventoria_params)
      flash[:notice] = "Informe actualizado con éxito."
      redirect_to edit_interventoria_path(@interventoria)
    else
      render :interventoria_form
    end
  rescue StandardError
    flash[:alert] = "Existen inconsistencias. Verifique!!!"
    redirect_to edit_interventoria_path(@interventoria)
  end

  def destroy
    @interventoria.destroy
    flash[:notice] = "El informe y sus componentes han sido eliminados con éxito."
    redirect_to interventorias_path
  end

  # ─── FLUJO DE ESTADOS ─────────────────────────────────────────────────────

  # Contratista envía para revisión del supervisor
  def envio
    @interventoria.update!(estado: 'REVISION')
    @interventoria.registrar_bitacora(is_admin, "SE ENVIA PARA REVISION DEL SUPERVISOR")
    flash[:notice] = "El informe ha sido enviado para revisión"
    redirect_to interventorias_path
  end

  # Supervisor aprueba → va a GH
  def aprobar
    msn = if @interventoria.estado.to_s == 'APROBADO' || @interventoria.fin_anno == 'SI'
            @interventoria.update!(estado: 'APROBADOGH',
                                   firma_digital_supervisor: SecureRandom.hex(14),
                                   fecha_firma_supervisor: Time.now)
            "INFORME APROBADO POR TALENTO HUMANO"
          else
            @interventoria.update!(estado: 'APROBADO',
                                   firma_digital_supervisor: SecureRandom.hex(14),
                                   fecha_firma_supervisor: Time.now)
            "INFORME APROBADO POR SUPERVISOR"
          end
    @interventoria.registrar_bitacora(is_admin, msn)
    enviar_correo_contratista('sendpendiente')
    flash[:notice] = "El informe ha sido aprobado"
    redirect_to interventorias_path
  end

  # Supervisor rechaza
  def rechazar
    msn = if @interventoria.estado.to_s == 'APROBADO'
            @interventoria.update!(estado: 'RECHAZADOGH')
            "INFORME RECHAZADO POR TALENTO HUMANO"
          else
            @interventoria.update!(estado: 'RECHAZADO')
            "INFORME RECHAZADO POR SUPERVISOR"
          end
    @interventoria.registrar_bitacora(is_admin, msn)
    enviar_correo_contratista('sendrechazo')
    flash[:notice] = "El informe ha sido rechazado"
    redirect_to interventorias_path
  end

  # Interventor aprueba → va a GH
  def aprobarint
    @interventoria.update!(estado: 'REVISIONFINALGH')
    @interventoria.registrar_bitacora(is_admin, "INFORME APROBADO POR EL SUPERVISOR")
    flash[:notice] = "El informe ha sido aprobado y enviado a validación del SGSST"
    redirect_to interventorias_path
  end

  # Interventor rechaza
  def rechazarint
    @interventoria.update!(estado: 'RECHAZADOFINALINT')
    motivo = params[:observacion_rechazo].to_s.strip.presence || "INFORME RECHAZADO POR EL SUPERVISOR"
    @interventoria.registrar_bitacora(is_admin, "INFORME RECHAZADO POR EL SUPERVISOR — #{motivo}")
    flash[:alert] = "El informe ha sido rechazado."
    redirect_to interventorias_path
  end

  # Envío final a interventor
  def enviofinalint
    @interventoria.update!(estado: 'REVISIONFINALINT')
    flash[:notice] = "El informe ha sido enviado para revisión"
    enviar_correo_contabilidad
    redirect_to interventorias_path
  end

  # GH envía para validación final
  def enviofinalgh
    @interventoria.update!(estado: 'REVISIONFINALGH', fin_anno: params[:fin_anno])
    @interventoria.registrar_bitacora(is_admin, "SE ENVIA PARA VALIDACION DEL SGSST")
    flash[:notice] = "El informe ha sido enviado para revisión"
    redirect_to interventorias_path
  end

  # GH aprueba con OTP
  def aprobargh
    if verificar_otp
      @interventoria.update!(estado: 'APROBADOGH')
      @interventoria.registrar_bitacora(is_admin, "INFORME VALIDADO POR EL SGSST")
      enviar_correo_contratista('sendaprobacion')
      flash[:notice] = "El informe ha sido aprobado"
    else
      flash[:error] = "Código OTP inválido."
    end
    @validacion = @otp_valid
  end

  # GH rechaza con OTP
  def rechazargh
    if verificar_otp
      @interventoria.update!(estado: 'RECHAZADOGH', fin_anno: nil)
      @interventoria.registrar_bitacora(is_admin, "INFORME RECHAZADO POR EL SGSST")
      enviar_correo_contratista('sendrechazog')
      flash[:notice] = "El informe ha sido rechazado"
    else
      flash[:error] = "Código OTP inválido."
    end
    @validacion = @otp_valid
  end

  # GH aprueba informe final con OTP
  def aprobarghfinal
    if verificar_otp
      @interventoria.update!(estado: 'PENDIENTE', bloqueado: 'S')
      bloquear_actividades_ss
      @interventoria.registrar_bitacora(is_admin, "INFORME APROBADO FINAL POR GH")
      enviar_correo_contratista('sendaprobacionfinalrh')
      enviar_correo_contabilidad
      flash[:notice] = "El informe ha sido aprobado"
    else
      flash[:error] = "Código OTP inválido."
    end
    @validacion = @otp_valid
  end

  # GH rechaza informe final con OTP
  def rechazarghfinal
    if verificar_otp
      @interventoria.update!(estado: 'RECHAZADOFINALGH', fin_anno: nil)
      @interventoria.registrar_bitacora(is_admin, "INFORME RECHAZADO POR EL SGSST")
      enviar_correo_contratista('sendrechazogfinal')
      flash[:notice] = "El informe ha sido rechazado"
    else
      flash[:error] = "Código OTP inválido."
    end
    @validacion = @otp_valid
  end

  # Contabilidad aprueba con OTP
  def aprobarcont
    @interventoria = Interventoria.find(params[:id])
    otp_ingresado = (1..6).map { |i| params["nr#{i}"] }.join
    
    # Verificar OTP de la sesión
    otp_data = session[:otp_contabilidad]
    @validacion = false
    
    if otp_data.nil?
      flash[:error] = "No se ha generado un código OTP. Por favor, solicite uno nuevo."
    elsif (otp_data['interventoria_id'] || otp_data[:interventoria_id]).to_s != @interventoria.id.to_s
      flash[:error] = "El código OTP no corresponde a este informe."
    elsif (Time.now.to_i - (otp_data['timestamp'] || otp_data[:timestamp]).to_i) > 300 # 5 minutos
      flash[:error] = "El código OTP ha expirado. Por favor, solicite uno nuevo."
      session.delete(:otp_contabilidad)
    elsif (otp_data['codigo'] || otp_data[:codigo]).to_s != otp_ingresado.to_s
      flash[:error] = "Código OTP inválido. Por favor, verifique e intente nuevamente."
    else
      @validacion = true
      @interventoria.update!(
        estado: 'APROBADOCONT',
        firma_digital_supervisor: SecureRandom.hex(14),
        fecha_firma_supervisor: Time.now
      )
      @interventoria.registrar_bitacora(is_admin, "INFORME APROBADO POR CONTABILIDAD")
      
      # Enviar correo al contratista
      enviar_correo_contratista('sendaprobacion')
      
      flash[:notice] = "El informe ha sido aprobado exitosamente"
      session.delete(:otp_contabilidad)
    end
    
    respond_to do |format|
      format.js
    end
  end

  # ─── CONTABILIDAD: GENERAR OTP POR SMS ────────────────────────────────────
  def generar_otp_contabilidad
    @interventoria = Interventoria.find(params[:id])
    user = User.find(is_admin)
    
    # Generar código OTP de 6 dígitos (sin ceros para evitar confusión)
    codigo_otp = 6.times.map { rand(1..9) }.join
    
    # Guardar el código en la sesión con timestamp
    session[:otp_contabilidad] = {
      codigo: codigo_otp,
      interventoria_id: @interventoria.id,
      timestamp: Time.now.to_i
    }
    
    # Log para depuración
    logger.info("=== GENERANDO OTP CONTABILIDAD ===")
    logger.info("Interventoria ID: #{@interventoria.id}")
    logger.info("Código OTP generado: #{codigo_otp}")
    logger.info("Sesión guardada: #{session[:otp_contabilidad].inspect}")
    
    # Enviar SMS (solo una vez)
    @sms_enviado = false
    @mensaje_sms = ""
    
    begin
      if user.celular.present?
        mensaje = "IMAH - Codigo de verificacion para aprobar informe: #{codigo_otp}. Valido por 5 minutos."
        WsController.smscolombiared(user.celular.to_s, mensaje)
        @mensaje_sms = "SMS enviado exitosamente al #{user.celular}"
        @sms_enviado = true
        logger.info("SMS OTP enviado a #{user.celular} - Código: #{codigo_otp}")
      else
        @mensaje_sms = "Error: El usuario no tiene número de celular registrado"
        @sms_enviado = false
        logger.error("Usuario #{user.id} no tiene celular registrado")
      end
    rescue StandardError => e
      logger.error("Error enviando SMS OTP: #{e.message}")
      @mensaje_sms = "Error al enviar SMS: #{e.message}"
      @sms_enviado = false
    end
    
    respond_to do |format|
      format.js
    end
  end

  # Contabilidad rechaza
  def rechazarcont
    @interventoria.update!(estado: 'RECHAZADOCONT')
    @interventoria.registrar_bitacora(is_admin, "INFORME RECHAZADO POR CONTABILIDAD")
    flash[:notice] = "El informe ha sido rechazado"
    redirect_to interventorias_path
  end

  # Firma digital del empleado con OTP
  def firmar_informes
    if verificar_otp
      @interventoria.update!(
        firma_digital_empleado: SecureRandom.hex(14),
        fecha_firma_empleado: Time.now
      )
      flash[:notice] = "Tu informe ha sido firmado con éxito."
    else
      flash[:error] = "Código OTP inválido."
    end
    @validacion = @otp_valid
  end

  # ─── VISTAS DE REVISION ───────────────────────────────────────────────────
  def revisioninter; end

  def revisionfinal; end

  def verificacionfinal
    @interventoria = Interventoria.find(params[:id])
  end

  def verificacion; end

  def firmar_digital; end

  # ─── MODALES OTP ──────────────────────────────────────────────────────────
  def aprobargh_modal; end

  def rechazargh_modal; end

  def rechazarghfinal_modal; end

  def aprobarghfinal_modal; end

  def aprobarcont_modal; end

  # ─── CALCULO DE RETENCION (AJAX) ─────────────────────────────────────────
  # Un solo método reemplaza los 8 obs_* duplicados del original
  def recalcular_retencion
    @interventoria = Interventoria.find(params[:id])
    resultado = Interventoria.calcular_retencion(
      valor_mes: @interventoria.valor_mes.to_i,
      salud: params[:salud].to_i,
      arl: params[:arl].to_i,
      pension: params[:pension].to_i,
      interes_credito: params[:interes_credito].to_i,
      salud_prepagada: params[:salud_prepagada].to_i,
      dependientes: params[:dependientes].to_i,
      afc: params[:afc].to_i,
      voluntarias: params[:voluntarias].to_i,
      base_uvt_config: valor_config(:base_uvt),
      retefuente383_config: valor_config(:retefuente383),
      retefuente384_config: valor_config(:retefuente384)
    )

    @interventoria.assign_attributes(
      salud: params[:salud].to_i,
      arl: params[:arl].to_i,
      pension: params[:pension].to_i,
      interes_credito: params[:interes_credito].to_i,
      salud_prepagada: params[:salud_prepagada].to_i,
      dependientes: params[:dependientes].to_i,
      afc: params[:afc].to_i,
      voluntarias: params[:voluntarias].to_i,
      subtotalr: resultado[:subtotalr]
    )
    @interventoria.save

    render json: resultado
  end

  # ─── CALCULO FINAL CON VALIDACIONES DE LIMITES ───────────────────────────
  # Aplica límites fiscales: 30% para AFC+voluntarias+pensión, topes de prepagada, etc.
  def obs_calculofinal
    @interventoria = Interventoria.find(params[:id])
    
    pvr0 = @interventoria.valor_mes.to_i
    pvr1 = params[:pvr1].to_i # salud
    pvr2 = params[:pvr2].to_i # arl
    pvr3 = params[:pvr3] # interes_credito (puede ser valor o 'SI'/'NO')
    pvr4 = params[:pvr4] # salud_prepagada (puede ser valor o 'SI'/'NO')
    pvr5 = params[:pvr5] # dependientes (valor numérico)
    pvr6 = params[:pvr6].to_i # pension
    pvr7 = params[:pvr7].to_i # afc
    pvr8 = params[:pvr8].to_i # voluntarias

    # Aplicar límite del 30% para pensión + afc + voluntarias
    limite_treinta = (pvr0 * 0.3).to_i
    ajuste_afc_vol = ""
    
    if (pvr7 + pvr8 + pvr6) >= limite_treinta
      if pvr7 > pvr8
        pvr7 = [limite_treinta - (pvr8 + pvr6), 0].max
        ajuste_afc_vol = 'S'
      elsif pvr8 > pvr7
        pvr8 = [limite_treinta - (pvr7 + pvr6), 0].max
        ajuste_afc_vol = 'S'
      end
    end

    # Normalizar interés de crédito
    ajuste_interes = ""
    pvr3 = if pvr3 == 3185900 || pvr3.to_s.upcase == 'SI'
             ajuste_interes = 'S'
             3185900
           else
             0
           end

    # Normalizar salud prepagada con límite
    ajuste_prepagada = ""
    limite_prepagada = @interventoria.limite_prepagada
    pvr4 = if pvr4 == 509744 || pvr4.to_s.upcase == 'SI'
             ajuste_prepagada = 'S'
             [509744, limite_prepagada].min
           else
             0
           end

    # Aplicar límite de dependientes
    ajuste_dependientes = ""
    limite_dependencia = @interventoria.limite_dependencia
    if pvr5.to_i >= limite_dependencia
      pvr5 = limite_dependencia
      ajuste_dependientes = 'S'
    end

    # Cálculos fiscales
    vlrincr = pvr0 - (pvr1 + pvr6)
    subtotalr = pvr7 + pvr8
    subtotal = pvr2 + pvr3 + pvr4 + pvr5.to_i
    subtotalt = vlrincr - subtotalr - subtotal
    renta = (subtotalt * 25) / 100
    total_rentas = renta + subtotalr + subtotal
    
    # Límite del 40% del ingreso
    cuarenta = (vlrincr * 0.4).to_i
    total_rentas = [total_rentas, cuarenta].min
    
    base_retefuente = vlrincr - total_rentas
    base_uvt = (base_retefuente.to_f / valor_config(:base_uvt)).round(0).to_i
    
    vlr1 = Interventoria.calcular_uvt_383(base_uvt)
    retefuente383 = (vlr1 * valor_config(:retefuente383)).round(-3).to_i
    total = pvr0 - retefuente383

    # Actualizar el registro
    @interventoria.assign_attributes(
      salud: pvr1,
      arl: pvr2,
      interes_credito: pvr3,
      salud_prepagada: pvr4,
      dependientes: pvr5,
      pension: pvr6,
      afc: pvr7,
      voluntarias: pvr8,
      subtotalr: subtotalr,
      subtotal: subtotal,
      subtotalt: subtotalt,
      renta: renta,
      total_rentas: total_rentas,
      base_retefuente: base_retefuente,
      base_uvt: base_uvt,
      retefuente383: retefuente383,
      total: total
    )
    
    if @interventoria.save
      respond_to do |format|
        format.js do
          render json: {
            success: true,
            salud_prepagada: pvr4,
            interes_credito: pvr3,
            dependientes: pvr5,
            afc: pvr7,
            voluntarias: pvr8,
            subtotalr: subtotalr,
            total: total,
            ajuste_interes: ajuste_interes,
            ajuste_prepagada: ajuste_prepagada,
            ajuste_dependientes: ajuste_dependientes,
            ajuste_afc_vol: ajuste_afc_vol
          }
        end
      end
    else
      render json: { success: false, errors: @interventoria.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # ─── ACTUALIZAR ACTIVIDADES PENDIENTES ───────────────────────────────────
  # Recarga las actividades desde el procedimiento almacenado (si existe)
  # o desde la configuración del cargo
  def actualizacionact
    @interventoria = Interventoria.find(params[:id])
    
    # Intentar ejecutar procedimiento almacenado si existe (compatibilidad Oracle)
    begin
      ActiveRecord::Base.connection.execute(
        "BEGIN prc_interventoriapendientes(#{@interventoria.id}); END;"
      )
      flash[:notice] = "El informe de Supervisión ha sido actualizado en sus actividades"
    rescue ActiveRecord::StatementInvalid => e
      # Si no existe el procedimiento, recargar desde cargo
      if @interventoria.bloqueado?
        flash[:alert] = "Informe bloqueado, no se pueden actualizar actividades."
      else
        perfecha = @interventoria.contratosperfecha
        cargo_id = perfecha&.contratoscargo_id
        
        if cargo_id.present?
          @interventoria.interactividades.destroy_all
          @interventoria.registrar_obligaciones(cargo_id)
          flash[:notice] = "Actividades actualizadas con éxito (#{@interventoria.interactividades.count} obligaciones)."
        else
          flash[:alert] = "No se encontró el cargo asociado. Verifique la configuración del contrato."
        end
      end
    end
    
    redirect_to interventorias_path
  end

  # ─── ENVIO A GESTION HUMANA ──────────────────────────────────────────────
  # El supervisor envía el informe aprobado a Gestión Humana
  def enviogh
    @interventoria.update!(estado: 'APROBADO')
    @interventoria.registrar_bitacora(is_admin, "INFORME ENVIADO AL SGSST")
    flash[:notice] = "El informe ha sido enviado para revisión de Gestión Humana"
    redirect_to interventorias_path
  end

  # ─── SUPERVISOR GH: APROBAR CON OTP Y SMS ────────────────────────────────
  # Modal para aprobar con OTP (Supervisor de Gestión Humana)
  def aprobar_supervisor_gh_modal
    @interventoria = Interventoria.find(params[:id])
  end

  # Genera y envía OTP por SMS al supervisor de GH
  def generar_otp_supervisor_gh
    @interventoria = Interventoria.find(params[:id])
    user = User.find(is_admin)
    
    # Generar código OTP de 6 dígitos (sin ceros para evitar confusión)
    codigo_otp = 6.times.map { rand(1..9) }.join
    
    # Guardar el código en la sesión con timestamp
    session[:otp_supervisor_gh] = {
      codigo: codigo_otp,
      interventoria_id: @interventoria.id,
      timestamp: Time.now.to_i
    }
    
    # Log para depuración
    logger.info("=== GENERANDO OTP ===")
    logger.info("Interventoria ID: #{@interventoria.id}")
    logger.info("Código OTP generado: #{codigo_otp}")
    logger.info("Sesión guardada: #{session[:otp_supervisor_gh].inspect}")
    
    # Enviar SMS (solo una vez)
    @sms_enviado = false
    @mensaje_sms = ""
    
    begin
      if user.celular.present?
        mensaje = "IMAH - Codigo de verificacion para aprobar informe: #{codigo_otp}. Valido por 5 minutos."
        WsController.smscolombiared(user.celular.to_s, mensaje)
        @mensaje_sms = "SMS enviado exitosamente al #{user.celular}"
        @sms_enviado = true
        logger.info("SMS OTP enviado a #{user.celular} - Código: #{codigo_otp}")
      else
        @mensaje_sms = "Error: El usuario no tiene número de celular registrado"
        @sms_enviado = false
        logger.error("Usuario #{user.id} no tiene celular registrado")
      end
    rescue StandardError => e
      logger.error("Error enviando SMS OTP: #{e.message}")
      @mensaje_sms = "Error al enviar SMS: #{e.message}"
      @sms_enviado = false
    end
    
    respond_to do |format|
      format.js
    end
  end

  # Verifica OTP y aprueba el informe (Supervisor de GH)
  def aprobar_supervisor_gh
    @interventoria = Interventoria.find(params[:id])
    otp_ingresado = (1..6).map { |i| params["nr#{i}"] }.join
    
    # Verificar OTP de la sesión
    otp_data = session[:otp_supervisor_gh]
    @validacion = false
    
    # Log para depuración
    logger.info("=== DEBUG OTP ===")
    logger.info("Interventoria ID: #{@interventoria.id}")
    logger.info("OTP ingresado: #{otp_ingresado}")
    logger.info("OTP data en sesión: #{otp_data.inspect}")
    
    if otp_data.nil?
      flash[:error] = "No se ha generado un código OTP. Por favor, solicite uno nuevo."
      logger.error("OTP data es nil")
    elsif (otp_data['interventoria_id'] || otp_data[:interventoria_id]).to_s != @interventoria.id.to_s
      flash[:error] = "El código OTP no corresponde a este informe."
      logger.error("Interventoria ID no coincide: esperado #{otp_data['interventoria_id'] || otp_data[:interventoria_id]}, recibido #{@interventoria.id}")
    elsif (Time.now.to_i - (otp_data['timestamp'] || otp_data[:timestamp]).to_i) > 300 # 5 minutos
      flash[:error] = "El código OTP ha expirado. Por favor, solicite uno nuevo."
      session.delete(:otp_supervisor_gh)
      logger.error("OTP expirado")
    elsif (otp_data['codigo'] || otp_data[:codigo]).to_s != otp_ingresado.to_s
      flash[:error] = "Código OTP inválido. Por favor, verifique e intente nuevamente."
      logger.error("Código OTP no coincide: esperado #{otp_data['codigo'] || otp_data[:codigo]}, recibido #{otp_ingresado}")
    else
      @validacion = true
      @interventoria.update!(
        estado: 'APROBADOGH',
        firma_digital_supervisor: SecureRandom.hex(14),
        fecha_firma_supervisor: Time.now
      )
      @interventoria.registrar_bitacora(is_admin, "INFORME APROBADO POR SUPERVISOR DE GESTION HUMANA")
      
      # Enviar correo al contratista
      enviar_correo_contratista('sendaprobacion')
      
      flash[:notice] = "El informe ha sido aprobado exitosamente"
      session.delete(:otp_supervisor_gh)
      logger.info("OTP validado correctamente")
    end
    
    respond_to do |format|
      format.js
    end
  end

  # ─── SUPERVISOR GH: RECHAZAR ─────────────────────────────────────────────
  # Modal para rechazar (Supervisor de Gestión Humana)
  def rechazar_supervisor_gh_modal
    @interventoria = Interventoria.find(params[:id])
  end

  # Rechaza el informe (Supervisor de GH)
  def rechazar_supervisor_gh
    @interventoria = Interventoria.find(params[:id])
    motivo = params[:observacion_rechazo].to_s.strip.presence || "Sin observaciones"
    
    @interventoria.update!(estado: 'RECHAZADOGH', fin_anno: nil)
    @interventoria.registrar_bitacora(is_admin, "INFORME RECHAZADO POR SUPERVISOR DE GESTION HUMANA - #{motivo}")
    
    # Enviar correo al contratista
    enviar_correo_contratista('sendrechazog')
    
    flash[:notice] = "El informe ha sido rechazado"
    redirect_to interventorias_path
  end

  # ─── CREAR/VALIDAR PERIODO ────────────────────────────────────────────────
  # Crea el informe del periodo si no existe, o redirige al existente
  def validar
    @interventoria = Interventoria.find_by(
      contrato_id:          params[:contrato_id],
      contratosperfecha_id: params[:contratosperfecha_id],
      anno:                 params[:ano],
      mes:                  params[:mes]
    )

    if @interventoria
      redirect_to edit_interventoria_path(@interventoria, etapa: '1')
    else
      crear_periodo_nuevo(params[:contrato_id], params[:ano], params[:mes])
    end
  end

  # Recalcula un periodo existente
  def validaresp
    recalcular_periodo(@interventoria)
    redirect_to edit_interventoria_path(@interventoria, etapa: '1')
  end

  # Elimina un periodo
  def borrar
    @interventoria = Interventoria.find_by(
      contrato_id:          params[:contrato_id],
      contratosperfecha_id: params[:contratosperfecha_id],
      anno:                 params[:ano],
      mes:                  params[:mes]
    )
    # fallback sin perfecha_id por compatibilidad con links viejos
    @interventoria ||= Interventoria.find_by(
      contrato_id: params[:contrato_id],
      anno:        params[:ano],
      mes:         params[:mes]
    )
    return redirect_to(interventorias_path, alert: "Informe no encontrado") unless @interventoria
    if @interventoria.bloqueado?
      flash[:alert] = "Informe bloqueado para eliminaciones"
    else
      @interventoria.registrar_bitacora(is_admin, "SE BORRA EL PROCESO")
      @interventoria.destroy
      flash[:notice] = "El informe ha sido eliminado con éxito."
    end
    redirect_to interventorias_path
  end

  # Recarga las actividades de un informe que quedó sin ellas
  def recargar_actividades
    @interventoria = Interventoria.find(params[:id])
    if @interventoria.bloqueado?
      flash[:alert] = "Informe bloqueado, no se pueden recargar actividades."
      return redirect_to edit_interventoria_path(@interventoria, etapa: '21')
    end
    perfecha = @interventoria.contratosperfecha
    cargo_id = perfecha&.contratoscargo_id
    if cargo_id.present?
      @interventoria.interactividades.destroy_all
      @interventoria.registrar_obligaciones(cargo_id)
      flash[:notice] = "Actividades recargadas con éxito (#{@interventoria.interactividades.count} obligaciones)."
    else
      flash[:alert] = "No se encontró el cargo asociado. Verifique la configuración del contrato."
    end
    redirect_to edit_interventoria_path(@interventoria, etapa: '21')
  end

  # ─── VISUALIZACION ───────────────────────────────────────────────────────
  def visualizar
    @interventoria = Interventoria.find_by(
      anno: params[:ano],
      mes: params[:mes],
      contrato_id: params[:contrato_id]
    )
  end

  def visualizarfinal
    @contrato = Contrato.find(params[:contrato_id])
    @interventoria = Interventoria.find_by(anno: params[:ano], mes: params[:mes], contrato_id: params[:contrato_id])
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "InformeFinal",
               template: "interventorias/visualizarfinal.html.erb",
               encoding: "UTF-8",
               page_size: 'Letter',
               margin: { top: 47, bottom: 35, left: 10, right: 10 },
               footer: { html: { template: 'menus/footer_informe_general.html.erb' } },
               header: { spacing: 10, html: { template: 'menus/header_informe_general.html.erb' } }
      end
    end
  end

  def visualizaracum
    @contrato = Contrato.find(params[:contrato_id])
    @interventoria = Interventoria.find_by(anno: params[:ano], mes: params[:mes], contrato_id: params[:contrato_id])
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "InformeAcum",
               template: "interventorias/visualizaracum.html.erb",
               encoding: "UTF-8",
               page_size: 'Letter',
               margin: { top: 47, bottom: 35, left: 10, right: 10 },
               footer: { html: { template: 'menus/footer_informe_general.html.erb' } },
               header: { spacing: 10, html: { template: 'menus/header_informe_general.html.erb' } }
      end
    end
  end

  # ─── CAMBIO DE ETAPA DEL USUARIO ─────────────────────────────────────────
  def etapar
    User.where(id: is_admin).update_all(etapa: params[:etapa], updated_at: Time.now) if params[:etapa].present?
    redirect_to interventorias_path
  end

  # ─── REPORTES ─────────────────────────────────────────────────────────────
  def informe_indicadores
    @tipo = params[:tipo]
    anno_actual = Date.today.year.to_s
    mes_actual = Date.today.month.to_s

    @nombre, @interventorias = case @tipo
                               when '1' then ["Pendientes de envío",
                                              Interventoria.where(estado: 'PENDIENTE', anno: anno_actual, mes: mes_actual)]
                               when '2' then ["En revisión por el supervisor",
                                              Interventoria.where(estado: 'REVISION', anno: anno_actual, mes: mes_actual)]
                               when '3' then ["Revisión Gestión Humana",
                                              Interventoria.where(estado: %w[APROBADO REVISIONFINALGH], anno: anno_actual, mes: mes_actual)]
                               when '4' then ["Pendientes de reenvío por rechazados",
                                              Interventoria.where(estado: 'RECHAZADO', anno: anno_actual, mes: mes_actual)]
                               else [nil, Interventoria.none]
                               end

    respond_to do |format|
      format.xlsx do
        response.headers['Content-Disposition'] =
          "attachment; filename=\"INDICADORES_#{Time.now.strftime('%Y%m%d_%H%M%S')}.xlsx\""
      end
    end
  end

  # ─── PRIVATE ──────────────────────────────────────────────────────────────

  private

  def set_interventoria
    @interventoria = Interventoria.find(params[:id])
  end

  def interventoria_params
    params.require(:interventoria).permit(
      :contrato_id, :contratosperfecha_id, :user_id, :user_actualiza,
      :anno, :mes, :valor_mes, :salud, :arl, :interes_credito,
      :salud_prepagada, :dependientes, :pension, :afc, :voluntarias,
      :renta, :base_uvt, :retefuente383, :retefuente384,
      :subtotal, :total, :base_retefuente, :observaciones,
      :consecutivo, :subtotalr, :subtotalt, :estado, :empleado_id,
      :dias, :bloqueado, :activo, :valor_incr, :total_rentas,
      :version, :etapa, :gestion_humana, :diassuspension,
      :fin_anno, :firma_digital_supervisor, :firma_digital_empleado,
      :fecha_firma_supervisor, :fecha_firma_empleado
    )
  end

  def determine_layout
    if %w[visualizar visualizarfinal visualizaracum verificacion].include?(action_name)
      "atencion"
    elsif %w[edit index].include?(action_name)
      "application_interventorias"
    elsif %w[informe_indicadores].include?(action_name)
      "excel"
    else
      "application"
    end
  end

  # Carga los datos del index según el rol/etapa del usuario
  def cargar_datos_por_etapa(user)
    anno_actual = Date.today.year.to_s
    mes_actual = Date.today.month.to_s

    case user.etapa.to_s
    when 'SUPERVISOR'
      supervisor_persona = @user.identificacion.present? ? Contratospersona.find_by(identificacion: @user.identificacion) : nil

      # IDs de contratistas asignados a este supervisor via contratosperusers
      contratistas_ids = Contratosperuser.where(user_id: @user.id, fecha_fin: nil).pluck(:contratospersona_id)
      perfechas_ids = Contratosperfecha.where(contratospersona_id: contratistas_ids).pluck(:id)

      if supervisor_persona.present?
        # Busca por interventorempleado_id O por contratosperfecha_id (cubre registros sin el campo)
        @interventorias = Interventoria.where(estado: %w[REVISION REVISIONFINALINT]).where("interventorempleado_id = ? OR (interventorempleado_id IS NULL AND contratosperfecha_id IN (?))", supervisor_persona.id, perfechas_ids.presence || [0]).order(updated_at: :asc)
        @interventorempleado_id = supervisor_persona.id
      else
        @interventorias = Interventoria
                            .where(estado: %w[REVISION REVISIONFINALINT],
                                   contratosperfecha_id: perfechas_ids)
                            .order(updated_at: :asc)
        @interventorempleado_id = nil
      end
      @message_interventor = 'SI'
    when 'TALENTO_HUMANO'
      if is_auth_c("interventoriagh")
        @interventoriasgh = Interventoria.where(estado: %w[APROBADO REVISIONFINALGH])
                                         .order(updated_at: :asc)
        @interventoriasok = Interventoria.where(anno: anno_actual, estado: %w[APROBADOGH TESORERIA])
                                         .order(updated_at: :asc)
      end

    when 'CONTABILIDAD'
      if is_auth_c("interventoriacont")
        anno_actual = Date.today.year.to_s
        mes_actual  = Date.today.month

        # Reemplaza fechascontables con Ruby puro
        @objetos = (1..mes_actual).to_a.reverse.map do |m|
          OpenStruct.new(
            ano:  anno_actual,
            mes:  m.to_s,
            mesc: m.to_s.rjust(2, '0')
          )
        end

        @interventoriaste   = Interventoria.where(anno: anno_actual, estado: %w[APROBADOGH TESORERIA]).order(updated_at: :asc)
        @interventoriasteok = Interventoria.where(estado: %w[APROBADOGH TESORERIA]).order(updated_at: :asc)
      end
    when 'TESORERIA'
      @interventoriaste = Interventoria.where(anno: Date.today.year.to_s, estado: %w[APROBADOCONT TESORERIA]).order(updated_at: :asc)
      @interventoriasteok = Interventoria.where(estado: %w[APROBADOCONT TESORERIA]).order(updated_at: :asc)

    when 'MI_CUENTA'
      # El contratista ve sus propios periodos
      if user.identificacion.present?
        @contratosperfechas = Contratosperfecha
                                .joins(:contratospersona)
                                .where("contratospersonas.identificacion = ? AND contratosperfechas.estado NOT IN (?)",
                                       user.identificacion, ['C'])
                                .includes(:contrato)
                                .order(created_at: :desc)
      else
        @message = "Atención: Su usuario (#{user.username}) no tiene número de identificación asociado. Contacte a Sistemas."
      end
    end
  end

  # Verifica OTP usando ROTP
  def verificar_otp
    otp_code = (1..6).map { |i| params["nr#{i}"] }.join
    totp = ROTP::TOTP.new(is_admin.otp_secret)
    @otp_valid = totp.verify(otp_code)
  end

  # Bloquea actividades de pago de seguridad social
  def bloquear_actividades_ss
    @interventoria.interactividades
                  .where("actividad LIKE ?", '%PAGO%DE%SEGURIDAD%SOCIAL%')
                  .update_all(bloqueado: 'SI')
  end

  # Obtiene valor de configuración fiscal desde Sifi
  def valor_config(tipo)
    ids = { base_uvt: 58, retefuente383: 60, retefuente384: 61 }
    Sifi.find_by(id: ids[tipo])&.valor.to_f rescue 0
  end

  def current_user_obj
    User.find(is_admin)
  end

  # Crea un nuevo periodo de interventoría
  def crear_periodo_nuevo(contrato_id, ano, mes)
    perfecha = if params[:contratosperfecha_id].present?
                 Contratosperfecha.find(params[:contratosperfecha_id])
               else
                 Contratosperfecha.find_by(contrato_id: contrato_id)
               end

    # Buscar el supervisor vigente del contratista via contratosperusers
    supervisor_persona_id = nil
    if perfecha&.contratospersona_id.present?
      supervisor_user_id = Contratosperuser
                             .where(contratospersona_id: perfecha.contratospersona_id, fecha_fin: nil)
                             .order(created_at: :desc)
                             .limit(1).pluck(:user_id).first
      if supervisor_user_id.present?
        supervisor_user = User.find_by(id: supervisor_user_id)
        if supervisor_user&.identificacion.present?
          supervisor_persona = Contratospersona.find_by(identificacion: supervisor_user.identificacion)
          supervisor_persona_id = supervisor_persona&.id
        end
      end
    end

    interventoria = Interventoria.create!(
      contrato_id:              contrato_id,
      contratosperfecha_id:     perfecha&.id,
      anno:                     ano,
      mes:                      mes,
      user_id:                  is_admin,
      estado:                   'PENDIENTE',
      etapa:                    '1',
      valor_mes:                perfecha&.salariofinal.to_i,
      interventorempleado_id:   supervisor_persona_id
    )

    # El cargo_id viene directo del contratosperfecha
    cargo_id = perfecha&.contratoscargo_id
    interventoria.registrar_obligaciones(cargo_id) if cargo_id.present?
    interventoria.registrar_bitacora(is_admin, "SE CREA EL PROCESO")

    redirect_to edit_interventoria_path(interventoria, etapa: '1')
  end

  def recalcular_periodo(interventoria)
    # Aquí iría la lógica de recálculo que antes era prc_interventoriarecalculo
    # Se implementa en Ruby en lugar de stored procedure Oracle
    resultado = Interventoria.calcular_retencion(
      valor_mes: interventoria.valor_mes.to_i,
      salud: interventoria.salud.to_i,
      arl: interventoria.arl.to_i,
      pension: interventoria.pension.to_i,
      interes_credito: interventoria.interes_credito.to_i,
      salud_prepagada: interventoria.salud_prepagada.to_i,
      dependientes: interventoria.dependientes.to_i,
      afc: interventoria.afc.to_i,
      voluntarias: interventoria.voluntarias.to_i,
      base_uvt_config: valor_config(:base_uvt),
      retefuente383_config: valor_config(:retefuente383),
      retefuente384_config: valor_config(:retefuente384)
    )
    interventoria.update!(resultado)
  end

  def enviar_correo_contratista(tipo)
    persona = @interventoria.persona
    return unless persona
    user = User.find_by(identificacion: persona.identificacion, activo: 'S')
    return unless user&.email.present?
    NotifierMailer.interventoria_message(user.email, @interventoria.id, tipo).deliver_later
  rescue StandardError => e
    logger.error("SIFI Correo NO enviado: #{e.message}")
  end

  def enviar_correo_contabilidad
    valor = Sifi.find_by(id: 87)&.valor.to_s
    nombre = @interventoria.nombre_contratista
    NotifierMailer.interventoriacontabilidad_message(valor, @interventoria.id, nombre).deliver_later
  rescue StandardError => e
    logger.error("SIFI Correo contabilidad NO enviado: #{e.message}")
  end
end
