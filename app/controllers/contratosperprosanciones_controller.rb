class ContratosperprosancionesController < ApplicationController
  before_action :set_contratosperprosancion, only: [:show, :destroy]

  def captura_otp
    nr1 = params[:nr1]
    nr2 = params[:nr2]
    nr3 = params[:nr3]
    nr4 = params[:nr4]
    nr5 = params[:nr5]
    nr6 = params[:nr6]
    @contratosperprosancion = Contratosperprosancion.find(params[:id])
    @contratosperproceso = @contratosperprosancion.contratosperproceso
    code = nr1 + nr2 + nr3 + nr4 + nr5 + nr6
    if code.to_i == @contratosperprosancion.codigo_env.to_i
      isadmin = is_admin
      codigoFirma = SecureRandom.hex
      Bitacoraproceso.create!(contratosperproceso_id: @contratosperproceso.id, codigo: @contratosperprosancion.codigo_env, user_id: isadmin, proceso: 'SANCIONES', codigo_recibido: code,
                              fecha_firma: Time.now, codigo_firma: codigoFirma, id_tabla: @contratosperprosancion.id, controlador_tabla: 'contratosperprosanciones')
      @contratosperprosancion.update(codigo_rec: code, codigo_fecha: Time.now, codigo_firma: codigoFirma, user_firma: isadmin)
      @valida = true
      flash[:notice] = "Firmado con exito!!"

      # 2024-04-04 FFA Implementado...
      Ejecucion.create(user_id: is_admin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO SMS',
                       controlador_metodo: "ContratosperprosancionesController.firmarsancion(#{@contratosperprosancion.id},#{isadmin})", created_at: Time.now)

      if @contratosperprosancion.desvinculacion.to_s == 'SI'
        mensaje = "ASEAR: Estimad@ #{@contratosperproceso.contratospersona.nombres rescue nil}, te notificamos que tu sancion es #{@contratosperprosancion.sancion.to_s} a partir del #{@contratosperprosancion.fecha_desvinculacion.strftime("%d-%m-%Y").to_s}".html_safe
      else
        mensaje = "ASEAR: Estimad@ #{@contratosperproceso.contratospersona.nombres rescue nil}, te notificamos que tu sancion es (#{@contratosperprosancion.sancion.to_s})".html_safe
      end
      Asearsms::SendsmsServices.new.send_sms_procesos(@contratosperproceso.contratospersona.movil, mensaje)
      Asearsms::SendsmsServices.new.send_sms_procesos(@contratosperprosancion.user.celular, mensaje)
      Asearsms::SendsmsServices.new.send_sms_procesos(@contratosperproceso.user.celular, mensaje)
      # Log de Mensajes
      Contratosperpronota.create(contratosperproceso_id: @contratosperproceso.id, contratospersona_id: @contratosperproceso.contratospersona_id,
                                 user_id: isadmin, nota: 'SANCION: Empleado: ' + @contratosperproceso.contratospersona.movil.to_s + ' - ' + mensaje)
      Contratosperpronota.create(contratosperproceso_id: @contratosperproceso.id, contratospersona_id: @contratosperproceso.contratospersona_id,
                                 user_id: isadmin, nota: 'SANCION: Creador del proceso: ' + @contratosperproceso.user.celular.to_s + ' - ' + mensaje)
      Contratosperpronota.create(contratosperproceso_id: @contratosperproceso.id, contratospersona_id: @contratosperproceso.contratospersona_id,
                                 user_id: isadmin, nota: 'SANCION: Abogado: ' + @contratosperprosancion.user.celular.to_s + ' - ' + mensaje)

      if @contratosperprosancion.desvinculacion.to_s == 'SI' # Tambien firmamos la Terminacion del Contrato
        # 2024-04-04 FFA Implementado...
        Ejecucion.create(user_id: is_admin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO SMS',
                         controlador_metodo: "ContratosperprosancionesController.firmarterminacion(#{@contratosperprosancion.id},#{isadmin})", created_at: Time.now)
        user = User.find(5385)
        mensaje = "ASEAR: Estimad@, notificamos desvinculacion del area juridica de #{@contratosperproceso.contratospersona.nombres rescue nil}".html_safe
        Asearsms::SendsmsServices.new.send_sms_procesos(user.celular, mensaje)
      end
    else
      @valida = false
    end
  end

  def self.firmarterminacion(idProceso,isadmin)
    @contratosperprosancion = Contratosperprosancion.find(idProceso)
    @contratosperproceso = Contratosperproceso.find(@contratosperprosancion.contratosperproceso_id)
    fname = "Terminacion_#{@contratosperprosancion.id}_#{Time.now.strftime("%d%m%Y_%X")}"
    rutafact = "#{::Rails.root}/public/archivos/pdf/"
    rutanamefile = "#{::Rails.root}/public/archivos/pdf/#{fname}.pdf"
    system("rm -r #{rutanamefile}") rescue nil

    pdf = ApplicationController.render pdf: "#{fname}", template: "contratosperprocesos/procesos_pdf", :save_to_file => rutanamefile, :save_only => true,
                                       encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 },
                                       locals: { object: 'TERMINACION' , object1: @contratosperprosancion.id },
                                       :footer => { :html => { :template => 'layouts/encabezados/pdffooterdescargos.html.erb' } }

    save_path = Rails.root.join(rutafact, "#{fname}.pdf")
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
    file = File.open("#{::Rails.root}/public/archivos/pdf/#{fname}.pdf", 'rb')
    @contratosperprodoc = Contratosperprodoc.new
    @contratosperprodoc.contratosperproceso_id = @contratosperproceso.id
    @contratosperprodoc.contratospersona_id = @contratosperproceso.contratospersona_id
    @contratosperprodoc.docproceso = file
    @contratosperprodoc.tipo = "DOCUMENTO TERMINACION"
    @contratosperprodoc.user_id = isadmin
    @contratosperprodoc.proceso = 'TERMINACION'
    @contratosperprodoc.id_proceso = @contratosperprosancion.id
    @contratosperprodoc.save(validate: false)

    #Creamos el Retiro
    @solicitudesretiro = Solicitudesretiro.new
    @solicitudesretiro.contrato_id = @contratosperproceso.contratosperfecha.contrato_id
    @solicitudesretiro.contratosgrupo_id = @contratosperproceso.contratosperfecha.contratosgrupo_id
    @solicitudesretiro.contratospersona_id = @contratosperproceso.contratosperfecha.contratospersona_id
    @solicitudesretiro.contratosperfecha_id = @contratosperproceso.contratosperfecha_id
    @solicitudesretiro.fecha = @contratosperprosancion.fecha_desvinculacion
    @solicitudesretiro.justificacion = 'TERMINACION DE CONTRATO CON JUSTA CAUSA - PROCESO JURIDICO'
    @solicitudesretiro.user_id = isadmin
    @solicitudesretiro.documento_retiro = file
    @solicitudesretiro.save(validate: false)
    system("rm -r #{rutanamefile}") rescue nil
    file.close
    # Para notificar al Abogado
    user = User.find(isadmin)
    mensaje = "ASEAR: Estimad@ Abogado(a).. #{user.nombre rescue nil}, ya se proceso la terminacion que acabas de hacer.... ".html_safe
    Asearsms::SendsmsServices.new.send_sms_procesos(user.celular, mensaje)
  end

  def self.refirmarterminacion(idProceso,namefile)
    # ContratosperprosancionesController.refirmarterminacion(607,'Terminacion_607_14022025_16_58_11')
    @contratosperprosancion = Contratosperprosancion.find(idProceso)
    @contratosperproceso = Contratosperproceso.find(@contratosperprosancion.contratosperproceso_id)
    fname = namefile
    rutafact = "#{::Rails.root}/public/archivos/pdf/"
    rutanamefile = "#{::Rails.root}/public/archivos/pdf/#{fname}.pdf"
    system("rm -r #{rutanamefile}") rescue nil

    pdf = ApplicationController.render pdf: "#{fname}", template: "contratosperprocesos/procesos_pdf", :save_to_file => rutanamefile, :save_only => true,
                                       encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 },
                                       locals: { object: 'TERMINACION' , object1: @contratosperprosancion.id },
                                       :footer => { :html => { :template => 'layouts/encabezados/pdffooterdescargos.html.erb' } }

    save_path = Rails.root.join(rutafact, "#{fname}.pdf")
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
  end

  def self.firmarsancion(idProceso,isadmin)
    @contratosperprosancion = Contratosperprosancion.find(idProceso)
    @contratosperproceso = Contratosperproceso.find(@contratosperprosancion.contratosperproceso_id)
    fname = "Sancion_#{@contratosperprosancion.id}_#{Time.now.strftime("%d%m%Y_%X")}"
    rutafact = "#{::Rails.root}/public/archivos/pdf/"
    rutanamefile = "#{::Rails.root}/public/archivos/pdf/#{fname}.pdf"
    system("rm -r #{rutanamefile}") rescue nil

    pdf = ApplicationController.render pdf: "#{fname}", template: "contratosperprocesos/procesos_pdf", :save_to_file => rutanamefile, :save_only => true,
                                       encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 },
                                       locals: { object: 'SANCION' , object1: @contratosperprosancion.id },
                                       :footer => { :html => { :template => 'layouts/encabezados/pdffooterdescargos.html.erb' } }

    save_path = Rails.root.join(rutafact, "#{fname}.pdf")
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
    file = File.open("#{::Rails.root}/public/archivos/pdf/#{fname}.pdf", 'rb')
    @contratosperprodoc = Contratosperprodoc.new
    @contratosperprodoc.contratosperproceso_id = @contratosperproceso.id
    @contratosperprodoc.contratospersona_id = @contratosperproceso.contratospersona_id
    @contratosperprodoc.docproceso = file
    @contratosperprodoc.tipo = "PROCESO SANCION FIRMADO"
    @contratosperprodoc.user_id = isadmin
    @contratosperprodoc.proceso = 'SANCIONES'
    @contratosperprodoc.id_proceso = @contratosperprosancion.id
    @contratosperprodoc.save(validate: false)
    system("rm -r #{rutanamefile}") rescue nil
    file.close

    # Para notificar al Abogado
    user = User.find(isadmin)
    mensaje = "ASEAR: Estimad@ Abogado(a).. #{user.nombre rescue nil}, ya se proceso la Sancion que acabas de hacer.... ".html_safe
    Asearsms::SendsmsServices.new.send_sms_procesos(user.celular, mensaje)
  end

  def otp
    @contratosperprosancion = Contratosperprosancion.find(params[:id])
    codigo = rand(100000..999999).to_s.gsub("0", "#{rand(1..9)}")
    @contratosperprosancion.update(codigo_env: codigo)
    mensaje = "ASEAR: Estimad@ #{@contratosperprosancion.user.nombre}, se ha generado tu codigo para la firma de la Sancion - #{codigo}".html_safe
    Asearsms::SendsmsServices.new.send_sms_procesos(@contratosperprosancion.user.celular, mensaje)
    Asearmail::SendmailServices.new.sendEmailCodigo(@contratosperprosancion.user.email,
                                                    "Codigo para la firma de la sancion",
                                                    "asear_mailer/envio_codigo.html.erb", nil, nil,
                                                    @contratosperprosancion.user_id,codigo)
  end

  def otp2
    @contratosperprosancion = Contratosperprosancion.find(params[:id])
    codigo = rand(100000..999999).to_s.gsub("0", "#{rand(1..9)}")
    @contratosperprosancion.update(codigo_env_empleado: codigo)
    mensaje = "ASEAR: Estimad@ #{@contratosperprosancion.contratosperproceso.contratospersona.nombres}, se ha generado tu codigo para la firma de la Sancion - #{codigo}".html_safe
    Asearsms::SendsmsServices.new.send_sms_procesos(@contratosperprosancion.contratosperproceso.contratospersona.movil, mensaje)
    Asearmail::SendmailServices.new.sendEmailCodigo(@contratosperprosancion.contratosperproceso.contratospersona.correo, "Codigo para la firma de la Sancion", "asear_mailer/envio_codigo.html.erb", nil, nil, -1,codigo)
  end

  def captura_otp2
    nr1 = params[:nr1]
    nr2 = params[:nr2]
    nr3 = params[:nr3]
    nr4 = params[:nr4]
    nr5 = params[:nr5]
    nr6 = params[:nr6]
    @contratosperprosancion = Contratosperprosancion.find(params[:id])
    @contratosperproceso = @contratosperprosancion.contratosperproceso
    code = nr1 + nr2 + nr3 + nr4 + nr5 + nr6
    if code.to_i == @contratosperprosancion.codigo_env_empleado.to_i
      codigoFirma = SecureRandom.hex
      Bitacoraproceso.create!(contratosperproceso_id: @contratosperproceso.id, codigo: @contratosperprosancion.codigo_env_empleado, user_id: is_admin, proceso: 'SANCIONES EMPLEADO', codigo_recibido: code,
                              fecha_firma: Time.now, codigo_firma: codigoFirma, id_tabla: @contratosperprosancion.id, controlador_tabla: 'contratosperprosanciones')
      @contratosperprosancion.update(codigo_rec_empleado: code, codigo_fecha_empleado: Time.now, codigo_firma_empleado: codigoFirma)
      @valida = true
      flash[:notice] = "Firmado con exito!!"
    else
      @valida = false
    end
  end

  def index
    @contratosperprosanciones = Contratosperprosancion.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosperprosancion.find(params[:active_id]) if params[:active_id].present?
    @contratosperproceso = Contratosperproceso.find(params[:contratosperproceso_id])
    @contratosperprosancion = Contratosperprosancion.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosperprosancion.find(params[:active_id]) if params[:active_id].present?
    @contratosperprosancion = Contratosperprosancion.find(params[:id])
    @contratosperproceso = @contratosperprosancion.contratosperproceso
    respond_to { |format| format.js }
  end

  def create
    @contratosperproceso  = Contratosperproceso.find(params[:contratosperproceso_id])
    @contratosperprosancion = Contratosperprosancion.new(contratosperprosancion_params)
    @contratosperprosancion.contratosperproceso_id = @contratosperproceso.id
    @contratosperprosancion.contratospersona_id = @contratosperproceso.contratospersona_id
    @contratosperprosancion.user_id = is_admin
    respond_to do |format|
      if @contratosperprosancion.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperprosancion } }
      end
    end
  end

  def update
    @contratosperprosancion = Contratosperprosancion.find(params[:id])
    @contratosperproceso = @contratosperprosancion.contratosperproceso
    respond_to do |format|
      if @contratosperprosancion.update(contratosperprosancion_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperprosancion } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosperprosancion.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosperprosancion
    @contratosperproceso = Contratosperproceso.find(params[:contratosperproceso_id])
    @contratosperprosancion = Contratosperprosancion.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosperprosancion_params
    params.require(:contratosperprosancion).permit!
  end
end
