class TareasactividadesController < ApplicationController
  before_action :set_tareasactividades, only: %i[ show edit update destroy new create ]
  before_action :set_active, only: %i[ edit new ]

  def index
    @tarea = Tarea.find(current_tarea)
  end

  def clonar
    @tareasactividad = Tareasactividad.find(params[:id])
  end

  def search
    actividad = params[:actividad] rescue nil
    @tarea = params[:tarea_id] rescue nil
    @tareasactividades = Tareasactividad.where("tarea_id = ? AND UPPER(descripcion) LIKE ?", @tarea, "%#{actividad.upcase}%")
  end

  def update_observation
    @tareasactividad = Tareasactividad.find(params[:id])
    if @tareasactividad.update(observacion: params[:observacion].to_s.upcase)
      render json: { status: 'success', message: 'Observación actualizada correctamente' }
    else
      render json: { status: 'error', message: 'Error al actualizar la observación' }
    end
  end

  def show
    respond_to { |format| format.js }
  end

  def finalizar
    @iparametro = User.find(params[:user_persona])
    @tareasactividad = Tareasactividad.find(params[:id])
    @tareasactividad.estado = params[:estado]
    @tareasactividad.save(validate: false)
  end

  def new
    @tareasactividad = Tareasactividad.new
    respond_to { |format| format.js }
  end

  def edit
    @tarea = @tareasactividad.tarea
    respond_to { |format| format.js }
  end

  def create
    @tareasactividad = Tareasactividad.new(tareasactividad_params)
    @tareasactividad.tarea_id = @tarea.id
    @tareasactividad.user_id = is_admin
    respond_to do |format|
      if @tareasactividad.save
        ActiveRecord::Base.connection.execute("CALL prc_duplicar_tarea(#{@tarea.id},'R')")
        flash[:notice] = "Se creo con Exito!!!"
        format.js { render inline: "location.reload();" }
      else
        render 'layouts/errors', locals: { object: @tareasactividad }
        format.js
      end
    end
  end

  def update
    @tarea = @tareasactividad.tarea
    respond_to do |format|
      if @tareasactividad.update(tareasactividad_params)
        ActiveRecord::Base.connection.execute("CALL prc_duplicar_tarea(#{@tarea.id},'R')")
        flash[:notice] = "Se actualizo con Exito!!!"
        format.js { render inline: "location.reload();" }
      else
        render 'layouts/errors', locals: { object: @tareasactividad }
        format.js
      end
    end
  end

  def destroy
    @tareasactividad.destroy
    flash['success'] = "Eliminado con Exito!!!"
  end

  def cancelar; end

  private

  def set_tareasactividades
    @tarea = Tarea.find(params[:tarea_id])
    @tareasactividad = Tareasactividad.find(params[:id]) if params[:id]
  end

  def set_active
    @active_record = Tareasactividad.find(params[:active_id]) if params[:active_id].present?
  end

  # Only allow a list of trusted parameters through.
  def tareasactividad_params
    params.require(:tareasactividad).permit!
  end
end
