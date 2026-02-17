class EvaluacionesejecucionesdocsController < ApplicationController
  before_action :set_evaluacionesejecucionesdocs, only: %i[ show edit update destroy new create ]
  before_action :set_active, only: %i[ edit new ]

  def index
    @evaluacionesejecucion = Evaluacionesejecucion.find(current_evaluacionesejecucion)
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @evaluacionesejecucionesdoc = Evaluacionesejecucionesdoc.new
    respond_to { |format| format.js }
  end

  def edit
    @evaluacionesejecucion = @evaluacionesejecucionesdoc.evaluacionesejecucion
    respond_to { |format| format.js }
  end

  def create
    @evaluacionesejecucionesdoc = Evaluacionesejecucionesdoc.new(evaluacionesejecucionesdoc_params)
    @evaluacionesejecucionesdoc.evaluacionesejecucion_id = @evaluacionesejecucion.id
    @evaluacionesejecucionesdoc.user_id = is_admin
    respond_to do |format|
      if @evaluacionesejecucionesdoc.save
        flash[:notice] = "Se creo con Exito!!!"
        format.js
      else
        render 'layouts/errors', locals: { object: @evaluacionesejecucionesdoc }
        format.js
      end
    end
  end

  def update
    @evaluacionesejecucion = @evaluacionesejecucionesdoc.evaluacionesejecucion
    respond_to do |format|
      if @evaluacionesejecucionesdoc.update(evaluacionesejecucionesdoc_params)
        flash[:notice] = "Se actualizo con Exito!!!"
        format.js { render inline: "location.reload();" }
      else
        render 'layouts/errors', locals: { object: @evaluacionesejecucionesdoc }
        format.js
      end
    end
  end

  def eliminar
    @evaluacionesejecucion = Evaluacionesejecucion.find(params[:evaluacionesejecucion_id])
    @evaluacionesejecucionesdoc = Evaluacionesejecucionesdoc.find(params[:id])
    @evaluacionesejecucionesdoc.destroy
  end

  def destroy
    @evaluacionesejecucionesdoc.destroy
    flash['success'] = "Eliminado con Exito!!!"
  end

  def cancelar; end

  private

  def set_evaluacionesejecucionesdocs
    @evaluacionesejecucion = Evaluacionesejecucion.find(params[:evaluacionesejecucion_id])
    @evaluacionesejecucionesdoc = Evaluacionesejecucionesdoc.find(params[:id]) if params[:id]
  end

  def set_active
    @active_record = Evaluacionesejecucionesdoc.find(params[:active_id]) if params[:active_id].present?
  end

  # Only allow a list of trusted parameters through.
  def evaluacionesejecucionesdoc_params
    params.require(:evaluacionesejecucionesdoc).permit!
  end
end
