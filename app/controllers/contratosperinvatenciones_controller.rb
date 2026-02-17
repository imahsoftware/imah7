
class ContratosperinvatencionesController < ApplicationController
  before_action :set_contratosperinvatencion, only: [:show, :destroy]

  def captura_otp
    nr1 = params[:nr1]
    nr2 = params[:nr2]
    nr3 = params[:nr3]
    nr4 = params[:nr4]
    nr5 = params[:nr5]
    nr6 = params[:nr6]
    @contratosperinvatencion = Contratosperinvatencion.find(params[:id])
    @contratosperinventario = @contratosperinvatencion.contratosperinventario
    code = nr1 + nr2 + nr3 + nr4 + nr5 + nr6
    if code.to_i == @contratosperinvatencion.codigo_env.to_i
      isadmin = is_admin
      codigoFirma = SecureRandom.hex
      @contratosperinvatencion.update(codigo_rec: code, codigo_fecha: Time.now, codigo_firma: codigoFirma)
      @valida = true
      if @contratosperinvatencion.contratosperinventario.codigo_firma.present? and @contratosperinvatencion.contratosperinventario.codigo_crea_firma.present?
        @contratosperinvatencion.contratosperinventario.update(estado: 'FIRMADO')

        fname = "Inventario_#{@contratosperinventario.contratospersona.identificacion.to_s}_#{Time.now.strftime("%d%m%Y_%X")}"

        rutafact = "#{::Rails.root}/public/archivos/pdf/"
        rutanamefile = "#{::Rails.root}/public/archivos/pdf/#{fname}.pdf"

        @contratospersona = @contratosperinventario.contratospersona

        pdf = ApplicationController.render pdf: "#{fname}", template: "contratospersonas/inventario_items_ind.html.erb", :save_to_file => rutanamefile, :save_only => true,
                                           encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 },
                                           locals: { contratosperinventario_id: @contratosperinventario.id,
                                                     contratospersona_id: @contratospersona.id }
        save_path = Rails.root.join(rutafact, "#{fname}.pdf")
        File.open(save_path, 'wb') do |file|
          file << pdf
        end
        file = File.open("#{::Rails.root}/public/archivos/pdf/#{fname}.pdf", 'rb')
        @contratosperimagen = Contratosperimagen.new
        @contratosperimagen.contratospersona_id = @contratosperinventario.contratospersona_id
        @contratosperimagen.contratosperfecha_id = @contratosperinventario.contratosperfecha_id
        @contratosperimagen.user_id = isadmin
        @contratosperimagen.personasimagen = file
        @contratosperimagen.descripcion = 'ENTREGA INVENATRIO'
        @contratosperimagen.estado = 'APROBADO'
        @contratosperimagen.created_at = @contratosperinventario.fecha_firma
        @contratosperimagen.updated_at = @contratosperinventario.fecha_firma
        @contratosperimagen.save(validate: false)
        system("rm -r #{rutanamefile}")


      end
      respond_to do |format|
        flash[:notice] = "Se firmo con exito!!"
        format.js { render inline: "location.reload();" }
      end
    else
      @valida = false
    end
  end

  def otp
    @contratosperinvatencion = Contratosperinvatencion.find(params[:id])
    codigo = rand(100000..999999).to_s.gsub("0", "#{rand(1..9)}")
    @contratosperinvatencion.update(codigo_env: codigo)
    mensaje = "ASEAR: Estimad@ #{@contratosperinvatencion.nombre}, se ha generado tu codigo para la firma de la Atencion realizada el dia de hoy - #{codigo}".html_safe
    Asearsms::SendsmsServices.new.send_sms_procesos(@contratosperinvatencion.celular, mensaje)
    Asearmail::SendmailServices.new.sendEmailCodigo(@contratosperinvatencion.email.downcase, "Codigo para la firma de la atencion", "asear_mailer/envio_codigo.html.erb", nil, nil, @contratosperinvatencion.user_id,codigo)
  end

  def index
    @contratosperinvatenciones = Contratosperinvatencion.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosperinvatencion.find(params[:active_id]) if params[:active_id].present?
    @contratosperinventario = Contratosperinventario.find(params[:contratosperinventario_id])
    @contratosperinvatencion = Contratosperinvatencion.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosperinvatencion.find(params[:active_id]) if params[:active_id].present?
    @contratosperinvatencion = Contratosperinvatencion.find(params[:id])
    @contratosperinventario = @contratosperinvatencion.contratosperinventario
    respond_to { |format| format.js }
  end

  def create
    @contratosperinventario  = Contratosperinventario.find(params[:contratosperinventario_id])
    @contratosperinvatencion = Contratosperinvatencion.new(contratosperinvatencion_params)
    @contratosperinvatencion.contratosperinventario_id = @contratosperinventario.id
    @contratosperinvatencion.user_id = is_admin
    respond_to do |format|
      if @contratosperinvatencion.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperinvatencion } }
      end
    end
  end

  def update
    @contratosperinvatencion = Contratosperinvatencion.find(params[:id])
    @contratosperinventario = @contratosperinvatencion.contratosperinventario
    respond_to do |format|
      if @contratosperinvatencion.update(contratosperinvatencion_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperinvatencion } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosperinvatencion.destroy
    respond_to do |format|
      format.js { render inline: "location.reload();" }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosperinvatencion
    @contratosperinventario = Contratosperinventario.find(params[:contratosperinventario_id])
    @contratosperinvatencion = Contratosperinvatencion.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosperinvatencion_params
    params.require(:contratosperinvatencion).permit!
  end
end
