class ContratoscapacitacionesController < ApplicationController
  before_action :set_contratoscapacitaciones, only: %i[ show edit update destroy new create ]
  before_action :set_active, only: %i[ edit new ]
  layout :set_layout
  def index
    @capacitacion = Capacitacion.find(current_capacitacion)
  end

  def capacitacion_pdf
    @contrato = Contrato.find(params[:contrato_id])
    @contratoscapacitacion = Contratoscapacitacion.find(params[:id])
    full = params[:full].to_s rescue nil
    if full.to_s == 'SI'
      @full = 'SI'
    else
      @full = 'NO'
    end
  end

  def new
    @contratoscapacitacion = Contratoscapacitacion.new
    respond_to { |format| format.js }
  end

  def edit
    @capacitacion = @contratoscapacitacion.capacitacion
    respond_to { |format| format.js }
  end

  def create
    @contratoscapacitacion = Contratoscapacitacion.new(contratoscapacitacion_params)
    @contratoscapacitacion.capacitacion_id = @capacitacion.id
    @contratoscapacitacion.user_id = is_admin
    @contratoscapacitacion.estado == 'ACTIVO'
    respond_to do |format|
      if @contratoscapacitacion.save
        flash[:notice] = "Se creo con Exito!!!"
        format.js { render inline: "location.reload();" }
      else
        render 'layouts/errors', locals: { object: @contratoscapacitacion }
        format.js
      end
    end
  end

  def update
    @capacitacion = @contratoscapacitacion.capacitacion
    respond_to do |format|
      if @contratoscapacitacion.update(contratoscapacitacion_params)
        flash[:notice] = "Se actualizo con Exito!!!"
        format.js { render inline: "location.reload();" }
      else
        render 'layouts/errors', locals: { object: @contratoscapacitacion }
        format.js
      end
    end
  end

  def destroy
    @contratoscapacitacion.destroy
    flash['success'] = "Eliminado con Exito!!!"
  end

  def cancelar; end

  private

  def set_layout
    if ['capacitacion_pdf'].include?(action_name)
      'blank'
    else
      "application_admin"
    end
  end


  def set_contratoscapacitaciones
    @capacitacion = Capacitacion.find(params[:capacitacion_id])
    @contratoscapacitacion = Contratoscapacitacion.find(params[:id]) if params[:id]
  end

  def set_active
    @active_record = Contratoscapacitacion.find(params[:active_id]) if params[:active_id].present?
  end

  # Only allow a list of trusted parameters through.
  def contratoscapacitacion_params
    params.require(:contratoscapacitacion).permit!
  end
end


=begin
class ContratoscapacitacionesController < ApplicationController
  before_action :set_contratoscapacitacion, only: [:show, :destroy]

  def index
    @contratoscapacitaciones = Contratoscapacitacion.all
  end

  def capacitacion_pdf
    @contrato = Contrato.find(params[:contrato_id])
    @contratoscapacitacion = Contratoscapacitacion.find(params[:id])
    respond_to do |format|
      format.pdf { render pdf:"Capacitacion", template:"contratoscapacitaciones/capacitacion_pdf", encoding: "UTF-8", page_size: 'Letter'}
    end
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratoscapacitacion.find(params[:active_id]) if params[:active_id].present?
    @contrato = Contrato.find(params[:contrato_id])
    @contratoscapacitacion = Contratoscapacitacion.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratoscapacitacion.find(params[:active_id]) if params[:active_id].present?
    @contratoscapacitacion = Contratoscapacitacion.find(params[:id])
    @contrato = @contratoscapacitacion.contrato
    respond_to { |format| format.js }
  end

  def create
    @contrato  = Contrato.find(params[:contrato_id])
    @contratoscapacitacion = Contratoscapacitacion.new(contratoscapacitacion_params)
    @contratoscapacitacion.contrato_id = @contrato.id
    @contratoscapacitacion.user_id = is_admin
    respond_to do |format|
      if @contratoscapacitacion.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratoscapacitacion } }
      end
    end
  end

  def update
    @contratoscapacitacion = Contratoscapacitacion.find(params[:id])
    @contrato = @contratoscapacitacion.contrato
    respond_to do |format|
      if @contratoscapacitacion.update(contratoscapacitacion_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratoscapacitacion } }
      end
    end
  end

  def destroy
    flash['danger'] = 'Eliminado correctamente'
    @contratoscapacitacion.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratoscapacitacion
    @contrato = Contrato.find(params[:contrato_id])
    @contratoscapacitacion = Contratoscapacitacion.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratoscapacitacion_params
    params.require(:contratoscapacitacion).permit!
  end
end
=end