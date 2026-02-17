
class ContratossoleppsatencionesController < ApplicationController
  before_action :set_contratossoleppsatencion, only: [:show, :destroy]

  def captura_otp
    nr1 = params[:nr1]
    nr2 = params[:nr2]
    nr3 = params[:nr3]
    nr4 = params[:nr4]
    nr5 = params[:nr5]
    nr6 = params[:nr6]
    @contratossoleppsatencion = Contratossoleppsatencion.find(params[:id])
    code = nr1 + nr2 + nr3 + nr4 + nr5 + nr6
    if code.to_i == @contratossoleppsatencion.codigo_env.to_i
      isadmin = is_admin
      codigoFirma = SecureRandom.hex
      @contratossoleppsatencion.update(codigo_rec: code, codigo_fecha: Time.now, codigo_firma: codigoFirma)
      Contratossolepp.where(id: @contratossoleppsatencion.contratossolepp_id).update_all(codigo_rec: code, codigo_fecha: Time.now, codigo_firma: codigoFirma)
      @valida = true
      respond_to do |format|
        flash[:notice] = "Se firmo con exito!!"
        format.js { render inline: "location.reload();" }
      end
    else
      @valida = false
    end
  end

  def captura_otp_google_authenticator
    @contratossoleppsatencion = Contratossoleppsatencion.find(params[:id])
    otp_code = params[:nr1].to_s + params[:nr2].to_s + params[:nr3].to_s + params[:nr4].to_s + params[:nr5].to_s + params[:nr6].to_s

    if @contratossoleppsatencion && otp_code.present?
      otp_secret = session[:otp_secret]
      totp = ROTP::TOTP.new(otp_secret)
      if totp.verify(otp_code)
        isadmin = is_admin
        codigo_firma = SecureRandom.hex
        @contratossoleppsatencion.update(codigo_rec: otp_code, codigo_fecha: Time.now, codigo_firma: codigo_firma)
        @valida = true
        respond_to do |format|
          format.js { render js: "location.reload();", notice: '¡Se firmó con éxito!' }
        end
        return
      end
    end

    # Si la verificación del código OTP falla
    @valida = false
    respond_to do |format|
      format.js { render js: "alert('Código de Google Authenticator no válido');", status: :unprocessable_entity }
    end

  end

  def otp
    @contratossoleppsatencion = Contratossoleppsatencion.find(params[:id])
    codigo = rand(100000..999999).to_s.gsub("0", "#{rand(1..9)}")
    @contratossoleppsatencion.update(codigo_env: codigo)
    mensaje = "ASEAR: Estimad@ #{@contratossoleppsatencion.nombre}, se ha generado tu codigo para la firma de la Atencion realizada el dia de hoy - #{codigo}".html_safe
    Asearsms::SendsmsServices.new.send_sms_procesos(@contratossoleppsatencion.celular, mensaje)
    Asearmail::SendmailServices.new.sendEmailCodigo(@contratossoleppsatencion.email.downcase, "Codigo para la firma de la atencion", "asear_mailer/envio_codigo.html.erb", nil, nil, @contratossoleppsatencion.user_id,codigo)
  end

  def index
    @contratossoleppsatenciones = Contratossoleppsatencion.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratossoleppsatencion.find(params[:active_id]) if params[:active_id].present?
    @contratossolepp = Contratossolepp.find(params[:contratossolepp_id])
    @contratossoleppsatencion = Contratossoleppsatencion.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratossoleppsatencion.find(params[:active_id]) if params[:active_id].present?
    @contratossoleppsatencion = Contratossoleppsatencion.find(params[:id])
    @contratossolepp = @contratossoleppsatencion.contratossolepp
    respond_to { |format| format.js }
  end

  def create
    @contratossolepp  = Contratossolepp.find(params[:contratossolepp_id])
    @contratossoleppsatencion = Contratossoleppsatencion.new(contratossoleppsatencion_params)
    @contratossoleppsatencion.contratossolepp_id = @contratossolepp.id
    @contratossoleppsatencion.user_id = is_admin
    respond_to do |format|
      if @contratossoleppsatencion.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratossoleppsatencion } }
      end
    end
  end

  def update
    @contratossoleppsatencion = Contratossoleppsatencion.find(params[:id])
    @contratossolepp = @contratossoleppsatencion.contratossolepp
    respond_to do |format|
      if @contratossoleppsatencion.update(contratossoleppsatencion_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratossoleppsatencion } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratossoleppsatencion.destroy
    respond_to do |format|
      format.js { render inline: "location.reload();" }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratossoleppsatencion
    @contratossolepp = Contratossolepp.find(params[:contratossolepp_id])
    @contratossoleppsatencion = Contratossoleppsatencion.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratossoleppsatencion_params
    params.require(:contratossoleppsatencion).permit!
  end
end
