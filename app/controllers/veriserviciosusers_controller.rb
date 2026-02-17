class VeriserviciosusersController < ApplicationController
  before_action :set_veriserviciosuser, only: [:show, :destroy]

  def index
    @veriserviciosusers = Veriserviciosuser.all
  end

  def otp
    @veriserviciosuser = Veriserviciosuser.find(params[:id])
    codigo = rand(100000..999999).to_s.gsub("0", "#{rand(1..9)}")
    @veriserviciosuser.update(codigo_env: codigo)
    mensaje = "ASEAR: Estimad@ #{@veriserviciosuser.user.nombre}, se ha generado tu codigo para la firma de verificacion - #{codigo}".html_safe
    Asearsms::SendsmsServices.new.send_sms_procesos(@veriserviciosuser.user.celular.gsub(' ','').gsub('-',''), mensaje)
    #Asearsms::SendsmsServices.new.send_sms_procesos('3016795087', mensaje)
    Asearmail::SendmailServices.new.sendEmailCodigo(@veriserviciosuser.user.email.downcase, "Codigo para la firma de la verificacion", "asear_mailer/envio_codigo.html.erb", nil, nil, @veriserviciosuser.user_id,codigo)
  end

  def captura_otp
    nr1 = params[:nr1]
    nr2 = params[:nr2]
    nr3 = params[:nr3]
    nr4 = params[:nr4]
    nr5 = params[:nr5]
    nr6 = params[:nr6]
    @veriserviciosuser = Veriserviciosuser.find(params[:id])
    code = nr1 + nr2 + nr3 + nr4 + nr5 + nr6
    if code.to_i == @veriserviciosuser.codigo_env.to_i
      codigoFirma = SecureRandom.hex
      @veriserviciosuser.update(codigo_rec: code, codigo_fecha: Time.now, codigo_firma: codigoFirma)
      @valida = true
      usuarios_con_firma = Veriserviciosuser.where("
                                                    veriservicio_id = ?
                                                    AND codigo_firma IS NOT NULL
                                                    AND veriserviciosagenda_id IN (
                                                      SELECT id
                                                      FROM veriserviciosagendas
                                                      WHERE DATE_FORMAT(fecha_reprogramacion, '%Y-%m-%d') = DATE_FORMAT(NOW(), '%Y-%m-%d')
                                                    )
                                                  ", @veriserviciosuser.veriservicio_id).count

      total_usuarios = Veriserviciosuser.where("veriservicio_id = ?
                                                AND veriserviciosagenda_id IN (
                                                  SELECT id
                                                  FROM veriserviciosagendas
                                                  WHERE DATE_FORMAT(fecha_reprogramacion, '%Y-%m-%d') = DATE_FORMAT(NOW(), '%Y-%m-%d')
                                                )
                                              ", @veriserviciosuser.veriservicio_id).count


      if usuarios_con_firma == total_usuarios
        @veriserviciosuser.veriserviciosagenda.update(estado: 'FINALIZADO')
      end

      unless Veriserviciosuser.where(veriserviciosagenda_id: @veriserviciosuser.veriserviciosagenda_id).where(codigo_firma: nil).exists?
        VeriserviciosController.generar_formatoPdf(@veriserviciosuser.veriserviciosagenda_id, @veriserviciosuser.veriservicio_id, is_admin)
      end


      respond_to do |format|
        flash[:notice] = "Se firmo con exito!!"
        format.js { render inline: "location.reload();" }
      end
    else
      @valida = false
    end
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Veriserviciosuser.find(params[:active_id]) if params[:active_id].present?
    @veriservicio = Veriservicio.find(params[:veriservicio_id])
    @veriserviciosagenda = Veriserviciosagenda.find(params[:veriserviciosagenda_id])
    @veriserviciosuser = Veriserviciosuser.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Veriserviciosuser.find(params[:active_id]) if params[:active_id].present?
    @veriserviciosuser = Veriserviciosuser.find(params[:id])
    @veriservicio = @veriserviciosuser.veriservicio
    respond_to { |format| format.js }
  end

  def create
    @veriservicio  = Veriservicio.find(params[:veriservicio_id])
    @veriserviciosuser = Veriserviciosuser.new(veriserviciosuser_params)
    @veriserviciosuser.veriservicio_id = @veriservicio.id
    @veriserviciosuser.veriserviciosagenda_id = params[:veriserviciosagenda_id]
    respond_to do |format|
      if @veriserviciosuser.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @veriserviciosuser } }
      end
    end
  end

  def update
    @veriserviciosuser = Veriserviciosuser.find(params[:id])
    @veriservicio = @veriserviciosuser.veriservicio
    respond_to do |format|
      if @veriserviciosuser.update(veriserviciosuser_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @veriserviciosuser } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @veriserviciosuser.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_veriserviciosuser
    @veriservicio = Veriservicio.find(params[:veriservicio_id])
    @veriserviciosuser = Veriserviciosuser.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def veriserviciosuser_params
    params.require(:veriserviciosuser).permit!
  end
end
