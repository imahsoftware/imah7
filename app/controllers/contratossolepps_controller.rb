class ContratossoleppsController < ApplicationController
  before_action :set_contratossolepp, only: [:show, :destroy]

  layout :set_layout

  def index
    @contratossolepps = Contratossolepp.where(user_id: is_admin).order("id desc")
  end

  def procesos
    isadmin = is_admin
    @etapaa = params[:etapaa].present? ? params[:etapaa] : 'A' rescue nil
    @query = Migracion.joins([:migracionesusers]).where(["migracionesusers.user_id = #{isadmin} and migraciones.estado = 'ACTIVO' and migraciones.publicado = 'EP'"]).order("orden asc").map { |m| [m.nombre, m.nombre_resultado, m.id] }
    etapa = User.find(isadmin).etapa.to_s
    if etapa == 'SOLICITUDES'
      @contratossolepps = Contratossolepp.where(user_id: isadmin).order("id desc")
    elsif etapa == 'ENTREGAS'
      @contratosentepps = Contratosentepp.where(user_id: isadmin).order("id desc")
    elsif etapa == 'ADMINISTRATIVO' and current_user.subetapa.to_s == 'CONTROL EMPRESAS'
      nroreg = 10
      if params[:autobuscar].to_s != ""
        @empresas = Empresa.searchInformeEpps(params[:autobuscar], params[:page], 10)
      else
        @empresas = Empresa.where("id in (select empresa_id from contratos where id in (select contrato_id from contratosentepps))").order("nombre ASC")
      end
    end
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratossolepp.find(params[:active_id]) if params[:active_id].present?
    @contratossolepp = Contratossolepp.new
    respond_to { |format| format.js }
  end

  def etapar
    if params[:etapa].present?
      User.where(id: is_admin).update_all(etapa: params[:etapa].to_s, updated_at: Time.now)
    end
    redirect_to root_path
  end

  def edit
    @active_record = Contratossolepp.find(params[:active_id]) if params[:active_id].present?
    @contratossolepp = Contratossolepp.find(params[:id])
    respond_to { |format| format.js }
  end

  def complementar
    @etapa = params[:etapa].present? ? params[:etapa] : 'A'
    @contratossolepp = Contratossolepp.find(params[:id])
    respond_to do |format|
      format.html { render :action => "complementar" }
    end
  end

  def otp
    @contratossolepp = Contratossolepp.find(params[:id])
    codigo = rand(100000..999999).to_s.gsub("0", "#{rand(1..9)}")
    @contratossolepp.update(codigo_env: codigo)
    mensaje = "ASEAR: Estimad@ #{@contratossolepp.user.nombre}, se ha generado tu codigo para la entrega de la solicitud - #{codigo}".html_safe
    Asearsms::SendsmsServices.new.send_sms_procesos(@contratossolepp.user.celular, mensaje)
    Asearmail::SendmailServices.new.sendEmailCodigo(@contratossolepp.user.email, "Codigo para la firma de la entrega de la solicitud", "asear_mailer/envio_codigo.html.erb", nil, nil, -1, codigo)
  end

  def captura_otp
    nr1 = params[:nr1]
    nr2 = params[:nr2]
    nr3 = params[:nr3]
    nr4 = params[:nr4]
    nr5 = params[:nr5]
    nr6 = params[:nr6]
    @contratossolepp = Contratossolepp.find(params[:id])
    code = nr1 + nr2 + nr3 + nr4 + nr5 + nr6
    if code.to_i == @contratossolepp.codigo_env.to_i
      codigoFirma = SecureRandom.hex
      @contratossolepp.codigo_rec = code
      @contratossolepp.codigo_fecha = Time.now
      @contratossolepp.codigo_firma = codigoFirma
      @contratossolepp.estado = 'ENTREGADO'
      @contratossolepp.save(validate: false)

      Contratossoleppsbitacora.create!(contratossolepp_id: @contratossolepp.id, detalle: "LA SOLICITUD HA SIDO MARCADA COMO ENTREGADO POR EL USUARIO #{current_user.nombre}")
      @valida = true
      respond_to do |format|
        flash[:notice] = "Se firmo con exito!!"
        format.js { render inline: "location.reload();" }
      end
    else
      @valida = false
    end
  end

  def create
    @contratossolepp = Contratossolepp.new(contratossolepp_params)
    @contratossolepp.user_id = is_admin
    if @contratossolepp.requiere == 'NO'
      @contratossolepp.estado = 'ENTREGADO'
      @contratossolepp.fecha_despacho = Time.now
      @contratossolepp.user_despacha = is_admin
      @contratossolepp.codigo_fecha = Time.now
    end
    respond_to do |format|
      if @contratossolepp.save
        Contratossoleppsbitacora.create!(contratossolepp_id: @contratossolepp.id, detalle: "REGISTRO CREADO POR #{current_user.nombre}")
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratossolepp } }
      end
    end
  end

  def rotulo
    @contratossolepp = Contratossolepp.find(params[:id])
  end

  def update
    validador = params[:validador] rescue nil
    @contratossolepp = Contratossolepp.find(params[:id])
    @contratossolepp.valida_campos(validador)
    @contratossolepp.cedula = params[:contratossolepp][:cedula] rescue nil
    @contratossolepp.nombre = params[:contratossolepp][:nombre] rescue nil
    @contratossolepp.direccion = params[:contratossolepp][:direccion] rescue nil
    @contratossolepp.telefono = params[:contratossolepp][:telefono] rescue nil
    respond_to do |format|
      if @contratossolepp.update(contratossolepp_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @contratossolepp } }
      end
    end
  end

  def ver
    @contratossolepp = Contratossolepp.find(params[:id])
    @contrato = @contratossolepp.contrato
  end

  def estado
    @contratossolepp = Contratossolepp.find(params[:id])
    @contratossolepp.estado = params[:estado]
    if params[:estado] == 'DESPACHADO'
      @contratossolepp.fecha_despacho = Time.now
      @contratossolepp.user_despacha = is_admin
    end
    if params[:estado] == 'ENTREGADO'
      @contratossolepp.codigo_fecha = Time.now
    end
    @contratossolepp.save(validate: false)
    Contratossoleppsbitacora.create!(contratossolepp_id: @contratossolepp.id, detalle: "LA SOLICITUD HA SIDO - #{params[:estado].to_s} POR EL USUARIO #{current_user.nombre}")
    respond_to do |format|
      flash['success'] = 'Registro enviado con exito'
      format.js { render inline: "location.reload();" }
    end
  end

  def destroy
    @contratossolepp.destroy
    respond_to do |format|
      flash['success'] = 'Eliminado correctamente'
      format.js { render inline: "location.reload();" }
    end
  end

  def etapar
    if params[:etapa].to_s != ""
      if params[:subetapa].to_s != ""
        User.where(id: is_admin).update_all(etapa: params[:etapa].to_s, subetapa: params[:subetapa].to_s, updated_at: Time.now)
      else
        User.where(id: is_admin).update_all(etapa: params[:etapa].to_s, updated_at: Time.now)
      end
    end
    redirect_to procesos_contratossolepps_path
  end

  private

  def set_layout
    if ['ver', 'rotulo'].include?(action_name)
      'blank'
    else
      'application_admin'
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_contratossolepp
    @contratossolepp = Contratossolepp.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratossolepp_params
    params.require(:contratossolepp).permit!
  end
end
