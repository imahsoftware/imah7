class ConceptosretencionesController < ApplicationController
  before_action :set_conceptosretencion, only: [:show, :destroy]

  def index
    @conceptosretenciones = Conceptosretencion.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Conceptosretencion.find(params[:active_id]) if params[:active_id].present?
    @concepto = Concepto.find(params[:concepto_id])
    @conceptosretencion = Conceptosretencion.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Conceptosretencion.find(params[:active_id]) if params[:active_id].present?
    @conceptosretencion = Conceptosretencion.find(params[:id])
    @concepto = @conceptosretencion.concepto
    respond_to { |format| format.js }
  end

  def create
    @concepto  = Concepto.find(params[:concepto_id])
    @conceptosretencion = Conceptosretencion.new(conceptosretencion_params)
    @conceptosretencion.concepto_id = @concepto.id
    respond_to do |format|
      if @conceptosretencion.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @conceptosretencion } }
      end
    end
  end

  def update
    @conceptosretencion = Conceptosretencion.find(params[:id])
    @concepto = @conceptosretencion.concepto
    respond_to do |format|
      if @conceptosretencion.update(conceptosretencion_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @conceptosretencion } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @conceptosretencion.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_conceptosretencion
    @concepto = Concepto.find(params[:concepto_id])
    @conceptosretencion = Conceptosretencion.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def conceptosretencion_params
    params.require(:conceptosretencion).permit!
  end
end
