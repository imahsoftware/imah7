class CapacitaciondocsController < ApplicationController
  before_action :set_capacitaciondocs, only: %i[ show edit update destroy new create ]
  before_action :set_active, only: %i[ edit new ]

  def index
    @capacitacion = Capacitacion.find(current_capacitacion)
  end

  def video
    @capacitaciondoc = Capacitaciondoc.find(params[:id])
    if @capacitaciondoc.descripcion.present?
      @video = @capacitaciondoc.descripcion.match(/(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})/)[1]
    end
  end

  def link
    @capacitaciondoc = Capacitaciondoc.find(params[:id])
    if @capacitaciondoc.descripcion.present?
      @link = @capacitaciondoc.descripcion
    end
  end

  def estado
    @capacitaciondoc = Capacitaciondoc.find(params[:id])
    @capacitaciondoc.estado = params[:estado]
    @capacitaciondoc.save(validate: false)
    flash[:notice] = "Se cambio el estado con Exito!!!"
    redirect_to edit_capacitacion_path(id: @capacitaciondoc.capacitacion_id, subetapa: '1')
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @capacitaciondoc = Capacitaciondoc.new
    respond_to { |format| format.js }
  end

  def edit
    @capacitacion = @capacitaciondoc.capacitacion
    respond_to { |format| format.js }
  end

  def create
    @capacitaciondoc = Capacitaciondoc.new(capacitaciondoc_params)
    @capacitaciondoc.capacitacion_id = @capacitacion.id
    @capacitaciondoc.user_id = is_admin
    @capacitaciondoc.estado == 'ACTIVO'
    respond_to do |format|
      if @capacitaciondoc.save
        flash[:notice] = "Se creo con Exito!!!"
        format.js { render inline: "location.reload();" }
      else
        render 'layouts/errors', locals: { object: @capacitaciondoc }
        format.js
      end
    end
  end

  def update
    @capacitacion = @capacitaciondoc.capacitacion
    respond_to do |format|
      if @capacitaciondoc.update(capacitaciondoc_params)
        flash[:notice] = "Se actualizo con Exito!!!"
        format.js { render inline: "location.reload();" }
      else
        render 'layouts/errors', locals: { object: @capacitaciondoc }
        format.js
      end
    end
  end

  def destroy
    @capacitaciondoc.destroy
    flash['success'] = "Eliminado con Exito!!!"
  end

  def cancelar; end

  private

  def set_capacitaciondocs
    @capacitacion = Capacitacion.find(params[:capacitacion_id])
    @capacitaciondoc = Capacitaciondoc.find(params[:id]) if params[:id]
  end

  def set_active
    @active_record = Capacitaciondoc.find(params[:active_id]) if params[:active_id].present?
  end

  # Only allow a list of trusted parameters through.
  def capacitaciondoc_params
    params.require(:capacitaciondoc).permit!
  end
end
