class ContratosperpronotasController < ApplicationController
  before_action :set_contratosperpronota, only: [:show, :destroy]

  def captura_otp
    nr1 = params[:nr1]
    nr2 = params[:nr2]
    nr3 = params[:nr3]
    nr4 = params[:nr4]
    nr5 = params[:nr5]
    nr6 = params[:nr6]
    @contratosperpronota = Contratosperpronota.find(params[:id])
    @contratosperproceso = @contratosperpronota.contratosperproceso
    code = nr1 + nr2 + nr3 + nr4 + nr5 + nr6
    if code.to_i == @contratosperpronota.codigo_env.to_i
      isadmin = is_admin
      codigoFirma = SecureRandom.hex
      Bitacoraproceso.create!(contratosperproceso_id: @contratosperproceso.id, codigo: @contratosperpronota.codigo_env, user_id: isadmin, proceso: 'NOTAS', codigo_recibido: code,
                              fecha_firma: Time.now, codigo_firma: codigoFirma, id_tabla: @contratosperpronota.id, controlador_tabla: 'contratosperpronotas')
      @contratosperpronota.update(codigo_rec: code, codigo_fecha: Time.now, codigo_firma: codigoFirma)
      @valida = true
      flash[:notice] = "Firmado con exito!!"


      fname = "Asear_Nota"
      rutafact = "#{::Rails.root}/public/archivos/pdf/"
      rutanamefile = "#{::Rails.root}/public/archivos/pdf/#{fname}.pdf"
      system("rm -r #{rutanamefile}") rescue nil

      pdf = ApplicationController.render pdf: "#{fname}", template: "contratosperprocesos/procesos_pdf", :save_to_file => rutanamefile, :save_only => true,
                                         encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 },
                                         locals: { object: 'ATENCION' , object1: @contratosperpronota.id },
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
      @contratosperprodoc.tipo = 'PROCESO NOTAS FIRMADO'
      @contratosperprodoc.user_id = isadmin
      @contratosperprodoc.save(validate: false)
      system("rm -r #{rutanamefile}") rescue nil

    else
      @valida = false
    end
  end

  def otp
    @contratosperpronota = Contratosperpronota.find(params[:id])
  end


  def index
    @contratosperpronotas = Contratosperpronota.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosperpronota.find(params[:active_id]) if params[:active_id].present?
    @contratosperproceso = Contratosperproceso.find(params[:contratosperproceso_id])
    @contratosperpronota = Contratosperpronota.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosperpronota.find(params[:active_id]) if params[:active_id].present?
    @contratosperpronota = Contratosperpronota.find(params[:id])
    @contratosperproceso = @contratosperpronota.contratosperproceso
    respond_to { |format| format.js }
  end

  def create
    @contratosperproceso  = Contratosperproceso.find(params[:contratosperproceso_id])
    @contratosperpronota = Contratosperpronota.new(contratosperpronota_params)
    @contratosperpronota.contratosperproceso_id = @contratosperproceso.id
    @contratosperpronota.contratospersona_id = @contratosperproceso.contratospersona_id
    @contratosperpronota.user_id = is_admin
    respond_to do |format|
      if @contratosperpronota.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperpronota } }
      end
    end
  end

  def update
    @contratosperpronota = Contratosperpronota.find(params[:id])
    @contratosperproceso = @contratosperpronota.contratosperproceso
    respond_to do |format|
      if @contratosperpronota.update(contratosperpronota_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperpronota } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosperpronota.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosperpronota
    @contratosperproceso = Contratosperproceso.find(params[:contratosperproceso_id])
    @contratosperpronota = Contratosperpronota.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosperpronota_params
    params.require(:contratosperpronota).permit!
  end
end
