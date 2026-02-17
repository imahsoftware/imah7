class ContratoscapapersonasController < ApplicationController
  before_action :set_contratoscapapersona, only: [:show, :destroy]

  def index
    @contratoscapapersonas = Contratoscapapersona.all
  end

=begin
  def cargar_capacitacion_pdf
    @contratoscapapersona = Contratoscapapersona.find(params[:contratoscapapersona_id])
    @contratoscapacitacion = @contratoscapapersona.contratoscapacitacion
    @contrato = @contratoscapapersona.contrato

    fname = "Certificado_capacitacion_#{Time.now.strftime("%d%m%Y")}"
    rutafact = "#{::Rails.root}/public/archivos/pdf/"
    rutanamefile = "#{::Rails.root}/public/archivos/pdf/#{fname}.pdf"
    system("rm -r #{rutanamefile}") rescue nil

    pdf = ApplicationController.render pdf: "#{fname}", template: "contratoscapapersonas/capacitacion_pdf.html.erb", :save_to_file => rutanamefile, :save_only => true,
                                       encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 },
                                       locals: { contratoscapapersona_id: @contratoscapapersona.id, contratoscapacitacion_id: @contratoscapacitacion.id, contrato_id: @contrato.id }

    save_path = Rails.root.join(rutafact, "#{fname}.pdf")
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
    file = File.open("#{::Rails.root}/public/archivos/pdf/#{fname}.pdf", 'rb')
    @contratosperfechasdoc = Contratosperfechasdoc.new
    @contratosperfechasdoc.contratosperfecha_id = @contratoscapapersona.contratosperfecha_id
    @contratosperfechasdoc.soporte_digital = file
    @contratosperfechasdoc.descripcion = "CERTIFICADO_CAPACITACION_#{Time.now.strftime("%d%m%Y_%X")}"
    @contratosperfechasdoc.user_id = is_admin
    @contratosperfechasdoc.tipo = 'CAPACITACION'
    @contratosperfechasdoc.save(validate: false)
    system("rm -r #{rutanamefile}") rescue nil

    flash[:notice] = "Se Cargo el documento con exito!!!"
    redirect_to show_detalle_contratos_path(contratoscapacitacion_id: @contratoscapacitacion.id, contrato_id: @contratoscapacitacion.contrato_id)
  end
=end
  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratoscapapersona.find(params[:active_id]) if params[:active_id].present?
    @contratoscapacitacion = Contratoscapacitacion.find(params[:contratoscapacitacion_id])
    @contratoscapapersona = Contratoscapapersona.new
    respond_to { |format| format.js }
  end

  def devolver
    @contratoscapapersona = Contratoscapapersona.find(params[:contratoscapapersona_id])
    @contratoscapapersona.destroy
    respond_to do |format|
      flash[:notice] = "Se ha devuelto a pendiente"
      format.js { render inline: "location.reload();" }
    end
  end

  def devolver_todo
    Contratoscapapersona.where(contratoscapacitacion_id: params[:contratoscapacitacion_id], estado_evaluacion: 'PENDIENTE').delete_all
    respond_to do |format|
      flash[:notice] = "Se ha devuelto a pendiente"
      format.js { render inline: "location.reload();" }
    end
  end

  def capacitacion_pdf
    @contratoscapapersona = Contratoscapapersona.find(params[:id])
    @contratoscapacitacion = @contratoscapapersona.contratoscapacitacion
    @contrato = @contratoscapapersona.contrato
    respond_to do |format|
      format.pdf { render pdf: "Capacitacion", template: "contratoscapapersonas/capacitacion_pdf.html.erb", encoding: "UTF-8", page_size: 'Letter' }
    end
  end

  def capacitacion_pdf_full
    @contrato = Contrato.find(params[:contrato_id])
    @capacitacion = Capacitacion.find(params[:capacitacion_id])
    respond_to do |format|
      format.pdf { render pdf: "Capacitacion_#{@contrato.id}", template: "contratoscapapersonas/capacitacion_pdf_full.html.erb", encoding: "UTF-8", page_size: 'Letter' }
    end
    # @contratoscapacitacion = Contratoscapacitacion.find(params[:id])
  end

  def capacitacion_pdf_contrato
    @contrato = Contrato.find(params[:contrato_id])
    @mes = params[:mes]
    respond_to do |format|
      format.pdf { render pdf: "Capacitacion_#{@contrato.id}", template: "contratoscapapersonas/capacitacion_pdf_contrato.html.erb", encoding: "UTF-8", page_size: 'Letter' }
    end
  end

  def self.capacitacion_pdf_contrato_combine(mes, contrato_id, is_admin)
    @contrato = Contrato.find(contrato_id)
    @mes = mes
    rutafact = "#{::Rails.root}/public/combinar/"
    fname = "Capacitacion_#{@contrato.id}.pdf"
    rutanamefile = "#{::Rails.root}/public/combinar/#{fname}.pdf"
    pdf = ApplicationController.render pdf: "#{fname}", template: "contratoscapapersonas/capacitacion_pdf_contrato.html.erb", :save_to_file => rutanamefile, :save_only => true,
                                       encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 },
                                       locals: { contrato: @contrato, mes: @mes, isadmin: is_admin }
    save_path = Rails.root.join(rutafact, "#{fname}")
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
  end

  def edit
    @active_record = Contratoscapapersona.find(params[:active_id]) if params[:active_id].present?
    @contratoscapapersona = Contratoscapapersona.find(params[:id])
    @contratoscapacitacion = @contratoscapapersona.contratoscapacitacion
    respond_to { |format| format.js }
  end

  def create
    @contratoscapapersona = Contratoscapapersona.new(contratoscapapersona_params)
    @contrato = Contrato.find(params[:contrato_id])
    @contratosperfecha = Contratosperfecha.find(@contratoscapapersona.contratosperfecha_id)
    @contratoscapacitacion = Contratoscapacitacion.find(params[:contratoscapacitacion_id])
    @capacitacion = @contratoscapacitacion.capacitacion
    @contratoscapapersona.contratospersona_id = @contratosperfecha.contratospersona_id
    @contratoscapapersona.contrato_id = @contrato.id
    @contratoscapapersona.contratoscapacitacion_id = @contratoscapacitacion.id
    @contratoscapapersona.capacitacion_id = @capacitacion.id
    @contratoscapapersona.ruta = 'B'
    respond_to do |format|
      if @contratoscapapersona.save
        # Capacitacionevaluacion.where(capacitacion_id: @contratoscapacitacion.capacitacion_id, estado: 'ACTIVO').order("id asc").each do |eva|
        #  Contratoscaparesultado.create!(capacitacionevaluacion_id: eva.id, capacitacion_id: @contratoscapacitacion.capacitacion_id, contrato_id: @contrato.id,
        #                                 contratoscapapersona_id: @contratoscapapersona.id, contratosperfecha_id: @contratosperfecha.id, ruta: 'B')
        # end
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratoscapapersona } }
      end
    end
  end

  def update
    @contratoscapapersona = Contratoscapapersona.find(params[:id])
    @contratoscapacitacion = @contratoscapapersona.contratoscapacitacion
    respond_to do |format|
      if @contratoscapapersona.update(contratoscapapersona_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratoscapapersona } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratoscapapersona.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contratoscapapersona
    @contratoscapacitacion = Contratoscapacitacion.find(params[:contratoscapacitacion_id])
    @contratoscapapersona = Contratoscapapersona.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratoscapapersona_params
    params.require(:contratoscapapersona).permit!
  end
end