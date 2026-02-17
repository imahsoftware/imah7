class TareasactdocsController < ApplicationController
  before_action :set_tareasactdoc, only: [:show, :edit, :update, :destroy]

  def create
    @tareasactividad = Tareasactividad.find(params[:tareasactividad_id])
    @tareasactdoc = Tareasactdoc.new(tareasactdoc_params)
    @tareasactdoc.tareasactividad_id = params[:tareasactividad_id]
    @tareasactdoc.user_id = is_admin
    respond_to do |format|
      if @tareasactdoc.save
        flash[:notice] = "Se creo con Exito!!!"
        format.js
      else
        render 'layouts/errors', locals: { object: @tareasactdoc }
        format.js
      end
    end
  end


  def eliminar
    @tareasactividad = Tareasactividad.find(params[:tareasactividad_id])
    @tareasactdoc = Tareasactdoc.find(params[:id])
    @tareasactdoc.destroy
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tareasactdoc
      @tareasactdoc = Tareasactdoc.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tareasactdoc_params
      params.require(:tareasactdoc).permit(:descripcion, :documento_tarea, :tareasactividad_id)
    end
end
