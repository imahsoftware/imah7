class TareasdocsController < ApplicationController
  before_action :set_tareasdocs, only: %i[ show edit update destroy new create ]
  before_action :set_active, only: %i[ edit new ]

  def index
    @tarea = Tarea.find(current_tarea)
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @tareasdoc = Tareasdoc.new
    respond_to { |format| format.js }
  end

  def edit
    @tarea = @tareasdoc.tarea
    respond_to { |format| format.js }
  end

  def create
    @tareasdoc = Tareasdoc.new(tareasdoc_params)
    @tareasdoc.tarea_id = @tarea.id
    @tareasdoc.user_id = is_admin
    respond_to do |format|
      if @tareasdoc.save
        flash[:notice] = "Se creo con Exito!!!"
        format.js { render inline: "location.reload();" }
      else
        render 'layouts/errors', locals: { object: @tareasdoc }
        format.js
      end
    end
  end

  def update
    @tarea = @tareasdoc.tarea
    respond_to do |format|
      if @tareasdoc.update(tareasdoc_params)
        flash[:notice] = "Se actualizo con Exito!!!"
        format.js { render inline: "location.reload();" }
      else
        render 'layouts/errors', locals: { object: @tareasdoc }
        format.js
      end
    end
  end

  def destroy
    @tareasdoc.destroy
    flash['success'] = "Eliminado con Exito!!!"
  end

  def cancelar; end

  private

  def set_tareasdocs
    @tarea = Tarea.find(params[:tarea_id])
    @tareasdoc = Tareasdoc.find(params[:id]) if params[:id]
  end

  def set_active
    @active_record = Tareasdoc.find(params[:active_id]) if params[:active_id].present?
  end

  # Only allow a list of trusted parameters through.
  def tareasdoc_params
    params.require(:tareasdoc).permit!
  end
end
