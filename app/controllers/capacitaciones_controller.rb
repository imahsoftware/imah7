class CapacitacionesController < ApplicationController
  before_action :set_capacitacion, only: [:show, :edit, :update, :destroy]

  layout :set_layout
  before_action :checkaccess, except: ['show_detalle', 'envia_capacitacion','ws_otp']

  def checkaccess
    return is_permit('capacitaciones')
  end

  def clonar
    @capacitacion = Capacitacion.find(params[:id])
    ActiveRecord::Base.connection.execute("CALL prc_duplicar_capacitacion(#{@capacitacion.id},#{is_admin})")
    respond_to do |format|
      flash[:notice] = "Capacitacion Clonada con Exito!!!"
      format.js { render inline: "location.reload();" }
    end
  end

  def index
    if is_auth_c('capacitacionedicion')
      @capacitaciones = Capacitacion.joins(:user)
                                    .select("capacitaciones.*, users.nombre nombreusuario, (select distinct 'X' from contratoscapapersonas where capacitacion_id = capacitaciones.id) capaper")
                                    .all.order("created_at desc")
    else
      redirect_to root_path
    end
  end

  def incluirtodos
    capacitacionId = params[:capacitacion_id]
    isadmin = is_admin
    vcClase = params[:clase].to_s
    ActiveRecord::Base.connection.execute("CALL prc_capacitaciones_contratos(#{capacitacionId},#{isadmin},'#{vcClase}')")
    redirect_to edit_capacitacion_path(id: capacitacionId, subetapa: 3)
  end

  def envia_capacitacion
    @contrato = Contrato.find(params[:contrato_id])
    @contratoscapapersona = Contratoscapapersona.find(params[:contratoscapapersona_id])
    @capacitacion = Capacitacion.find(params[:capacitacion_id])
    @codigo = rand(100000..999999).to_s.gsub("0", "#{rand(1..9)}")
    @contratoscapapersona.update(codigo_envio: @codigo)
    mensaje = "ASEAR: Estimad@ #{current_user.nombre}, se ha generado tu codigo para firma la capacitacion (#{@capacitacion.descripcion}) - #{@codigo} - ".html_safe
    Asearsms::SendsmsServices.new.send_sms_procesos(current_user.celular, mensaje)
    Asearmail::SendmailServices.new.sendEmailCodigo(current_user.email, "Codigo para la firma de la capacitacion", "asear_mailer/envio_codigo.html.erb", nil, nil, current_user.id,@codigo)
  end

  def ws_otp
    nr1 = params[:nr1]
    nr2 = params[:nr2]
    nr3 = params[:nr3]
    nr4 = params[:nr4]
    nr5 = params[:nr5]
    nr6 = params[:nr6]
    @contrato = Contrato.find(params[:contrato_id])
    @contratoscapapersona = Contratoscapapersona.find(params[:contratoscapapersona_id])
    @capacitacion = Capacitacion.find(params[:capacitacion_id])
    @contratoscapacitacion = @contratoscapapersona.contratoscapacitacion
    code = nr1 + nr2 + nr3 + nr4 + nr5 + nr6
    if code == @contratoscapapersona.codigo_envio
      sum_resultado = Contratoscaparesultado.where(contratoscapapersona_id: @contratoscapapersona.id, capacitacion_id: @capacitacion.id, contratosperfecha_id: @contratoscapapersona.contratosperfecha_id).sum(:resultado)
      @contratoscapapersona.update(estado_evaluacion: 'FINALIZADO', fecha_finalizacion: Time.now, resultado_evaluacion: sum_resultado.to_i, codigo_recibido: code, fecha_firma: Time.now, codigo_firma: SecureRandom.hex)
      ActiveRecord::Base.connection.execute("CALL prc_validacalificacion(#{@contratoscapapersona.id})")
      @valida = false
      Ejecucion.create(user_id: is_admin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO SMS',
                       controlador_metodo: "CapacitacionesController.firmacapacitacion(#{@contratoscapapersona.id},#{is_admin})", created_at: Time.now)
    else
      @valida = true
    end
  end

  def self.firmacapacitacion(contratoscapapersonaid, isadmin)
    @contratoscapapersona = Contratoscapapersona.find(contratoscapapersonaid)
    fname = "Certificado_capacitacion_#{Time.now.strftime("%Y%m%d")}"
    rutafact = "#{::Rails.root}/public/archivos/pdf/"
    rutanamefile = "#{::Rails.root}/public/archivos/pdf/#{fname}.pdf"
    system("rm -r #{rutanamefile}") rescue nil

    pdf = ApplicationController.render pdf: "#{fname}", template: "contratoscapapersonas/capacitacion_pdf.html.erb", :save_to_file => rutanamefile, :save_only => true,
                                       encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 },
                                       locals: { contratoscapapersona_id: @contratoscapapersona.id,
                                                 contratoscapacitacion_id: @contratoscapapersona.contratoscapacitacion_id,
                                                 contrato_id: @contratoscapapersona.contrato_id }

    save_path = Rails.root.join(rutafact, "#{fname}.pdf")
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
    file = File.open("#{::Rails.root}/public/archivos/pdf/#{fname}.pdf", 'rb')
    @contratosperimagen = Contratosperimagen.new
    @contratosperimagen.contratospersona_id = @contratoscapapersona.contratospersona_id
    @contratosperimagen.contratosperfecha_id = @contratoscapapersona.contratosperfecha_id
    @contratosperimagen.user_id = isadmin
    @contratosperimagen.personasimagen = file
    @contratosperimagen.descripcion = "CERTIFICADO CAPACITACION"
    @contratosperimagen.estado = 'APROBADO'
    @contratosperimagen.created_at = @contratoscapapersona.fecha_finalizacion
    @contratosperimagen.updated_at = @contratoscapapersona.fecha_finalizacion
    @contratosperimagen.save(validate: false)
=begin
    @contratosperfechasdoc = Contratosperfechasdoc.new
    @contratosperfechasdoc.contratosperfecha_id = @contratoscapapersona.contratosperfecha_id
    @contratosperfechasdoc.soporte_digital = file
    @contratosperfechasdoc.descripcion = "CERTIFICADO_CAPACITACION_#{Time.now.strftime("%Y%m%d")}"
    @contratosperfechasdoc.user_id = isadmin
    @contratosperfechasdoc.tipo = 'CAPACITACION'
    @contratosperfechasdoc.save(validate: false)
=end
    system("rm -r #{rutanamefile}") rescue nil
  end

  def show_detalle
    @ruta = params[:ruta]
    @contratoscapapersona = Contratoscapapersona.find(params[:contratoscapapersona_id])
    @contrato = Contrato.find(params[:contrato_id])
    if Contratoscaparesultado.where(contrato_id: @contrato.id, contratoscapapersona_id: @contratoscapapersona.id, capacitacion_id: @contratoscapapersona.capacitacion_id, respuesta: nil).count.zero?
      @mostrarboton = true
    else
      @mostrarboton = false
    end
  end

  def new
    @capacitacion = Capacitacion.new
    render "capacitacion_form"
  end

  def edit
    if is_auth_c('capacitacionedicion')
      respond_to do |format|
        format.html { render :action => "capacitacion_form" }
      end
    else
      redirect_to root_path
    end
  end

  def create
    @capacitacion = Capacitacion.new(capacitacion_params)
    @capacitacion.user_id = is_admin
    respond_to do |format|
      if @capacitacion.save
        format.html { redirect_to edit_capacitacion_path(id: @capacitacion.id, subetapa: '1'), notice: "El registro ha sido registrado con Exito." }
        format.json { render :show, status: :created, location: @capacitacion }
      else
        format.html { render :action => "capacitacion_form" }
        format.json { render json: @capacitacion.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @capacitacion.update(capacitacion_params)
      flash['success'] = "Usuario actualizado"
      redirect_to edit_capacitacion_path(id: @capacitacion.id, subetapa: '1')
    else
      render "capacitacion_form"
    end
  end

  def destroy
    if !Contratoscapapersona.where(capacitacion_id: @capacitacion.id).present?
      @capacitacion.destroy
      flash[:notice] = "El registro ha sido borrado con Exito."
    end
    respond_to do |format|
      format.html { redirect_to capacitaciones_path }
      format.xml { head :ok }
    end
  end

  private

  def set_layout
    if ['index', 'new'].include?(action_name)
      'application_admin'
    elsif ['edit'].include?(action_name)
      'application_admin'
    else
      "application_admin"
    end
  end

  def set_capacitacion
    if params[:subetapa].to_s != ""
      @subetapa = params[:subetapa].to_s
      User.find(is_admin).update_columns(subetapa: @subetapa)
    end
    @capacitacion = Capacitacion.find(params[:id])
  end

  def capacitacion_params
    params.require(:capacitacion).permit!
  end
end
