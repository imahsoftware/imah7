class ContratosperprodescargosController < ApplicationController
  before_action :set_contratosperprodescargo, only: [:show, :destroy]

  def captura_otp
    nr1 = params[:nr1]
    nr2 = params[:nr2]
    nr3 = params[:nr3]
    nr4 = params[:nr4]
    nr5 = params[:nr5]
    nr6 = params[:nr6]
    @contratosperproceso = Contratosperproceso.find(params[:id])
    code = nr1 + nr2 + nr3 + nr4 + nr5 + nr6
    if code.to_i == @contratosperproceso.codigo_env_descargo.to_i
      isadmin = is_admin
      codigoFirma = SecureRandom.hex
      Bitacoraproceso.create!(contratosperproceso_id: @contratosperproceso.id, codigo: @contratosperproceso.codigo_env_descargo, user_id: isadmin, proceso: 'DESCARGOS', codigo_recibido: code,
                              fecha_firma: Time.now, codigo_firma: codigoFirma, id_tabla: @contratosperproceso.id, controlador_tabla: 'contratosperprocesos')
      @contratosperproceso.codigo_rec_descargo = code
      @contratosperproceso.codigo_fecha_descargo = Time.now
      @contratosperproceso.codigo_firma_descargo = codigoFirma
      @contratosperproceso.user_descargo = isadmin
      @contratosperproceso.save(validate: false)
      @valida = true
      flash[:notice] = "Firmado con exito!!"
    else
      @valida = false
    end
  end

  def otp
    @contratosperproceso = Contratosperproceso.find(params[:id])
    @contratosperproceso.codigo_env_descargo = rand(100000..999999).to_s.gsub("0", "#{rand(1..9)}")
    @contratosperproceso.save(validate: false)
    mensaje = "ASEAR: Estimad@ #{current_user.celular}, se ha generado tu codigo para la firma de los descargos - #{@contratosperproceso.codigo_env_descargo}".html_safe
    Asearsms::SendsmsServices.new.send_sms_procesos(current_user.celular, mensaje)
    Asearmail::SendmailServices.new.sendEmailCodigo(current_user.email, "Codigo para la firma de los descargos", "asear_mailer/envio_codigo.html.erb", nil, nil, -1,@contratosperproceso.codigo_env_descargo)
  end

  def captura_otp2
    nr1 = params[:nr1]
    nr2 = params[:nr2]
    nr3 = params[:nr3]
    nr4 = params[:nr4]
    nr5 = params[:nr5]
    nr6 = params[:nr6]
    @contratosperproceso = Contratosperproceso.find(params[:id])
    code = nr1 + nr2 + nr3 + nr4 + nr5 + nr6
    if code.to_i == @contratosperproceso.codigo_env_user_descargo.to_i
      isadmin = is_admin
      codigoFirma = SecureRandom.hex

      Bitacoraproceso.create!(contratosperproceso_id: @contratosperproceso.id, codigo: @contratosperproceso.codigo_env_user_descargo, user_id: isadmin, proceso: 'DESCARGOS USER', codigo_recibido: code,
                              fecha_firma: Time.now, codigo_firma: codigoFirma, id_tabla: @contratosperproceso.id, controlador_tabla: 'contratosperprocesos')
      @contratosperproceso.codigo_rec_user_descargo = code
      @contratosperproceso.codigo_fecha_user_descargo = Time.now
      @contratosperproceso.codigo_firma_user_descargo = codigoFirma
      @contratosperproceso.save(validate: false)
      @valida = true
      flash[:notice] = "Firmado con exito!!"
      Ejecucion.create(user_id: isadmin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO SMS',
                       controlador_metodo: "ContratosperprodescargosController.firma(#{@contratosperproceso.id},#{isadmin})", created_at: Time.now)
    else
      @valida = false
    end
  end

  def self.firma(nmPersonasProcesoId,isAdmin)
    @contratosperproceso = Contratosperproceso.find(nmPersonasProcesoId)
    isadmin = isAdmin
    fname = "Descargos_#{@contratosperproceso.id}_#{Time.now.strftime("%d%m%Y_%X")}"
    rutafact = "#{::Rails.root}/public/archivos/pdf/"
    rutanamefile = "#{::Rails.root}/public/archivos/pdf/#{fname}.pdf"
    system("rm -r #{rutanamefile}") rescue nil

    pdf = ApplicationController.render pdf: "#{fname}", template: "contratosperprocesos/procesos_pdf", :save_to_file => rutanamefile, :save_only => true,
                                       encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 },
                                       locals: { object: 'DESCARGO', object1: @contratosperproceso.id },
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
    @contratosperprodoc.tipo = 'PROCESO DESCARGOS FIRMADO'
    @contratosperprodoc.user_id = isadmin
    @contratosperprodoc.proceso = 'DESCARGOS'
    @contratosperprodoc.id_proceso = @contratosperproceso.id
    @contratosperprodoc.save(validate: false)
    system("rm -r #{rutanamefile}") rescue nil
  end

  def otp2
    @contratosperproceso = Contratosperproceso.find(params[:id])
    @contratosperproceso.codigo_env_user_descargo = rand(100000..999999).to_s.gsub("0", "#{rand(1..9)}")
    @contratosperproceso.save(validate: false)
    mensaje = "ASEAR: Estimad@ #{@contratosperproceso.contratospersona.nombres}, se ha generado tu codigo para la firma de los descargos. - #{@contratosperproceso.codigo_env_user_descargo}".html_safe
    Asearsms::SendsmsServices.new.send_sms_procesos(@contratosperproceso.contratospersona.movil, mensaje)
    Asearmail::SendmailServices.new.sendEmailCodigo(@contratosperproceso.contratospersona.correo, "Codigo para la firma de los descargos", "asear_mailer/envio_codigo.html.erb", nil, nil, -1,@contratosperproceso.codigo_env_user_descargo)
  end

  def index
    @contratosperprodescargos = Contratosperprodescargo.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosperprodescargo.find(params[:active_id]) if params[:active_id].present?
    @contratosperproceso = Contratosperproceso.find(params[:contratosperproceso_id])
    @contratosperprodescargo = Contratosperprodescargo.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosperprodescargo.find(params[:active_id]) if params[:active_id].present?
    @contratosperprodescargo = Contratosperprodescargo.find(params[:id])
    @contratosperproceso = @contratosperprodescargo.contratosperproceso
    respond_to { |format| format.js }
  end

  def create
    @contratosperproceso = Contratosperproceso.find(params[:contratosperproceso_id])
    @contratosperprodescargo = Contratosperprodescargo.new(contratosperprodescargo_params)
    @contratosperprodescargo.contratosperproceso_id = @contratosperproceso.id
    @contratosperprodescargo.contratospersona_id = @contratosperproceso.contratospersona_id
    @contratosperprodescargo.user_id = is_admin
    respond_to do |format|
      if @contratosperprodescargo.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperprodescargo } }
      end
    end
  end

  def update
    @contratosperprodescargo = Contratosperprodescargo.find(params[:id])
    @contratosperproceso = @contratosperprodescargo.contratosperproceso
    respond_to do |format|
      if @contratosperprodescargo.update(contratosperprodescargo_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperprodescargo } }
      end
    end
  end

  def destroy
    @contratosperprodescargo.destroy
    respond_to do |format|
      flash['success'] = 'Eliminado correctamente'
      format.js { render inline: "location.reload();" }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contratosperprodescargo
    @contratosperproceso = Contratosperproceso.find(params[:contratosperproceso_id])
    @contratosperprodescargo = Contratosperprodescargo.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosperprodescargo_params
    params.require(:contratosperprodescargo).permit!
  end
end
