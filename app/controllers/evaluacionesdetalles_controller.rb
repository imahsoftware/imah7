class EvaluacionesdetallesController < ApplicationController
  before_action :set_evaluacionesdetalles, only: %i[ show edit update destroy new create ]
  before_action :set_active, only: %i[ edit new ]

  def index
    @evaluacion = Evaluacion.find(current_evaluacion)
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @evaluacionesdetalle = Evaluacionesdetalle.new
    respond_to { |format| format.js }
  end

  def edit
    @evaluacion = @evaluacionesdetalle.evaluacion
    respond_to { |format| format.js }
  end

  def create
    @evaluacionesdetalle = Evaluacionesdetalle.new(evaluacionesdetalle_params)
    @evaluacionesdetalle.evaluacion_id = @evaluacion.id
    @evaluacionesdetalle.user_id = is_admin
    respond_to do |format|
      if @evaluacionesdetalle.save
        flash[:notice] = "Se creo con Exito!!!"
        format.js
      else
        render 'layouts/errors', locals: { object: @evaluacionesdetalle }
        format.js
      end
    end
  end

  def update
    @evaluacion = @evaluacionesdetalle.evaluacion
    respond_to do |format|
      if @evaluacionesdetalle.update(evaluacionesdetalle_params)
        flash[:notice] = "Se actualizo con Exito!!!"
        format.js { render inline: "location.reload();" }
      else
        render 'layouts/errors', locals: { object: @evaluacionesdetalle }
        format.js
      end
    end
  end

  def destroy
    @evaluacionesdetalle.destroy
    flash['success'] = "Eliminado con Exito!!!"
  end

  def cancelar; end

  private

  def set_evaluacionesdetalles
    @evaluacion = Evaluacion.find(params[:evaluacion_id])
    @evaluacionesdetalle = Evaluacionesdetalle.find(params[:id]) if params[:id]
  end

  def set_active
    @active_record = Evaluacionesdetalle.find(params[:active_id]) if params[:active_id].present?
  end

  # Only allow a list of trusted parameters through.
  def evaluacionesdetalle_params
    params.require(:evaluacionesdetalle).permit!
  end
end
