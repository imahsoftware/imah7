
class VisitasatencionesController < ApplicationController
  before_action :set_visitasatencion, only: [:show, :destroy]

  def captura_otp
    nr1 = params[:nr1]
    nr2 = params[:nr2]
    nr3 = params[:nr3]
    nr4 = params[:nr4]
    nr5 = params[:nr5]
    nr6 = params[:nr6]
    @visitasatencion = Visitasatencion.find(params[:id])
    code = nr1 + nr2 + nr3 + nr4 + nr5 + nr6
    if code.to_i == @visitasatencion.codigo_env.to_i
      isadmin = is_admin
      codigoFirma = SecureRandom.hex
      @visitasatencion.update(codigo_rec: code, codigo_fecha: Time.now, codigo_firma: codigoFirma)
      @valida = true
      respond_to do |format|
        flash[:notice] = "Se firmo con exito!!"
        format.js { render inline: "location.reload();" }
      end
    else
      @valida = false
    end
  end

  def otp
    @visitasatencion = Visitasatencion.find(params[:id])
    codigo = rand(100000..999999).to_s.gsub("0", "#{rand(1..9)}")
    @visitasatencion.update(codigo_env: codigo)
    mensaje = "ASEAR: Estimad@ #{@visitasatencion.nombre}, se ha generado tu codigo para la firma de la Atencion realizada el dia de hoy - #{codigo}".html_safe
    Asearsms::SendsmsServices.new.send_sms_procesos(@visitasatencion.celular, mensaje)

    if Parametro.find(18).valor.to_s == 'SI'
      mensaje2 = "ASEAR: Hol@ #{@visitasatencion.user.nombre}, enviado codigo de atencion a #{@visitasatencion.nombre} Cel: #{@visitasatencion.celular}".html_safe
      Asearsms::SendsmsServices.new.send_sms_procesos(@visitasatencion.user.celular, mensaje2)

      mensaje2 = "BENSON...: Enviado codigo de atencion a #{@visitasatencion.nombre} - Cel: #{@visitasatencion.celular} - Codigo - #{codigo}".html_safe
      Asearsms::SendsmsServices.new.send_sms_procesos('3183518701', mensaje2)
    end
    Asearmail::SendmailServices.new.sendEmailCodigo(@visitasatencion.email.downcase, "Codigo para la firma de la atencion", "asear_mailer/envio_codigo.html.erb", nil, nil, @visitasatencion.user_id,codigo)
  end

  def index
    @visitasatenciones = Visitasatencion.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Visitasatencion.find(params[:active_id]) if params[:active_id].present?
    @visita = Visita.find(params[:visita_id])
    @visitasatencion = Visitasatencion.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Visitasatencion.find(params[:active_id]) if params[:active_id].present?
    @visitasatencion = Visitasatencion.find(params[:id])
    @visita = @visitasatencion.visita
    respond_to { |format| format.js }
  end

  def create
    @visita  = Visita.find(params[:visita_id])
    @visitasatencion = Visitasatencion.new(visitasatencion_params)
    @visitasatencion.visita_id = @visita.id
    @visitasatencion.user_id = is_admin
    respond_to do |format|
      if @visitasatencion.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @visitasatencion } }
      end
    end
  end

  def update
    @visitasatencion = Visitasatencion.find(params[:id])
    @visita = @visitasatencion.visita
    respond_to do |format|
      if @visitasatencion.update(visitasatencion_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @visitasatencion } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @visitasatencion.destroy
    respond_to do |format|
      format.js { render inline: "location.reload();" }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_visitasatencion
    @visita = Visita.find(params[:visita_id])
    @visitasatencion = Visitasatencion.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def visitasatencion_params
    params.require(:visitasatencion).permit!
  end
end
