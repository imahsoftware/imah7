class EncuestapreguntasController < ApplicationController
  before_action :set_encuestapreguntas, only: %i[ show edit update destroy new create ]
  before_action :set_active, only: %i[ edit new ]

  def index
    @encuesta = Encuesta.find(current_encuesta)
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @encuestapregunta = Encuestapregunta.new
    respond_to { |format| format.js }
  end

  def edit
    @encuesta = @encuestapregunta.encuesta
    respond_to { |format| format.js }
  end

  def create
    @encuestapregunta = Encuestapregunta.new(encuestapregunta_params)
    @encuestapregunta.encuesta_id = @encuesta.id
    respond_to do |format|
      if @encuestapregunta.save
        flash[:notice] = "Se creo con Exito!!!"
        format.js { render inline: "location.reload();" }
      else
        render 'layouts/errors', locals: { object: @encuestapregunta }
        format.js
      end
    end
  end

  def update
    @encuesta = @encuestapregunta.encuesta
    respond_to do |format|
      if @encuestapregunta.update(encuestapregunta_params)
        flash[:notice] = "Se actualizo con Exito!!!"
        format.js { render inline: "location.reload();" }
      else
        render 'layouts/errors', locals: { object: @encuestapregunta }
        format.js
      end
    end
  end

  def destroy
    @encuestapregunta.destroy
    flash['success'] = "Eliminado con Exito!!!"
  end

  def cancelar; end

  private

  def set_encuestapreguntas
    @encuesta = Encuesta.find(params[:encuesta_id])
    @encuestapregunta = Encuestapregunta.find(params[:id]) if params[:id]
  end

  def set_active
    @active_record = Encuestapregunta.find(params[:active_id]) if params[:active_id].present?
  end

  # Only allow a list of trusted parameters through.
  def encuestapregunta_params
    params.require(:encuestapregunta).permit!
  end
end
