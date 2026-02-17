class CapacitacionevaluacionesController < ApplicationController
  before_action :set_capacitacionevaluaciones, only: %i[ show edit update destroy new create ]
  before_action :set_active, only: %i[ edit new ]

  def index
    @capacitacion = Capacitacion.find(current_capacitacion)
  end

  def estado
    @capacitacionevaluacion = Capacitacionevaluacion.find(params[:id])
    @capacitacionevaluacion.estado = params[:estado]
    @capacitacionevaluacion.save(validate: false)
    flash[:notice] = "Se cambio el estado con Exito!!!"
    redirect_to edit_capacitacion_path(id: @capacitacionevaluacion.capacitacion_id, subetapa: '2')
  end

  def show_detalle
    @ruta = params[:ruta]
    @capacitacionevaluacion = Capacitacionevaluacion.find(params[:id])
    @capacitacion = Capacitacion.find(params[:capacitacion_id])
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @capacitacionevaluacion = Capacitacionevaluacion.new
    respond_to { |format| format.js }
  end

  def edit
    @capacitacion = @capacitacionevaluacion.capacitacion
    respond_to { |format| format.js }
  end

  def create
    @capacitacionevaluacion = Capacitacionevaluacion.new(capacitacionevaluacion_params)
    @capacitacionevaluacion.capacitacion_id = @capacitacion.id
    @capacitacionevaluacion.user_id = is_admin
    respond_to do |format|
      if @capacitacionevaluacion.save
        flash[:notice] = "Se creo con Exito!!!"
        format.js { render inline: "location.reload();" }
      else
        render 'layouts/errors', locals: { object: @capacitacionevaluacion }
        format.js
      end
    end
  end

  def update
    @capacitacion = @capacitacionevaluacion.capacitacion
    respond_to do |format|
      if @capacitacionevaluacion.update(capacitacionevaluacion_params)
        flash[:notice] = "Se actualizo con Exito!!!"
        format.js { render inline: "location.reload();" }
      else
        render 'layouts/errors', locals: { object: @capacitacionevaluacion }
        format.js
      end
    end
  end

  def destroy
    @capacitacionevaluacion.destroy
    flash['success'] = "Eliminado con Exito!!!"
  end

  def cancelar; end

  private

  def set_capacitacionevaluaciones
    @capacitacion = Capacitacion.find(params[:capacitacion_id])
    @capacitacionevaluacion = Capacitacionevaluacion.find(params[:id]) if params[:id]
  end

  def set_active
    @active_record = Capacitacionevaluacion.find(params[:active_id]) if params[:active_id].present?
  end

  # Only allow a list of trusted parameters through.
  def capacitacionevaluacion_params
    params.require(:capacitacionevaluacion).permit!
  end
end
