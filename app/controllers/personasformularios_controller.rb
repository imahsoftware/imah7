class PersonasformulariosController < ApplicationController
  before_action :set_personasformulario, only: [:show, :edit, :update, :destroy]

  require 'net/http'
  require 'open-uri'
  layout :set_layout

  def index
  end

  def abrir_compromiso
    @personasformulario = Personasformulario.find(params[:personasformulario_id])
    @parcargosdoc = Parcargosdoc.find(params[:parcargosdoc_id])
    compromiso = Compromiso.where("parcargosdoc_id = #{@parcargosdoc.id} and personasformulario_id = #{@personasformulario.id}").first rescue nil
    if compromiso.present?
      @compromiso = Compromiso.find(compromiso.id)
    else
      @compromiso = Compromiso.new
    end
  end

  def abrir_registros
    @archivo = params[:archivo_id]
    @personasformularios = Personasformulario.where(archivo_id: @archivo).paginate(:page => params[:page], :per_page => 15)
  end

  def examenes_registros
    @mensaje = ""
    @tipo = params[:tipo]
    @archivo = params[:archivo_id]
    if @tipo == 'PROGRAMACION'
      @mensaje = "Registros Cargados"
    else
      @mensaje = "Registros Actualizados"
    end
    @migracionesexamenes = Migracionesexamen.where(archivo_id: @archivo, tipo: @tipo).paginate(:page => params[:page], :per_page => 15)
  end

  def registro
    @etapa = params[:etapa].present? ? params[:etapa] : '1'
    @personasformulario = Personasformulario.find(params[:personasformulario_id])
  end

  def self.notificacion_correo(archivoId)
    Personasformulario.where("archivo_id = #{archivoId}").each do |personasformulario|
      Asearmail::SendmailServices.new.sendEmailFormulario(personasformulario.correo.to_s,
                                                          "Notificacion de Ingreso al Sistema - Asear S.A.S. E.S.P",
                                                          "asear_mailer/envio_datos_acceso.html.erb", nil, nil,
                                                          personasformulario.id)

    end
  end
  # get documenta
  def self.notificacion_sms(archivoId, clase)
    if clase == 'PROGRAMACION'
      examenes = Personasformulariosexamen.where("archivo_id = #{archivoId}")
    elsif ['ACTUALIZACION', 'ESTADO'].include?(clase)
      examenes = Personasformulariosexamen.where("archivo_actualiza = #{archivoId}")
    end
    examenes.each do |personasformulariosexamen|
      if clase == 'PROGRAMACION'
        mensaje = "ASEAR: Estimad@ #{personasformulariosexamen.personasformulario.nombre.to_s rescue nil}. Tu examen medico ha sido asignado, consulta aqui mas informacion. - Url: https://appasearesp.com".html_safe
        Asearsms::SendsmsServices.new.send_sms_formulario(personasformulariosexamen.personasformulario_id, mensaje)
      elsif clase == 'ACTUALIZACION'
        mensaje = "ASEAR: Estimad@ #{personasformulariosexamen.personasformulario.nombre.to_s rescue nil}. Tu examen medico ha sido re-agendado, consulta aqui mas informacion. - Url: https://appasearesp.com".html_safe
        Asearsms::SendsmsServices.new.send_sms_formulario(personasformulariosexamen.personasformulario_id, mensaje)
      #elsif clase == 'ESTADO'
      #mensaje = "Asear S.A.S. E.S.P : Notificacion: Se ha actualziado el estado del examen (#{personasformulariosexamen.estado})".html_safe
      end
    end
  end

  def reenviar_correo
    @personasformulario = Personasformulario.find(params[:id])
    Asearmail::SendmailServices.new.sendEmailFormulario(@personasformulario.correo.to_s,
                                                        "Notificacion de Ingreso al Sistema - Asear S.A.S. E.S.P",
                                                        "asear_mailer/envio_datos_acceso.html.erb", nil, nil,
                                                        @personasformulario.id)
    respond_to do |format|
      flash[:notice] = "Correo Electronico Enviado con exito!!!!"
      format.js { render inline: "location.reload();" }
    end
  end

  def self.envio(archivoId)
    mensaje = ""
    Personasformulario.where(archivo_id: archivoId).each do |p|
      mensaje = "ASEAR: #{p.nombre.to_s}, Lo invitamos a iniciar proceso de seleccion para ocupar vacante. Nunca olvides tu Usuario: #{p.identificacion} -Clave: #{p.identificacion} - Url: https://appasearesp.com".html_safe
      Asearsms::SendsmsServices.new.send_sms_formulario(p.id, mensaje)
    end
  end

  def self.envio_retardado(personasformularioId)
    mensaje = ""
    Personasformulario.where(id: personasformularioId).each do |p|
      mensaje = "ASEAR: Estimad@ #{p.nombre.to_s}: Lamentamos informar que NO fuiste seleccionado para la vacante.. Tu proceso termina aca y agradecemos tu tiempo."
      Asearsms::SendsmsServices.new.send_sms_formulario(p.id, mensaje)
    end
  end

  def reenviar_sms
    @personasformulario = Personasformulario.find(params[:id])
    mensaje = "ASEAR: #{@personasformulario.nombre.to_s}, Lo invitamos a iniciar proceso de seleccion para ocupar vacante. Nunca olvides tu Usuario: #{@personasformulario.identificacion} -Clave: #{@personasformulario.identificacion} - Url: https://appasearesp.com".html_safe
    Asearsms::SendsmsServices.new.send_sms_formulario(@personasformulario.id, mensaje)
    respond_to do |format|
      format.js { render inline: "location.reload();" }
    end
  end

  def reenviar_sms2
    @personasformulario = Personasformulario.find(params[:id])
    mensaje = "ASEAR: #{@personasformulario.nombre.to_s}, Lo invitamos a iniciar proceso de seleccion para ocupar vacante. Nunca olvides tu Usuario: #{@personasformulario.identificacion} -Clave: #{@personasformulario.identificacion} - Url: https://appasearesp.com".html_safe
    Asearsms::SendsmsServices.new.send_sms_formulario2(@personasformulario.id, mensaje)
    respond_to do |format|
      format.js { render inline: "location.reload();" }
    end
  end

  def notificacion_correo
    @personasformulario = Personasformulario.find(params[:id])
    if ['DEVUELTO','RECHAZADO','APROBADO'].include?(@personasformulario.estado)
      Asearmail::SendmailServices.new.sendEmailFormulario(@personasformulario.correo.to_s,
                                                          "Notificacion de Estado - Asear S.A.S. E.S.P",
                                                          "asear_mailer/envio_datos_notificacion.html.erb", nil, nil,
                                                          @personasformulario.id)
    end
    respond_to do |format|
      flash[:notice] = "Correo Electronico Enviado con exito!!!!"
      format.js { render inline: "location.reload();" }
    end
  end

=begin
  def notificacion_sms
    @personasformulario = Personasformulario.find(params[:id])
    mensaje = "Asear S.A.S. E.S.P : Notificacion: El estado de tu inscripcion es #{@personasformulario.estado.to_s}".html_safe
    Asearsms::SendsmsServices.new.send_sms_formulario(@personasformulario.id, mensaje)
    respond_to do |format|
      flash[:notice] = "SMS Enviado con exito!!!!"
      format.js { render inline: "location.reload();" }
    end
  end
=end

  def edit
    if is_auth_c("contratacionaprobar") or is_auth_c("contratacionconv")
      @etapa = params[:etapa].present? ? params[:etapa] : '1'
      respond_to do |format|
        format.html { render :action => "personasformulario_form" }
      end
    else
      flash[:notice] = "Que estas haciendo en este link?"
      redirect_to root_path
    end
  end

  def create
    @personasformulario = Personasformulario.new(personasformulario_params)
    @personasformulario.user_id = is_admin
    @personasformulario.portafolio_id = is_portafolio
    respond_to do |format|
      if @personasformulario.save
        format.html { redirect_to edit_personasformulario_path(id: @personasformulario.id), notice: "El registro ha sido registrado con Exito." }
        format.json { render :show, status: :created, location: @personasformulario }
      else
        format.html { render :action => "personasformulario_form" }
        format.json { render json: @personasformulario.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @etapa = params[:etapa].present? ? params[:etapa] : '1'
    @personasformulario.validateTipo(is_tipoconsulta)
    if @personasformulario.update(personasformulario_params)
      if User.where("personasformulario_id = #{@personasformulario.id}").present?
        user = User.where("personasformulario_id = #{@personasformulario.id}").first
        if user.identificacion != @personasformulario.identificacion
          user.identificacion = @personasformulario.identificacion
          user.username = @personasformulario.identificacion
          user.password = @personasformulario.identificacion
          user.save(vaidate: false)
          Asearmail::SendmailServices.new.sendEmailFormulario(@personasformulario.correo.to_s,
                                                              "Notificacion de Cambio de dato de Acceso - Asear S.A.S. E.S.P",
                                                              "asear_mailer/envio_datos_acceso.html.erb", nil, nil,
                                                              @personasformulario.id)
          mensaje = "ASEAR: Estimad@ #{@personasformulario.nombre}, tus nuevos datos de acceso son - Usuario: #{@personasformulario.identificacion} - Clave: #{@personasformulario.identificacion} - Url: https://appasearesp.com".html_safe
          Asearsms::SendsmsServices.new.send_sms_formulario(@personasformulario.id, mensaje)
        end
      end
      flash['success'] = "Información Actualizada, recuerda continuar con los documentos digitales"
      redirect_to edit_personasformulario_path(id: @personasformulario.id)
    else
      render "personasformulario_form"
    end
  end

  def self.notificacion_user(idr)
    User.where("tipoconsulta = 'RECTOR' and (observaciones is null or observaciones like '%ERROR-SMS%')").each do |d|
      mensaje = "ASEAR: Estimad@ #{d.nombres}, nos permitimos enviar su usuario #{d.identificacion} y contrasena #{d.identificacion} para el ingreso a la plataforma de ASEAR, la cual sera una herramienta clave para el seguimiento y control de los colaboradores. - Url: https://appasearesp.com".html_safe
      Asearsms::SendsmsServices.new.send_sms_users(d.id, mensaje)
    end
  end

  def desbloqueo
    @personasformulario = Personasformulario.find(params[:id])
    User.where("personasformulario_id = #{@personasformulario.id}").each do |p|
      p.activo = 'S'
      p.password = p.identificacion
      p.etapa = 'A'
      p.failed_attempts = 0
      p.unlock_token =  nil
      p.locked_at =  nil
      p.tipoconsulta = 'CANDIDATO'
      p.save(validate: false)
    end
    flash['success'] = 'Usuario desbloqueado y restablecida la clave de acceso'
    redirect_to edit_personasformulario_path(id: @personasformulario.id)
  end

  def envio_formulario
    @personasformulario = Personasformulario.find(params[:id])
    permiteProceso = "SI"
    msgNotice = ""
    if ['RECHAZADO','DESISTE','SINCONTACTO'].include?(params[:estado].to_s)
      if @personasformulario.observacion_interna.to_s == ""
        permiteProceso = 'NO'
      end
    end
    if permiteProceso == 'SI'
      @personasformulario.estado = params[:estado]
      @personasformulario.user_estado = is_admin
      @personasformulario.fecha_estado = Time.now
      @personasformulario.save(validate: false)
      mensaje = ""
      if @personasformulario.estado == 'DEVUELTO'
        mensaje = "ASEAR: Estimad@ #{@personasformulario.nombre.to_s}: Su proceso de contratacion se encuentra detenido, favor ingresa aqui para corregir y continuar. - Url: https://appasearesp.com".html_safe
      elsif @personasformulario.estado == 'RECHAZADO'
        mensaje = "ASEAR: Estimad@ #{@personasformulario.nombre.to_s}: Lamentamos informar que NO fuiste seleccionado para la vacante. Tu proceso termina aca y agradecemos tu tiempo."
        User.where(personasformulario_id: @personasformulario.id).update_all(activo: 'N')
      elsif @personasformulario.estado == 'APROBADO'
        mensaje = "ASEAR: Estimad@ #{@personasformulario.nombre.to_s}: La informacion registrada se encuentra en estudio. Debe estar pendiente de proximas indicaciones"
        User.where(personasformulario_id: @personasformulario.id).update_all(activo: 'S',failed_attempts:0, unlock_token: nil, locked_at: nil)
      elsif @personasformulario.estado == 'CONTRATACION'
        begin
          ActiveRecord::Base.connection.execute("CALL prc_personasformularios(#{@personasformulario.id})")
        rescue Exception => ex
          Ejecucion.create(user_id: is_admin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO SMS',
                           controlador_metodo: "DatasController.prcpersonasformularios(#{@personasformulario.id})", created_at: Time.now)
        end
        idContratosPersona = Contratospersona.where("identificacion = '#{@personasformulario.identificacion}'").first.id rescue nil
      elsif @personasformulario.estado == 'PENDIENTE'
        User.where(personasformulario_id: @personasformulario.id).update_all(activo: 'S',failed_attempts:0, unlock_token: nil, locked_at: nil)
      end
      if mensaje.to_s != ""
        Ejecucion.create(user_id: is_admin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO SMS',
                         controlador_metodo: "DatasController.enviosms(#{@personasformulario.id},'#{mensaje}')", created_at: Time.now)
        #Asearsms::SendsmsServices.new.send_sms_formulario(@personasformulario.id, mensaje)
      end
      msgNotice = "Formulario #{params[:estado]}"
    else
      msgNotice = "Debe indicar la observacion interna, de lo contrario no se puede procesar.."
    end
    respond_to do |format|
      flash[:notice] = msgNotice
      if @personasformulario.estado.to_s == 'CONTRATACION'
        format.html { redirect_to edit_contratospersona_path(id: idContratosPersona, etapa: 'A'), notice: "El proceso ha sido registrado con Exito." }
      else
        format.js { render inline: "location.reload();" }
      end
    end
  end

  def get_personasformulario_genero
    @tipo = params[:personasformulario_genero]
    respond_to { |format| format.js }
  end

  def update2
    @etapa = params[:etapa].present? ? params[:etapa] : '1'
    @personasformulario = Personasformulario.find(params[:id])
    @personasformulario.validateTipo(is_tipoconsulta)
    if @personasformulario.update(personasformulario_params)
      flash['success'] = "Información Actualizada, recuerda continuar con los documentos digitales"
      redirect_to root_path
    else
      flash['danger'] = "La información no ha sido diligenciada completamente, por favor verifica"
      render "personasformulario_form2"
    end
  end

  private

  def set_layout
    if ['index', 'new'].include?(action_name)
      'application_admin'
    elsif ['edit'].include?(action_name)
      'application_admin'
    elsif ['registro', 'update2'].include?(action_name)
      'inscripcion_layoutmetro'
    else
      "application_admin"
    end
  end

  def set_personasformulario
    @personasformulario = Personasformulario.find(params[:id])
  end

  def personasformulario_params
    params.require(:personasformulario).permit!
  end
end