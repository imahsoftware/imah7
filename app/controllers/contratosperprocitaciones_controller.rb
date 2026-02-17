class ContratosperprocitacionesController < ApplicationController
  before_action :set_contratosperprocitacion, only: [:show, :destroy]


  def index
    @contratosperprocitaciones = Contratosperprocitacion.all
  end

  def show
    respond_to { |format| format.js }
  end

  def notificarcitacion
    @contratosperprocitacion = Contratosperprocitacion.find(params[:id])
    contratospersona = @contratosperprocitacion.contratosperproceso.contratospersona
    nombre = contratospersona.nombres rescue nil
    movil = contratospersona.movil rescue nil
    mensaje = "ASEAR: Estimad@ #{nombre.capitalize rescue nil}, se te informa que has sido citad@ en el Lugar: #{@contratosperprocitacion.lugar} - Fecha: #{@contratosperprocitacion.fecha.strftime("%d-%m-%Y %X")}".html_safe
    Asearsms::SendsmsServices.new.send_sms_procesos(movil, mensaje)
    respond_to do |format|
      flash[:notice] = "Se ha notificado con exito!!"
      format.js { render inline: "location.reload();" }
    end
  end

  def captura_otp
    nr1 = params[:nr1]
    nr2 = params[:nr2]
    nr3 = params[:nr3]
    nr4 = params[:nr4]
    nr5 = params[:nr5]
    nr6 = params[:nr6]
    @contratosperprocitacion = Contratosperprocitacion.find(params[:id])
    @contratosperproceso = @contratosperprocitacion.contratosperproceso
    code = nr1 + nr2 + nr3 + nr4 + nr5 + nr6
    if code.to_i == @contratosperprocitacion.codigo_env.to_i
      isadmin = is_admin
      codigoFirma = SecureRandom.hex
      Bitacoraproceso.create!(contratosperproceso_id: @contratosperproceso.id, codigo: @contratosperprocitacion.codigo_env, user_id: isadmin, proceso: 'CITACIONES', codigo_recibido: code,
                              fecha_firma: Time.now, codigo_firma: codigoFirma, id_tabla: @contratosperprocitacion.id, controlador_tabla: 'contratosperprocitaciones')
      @contratosperprocitacion.update(codigo_rec: code, codigo_fecha: Time.now, codigo_firma: codigoFirma, user_firma: isadmin)
      @valida = true
      flash[:notice] = "Firmado con exito!!"
      fname = "Citacion_#{@contratosperprocitacion.id}_#{Time.now.strftime("%d%m%Y_%X")}"
      rutafact = "#{::Rails.root}/public/archivos/pdf/"
      rutanamefile = "#{::Rails.root}/public/archivos/pdf/#{fname}.pdf"
      system("rm -r #{rutanamefile}") rescue nil

      pdf = ApplicationController.render pdf: "#{fname}", template: "contratosperprocesos/procesos_pdf", :save_to_file => rutanamefile, :save_only => true,
                                         encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 },
                                         locals: { object: 'CITACION' , object1: @contratosperprocitacion.id },
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
      @contratosperprodoc.tipo = 'PROCESO CITACIONES FIRMADO'
      @contratosperprodoc.user_id = isadmin
      @contratosperprodoc.proceso = 'CITACIONES'
      @contratosperprodoc.id_proceso = @contratosperprocitacion.id
      @contratosperprodoc.save(validate: false)
      system("rm -r #{rutanamefile}") rescue nil
      mensaje = "ASEAR: Estimad@ #{@contratosperproceso.contratospersona.nombres rescue nil}, te notificamos que has sido citado a descargos, lugar: #{@contratosperprocitacion.lugar.to_s}, fecha: #{@contratosperprocitacion.fecha.strftime("%d-%m-%Y %X").to_s}".html_safe
      Asearsms::SendsmsServices.new.send_sms_procesos(@contratosperproceso.contratospersona.movil, mensaje)
      Asearsms::SendsmsServices.new.send_sms_procesos(@contratosperprocitacion.user.celular, mensaje)
      Asearsms::SendsmsServices.new.send_sms_procesos(@contratosperproceso.user.celular, mensaje)

      # Log de Mensajes
      Contratosperpronota.create(contratosperproceso_id: @contratosperproceso.id, contratospersona_id: @contratosperproceso.contratospersona_id,
                                 user_id: isadmin, nota: 'CITACION: Empleado: ' + @contratosperproceso.contratospersona.movil.to_s + ' - ' + mensaje)
      Contratosperpronota.create(contratosperproceso_id: @contratosperproceso.id, contratospersona_id: @contratosperproceso.contratospersona_id,
                                 user_id: isadmin, nota: 'CITACION: Creador del proceso: ' + @contratosperproceso.user.celular.to_s + ' - ' + mensaje)
      Contratosperpronota.create(contratosperproceso_id: @contratosperproceso.id, contratospersona_id: @contratosperproceso.contratospersona_id,
                                 user_id: isadmin, nota: 'CITACION: Abogado: ' + @contratosperprocitacion.user.celular.to_s + ' - ' + mensaje)
      respond_to do |format|
          flash[:notice] = "Se firmo con exito!!"
          format.js { render inline: "location.reload();" }
      end
    else
      @valida = false
    end
  end

  def captura_otp2
    nr1 = params[:nr1]
    nr2 = params[:nr2]
    nr3 = params[:nr3]
    nr4 = params[:nr4]
    nr5 = params[:nr5]
    nr6 = params[:nr6]
    @contratosperprocitacion = Contratosperprocitacion.find(params[:id])
    @contratosperproceso = @contratosperprocitacion.contratosperproceso
    code = nr1 + nr2 + nr3 + nr4 + nr5 + nr6
    if code.to_i == @contratosperprocitacion.codigo_env_noatendida.to_i
      isadmin = is_admin
      codigoFirma = SecureRandom.hex
      Bitacoraproceso.create!(contratosperproceso_id: @contratosperproceso.id, codigo: @contratosperprocitacion.codigo_env, user_id: isadmin, proceso: 'CITACIONES NO ATENDIDA', codigo_recibido: code,
                              fecha_firma: Time.now, codigo_firma: codigoFirma, id_tabla: @contratosperprocitacion.id, controlador_tabla: 'contratosperprocitaciones')
      @contratosperprocitacion.update(codigo_rec_noatendida: code, codigo_fecha_noatendida: Time.now, codigo_firma_noatendida: codigoFirma, user_firma_noatendida: isadmin)
      @valida = true
      flash[:notice] = "Firmado con exito!!"
      fname = "Citacion_No_Atendida_#{@contratosperprocitacion.id}_#{Time.now.strftime("%d%m%Y_%X")}"
      rutafact = "#{::Rails.root}/public/archivos/pdf/"
      rutanamefile = "#{::Rails.root}/public/archivos/pdf/#{fname}.pdf"
      system("rm -r #{rutanamefile}") rescue nil

      pdf = ApplicationController.render pdf: "#{fname}", template: "contratosperprocesos/procesos_pdf", :save_to_file => rutanamefile, :save_only => true,
                                         encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 },
                                         locals: { object: 'CITACION_NO_ATENDIDA' , object1: @contratosperprocitacion.id },
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
      @contratosperprodoc.tipo = 'PROCESO CITACIONES NO ATENDIDO FIRMADO'
      @contratosperprodoc.user_id = isadmin
      @contratosperprodoc.proceso = 'CITACIONES NO ATENDIDA'
      @contratosperprodoc.id_proceso = @contratosperprocitacion.id
      @contratosperprodoc.save(validate: false)
      system("rm -r #{rutanamefile}") rescue nil

      mensaje = "ASEAR: Estimad@ #{@contratosperproceso.contratospersona.nombres rescue nil}, te notificamos que has sido citado a descargos, lugar: #{@contratosperprocitacion.lugar.to_s}, fecha: #{@contratosperprocitacion.fecha.strftime("%d-%m-%Y %X").to_s}".html_safe
      Asearsms::SendsmsServices.new.send_sms_procesos(@contratosperproceso.contratospersona.movil, mensaje)
      Asearsms::SendsmsServices.new.send_sms_procesos(@contratosperprocitacion.user.celular, mensaje)
      Asearsms::SendsmsServices.new.send_sms_procesos(@contratosperproceso.user.celular, mensaje)

      # Log de Mensajes
      Contratosperpronota.create(contratosperproceso_id: @contratosperproceso.id, contratospersona_id: @contratosperproceso.contratospersona_id,
                                 user_id: isadmin, nota: 'NO COMPARECENCIA: Empleado: ' + @contratosperproceso.contratospersona.movil.to_s + ' - ' + mensaje)
      Contratosperpronota.create(contratosperproceso_id: @contratosperproceso.id, contratospersona_id: @contratosperproceso.contratospersona_id,
                                 user_id: isadmin, nota: 'NO COMPARECENCIA: Creador del proceso: ' + @contratosperproceso.user.celular.to_s + ' - ' + mensaje)
      Contratosperpronota.create(contratosperproceso_id: @contratosperproceso.id, contratospersona_id: @contratosperproceso.contratospersona_id,
                                 user_id: isadmin, nota: 'NO COMPARECENCIA: Abogado: ' + @contratosperprocitacion.user.celular.to_s + ' - ' + mensaje)

      respond_to do |format|
        flash[:notice] = "Se firmo con exito!!"
        format.js { render inline: "location.reload();" }
      end
    else
      @valida = false
    end
  end

  def otp
    @contratosperprocitacion = Contratosperprocitacion.find(params[:id])
    codigo = rand(100000..999999).to_s.gsub("0", "#{rand(1..9)}")
    @contratosperprocitacion.update(codigo_env: codigo)
    mensaje = "ASEAR: Estimad@ #{@contratosperprocitacion.user.nombre}, se ha generado tu codigo para la firma de Citaciones - #{codigo}".html_safe
    Asearsms::SendsmsServices.new.send_sms_procesos(@contratosperprocitacion.user.celular, mensaje)
    Asearmail::SendmailServices.new.sendEmailCodigo(@contratosperprocitacion.user.email,
                                                        "Codigo para la firma de la Citacion",
                                                        "asear_mailer/envio_codigo.html.erb", nil, nil,
                                                        @contratosperprocitacion.user_id,codigo)
  end

  def otp2
    @contratosperprocitacion = Contratosperprocitacion.find(params[:id])
    codigo = rand(100000..999999).to_s.gsub("0", "#{rand(1..9)}")
    @contratosperprocitacion.update(codigo_env_noatendida: codigo)
    mensaje = "ASEAR: Estimad@ #{@contratosperprocitacion.user.nombre}, se ha generado tu codigo para la firma de Citacion No Atendida - #{codigo}".html_safe
    Asearsms::SendsmsServices.new.send_sms_procesos(@contratosperprocitacion.user.celular, mensaje)
    Asearmail::SendmailServices.new.sendEmailCodigo(@contratosperprocitacion.user.email,
                                                    "Codigo para la firma de la Citacion No Atendida",
                                                    "asear_mailer/envio_codigo.html.erb", nil, nil,
                                                    @contratosperprocitacion.user_id,codigo)
  end

  def new
    @active_record = Contratosperprocitacion.find(params[:active_id]) if params[:active_id].present?
    @contratosperproceso = Contratosperproceso.find(params[:contratosperproceso_id])
    @contratosperprocitacion = Contratosperprocitacion.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosperprocitacion.find(params[:active_id]) if params[:active_id].present?
    @contratosperprocitacion = Contratosperprocitacion.find(params[:id])
    @contratosperproceso = @contratosperprocitacion.contratosperproceso
    respond_to { |format| format.js }
  end

  def create
    @contratosperproceso  = Contratosperproceso.find(params[:contratosperproceso_id])
    @contratosperprocitacion = Contratosperprocitacion.new(contratosperprocitacion_params)
    @contratosperprocitacion.contratosperproceso_id = @contratosperproceso.id
    @contratosperprocitacion.contratospersona_id = @contratosperproceso.contratospersona_id
    @contratosperprocitacion.user_id = is_admin
    respond_to do |format|
      if @contratosperprocitacion.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperprocitacion } }
      end
    end
  end

  def update
    @contratosperprocitacion = Contratosperprocitacion.find(params[:id])
    @contratosperproceso = @contratosperprocitacion.contratosperproceso
    respond_to do |format|
      if @contratosperprocitacion.update(contratosperprocitacion_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperprocitacion } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosperprocitacion.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosperprocitacion
    @contratosperproceso = Contratosperproceso.find(params[:contratosperproceso_id])
    @contratosperprocitacion = Contratosperprocitacion.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosperprocitacion_params
    params.require(:contratosperprocitacion).permit!
  end
end
