class ContratosobservacionesController < ApplicationController
  before_action :set_contratosobservacion, only: [:show, :destroy]

  def index
    @contratosobservaciones = Contratosobservacion.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosobservacion.find(params[:active_id]) if params[:active_id].present?
    @contrato = Contrato.find(params[:contrato_id])
    @contratosobservacion = Contratosobservacion.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosobservacion.find(params[:active_id]) if params[:active_id].present?
    @contratosobservacion = Contratosobservacion.find(params[:id])
    @contrato = @contratosobservacion.contrato
    respond_to { |format| format.js }
  end

  def create
    @contrato  = Contrato.find(params[:contrato_id])
    @contratosobservacion = Contratosobservacion.new(contratosobservacion_params)
    @contratosobservacion.contrato_id = @contrato.id
    @contratosobservacion.user_id = is_admin
    respond_to do |format|
      if @contratosobservacion.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosobservacion } }
      end
    end
  end

  def update
    @contratosobservacion = Contratosobservacion.find(params[:id])
    @contratosobservacion.user_act = is_admin
    @contrato = @contratosobservacion.contrato
    respond_to do |format|
      if @contratosobservacion.update(contratosobservacion_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosobservacion } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosobservacion.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosobservacion
    @contrato = Contrato.find(params[:contrato_id])
    @contratosobservacion = Contratosobservacion.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosobservacion_params
    params.require(:contratosobservacion).permit!
  end
end
