class EncuestapreopcionesController < ApplicationController
  before_action :set_encuestapreopcion, only: [:update]

  def new
    @encuestapregunta = Encuestapregunta.find(params[:encuestapregunta_id])
    @encuestapreopcion = Encuestapreopcion.new
  end

  def create
    @encuestapregunta = Encuestapregunta.find(params[:encuestapregunta_id])
    @encuestapreopcion = Encuestapreopcion.new(encuestapreopcion_params)
    @encuestapreopcion.encuestapregunta_id = @encuestapregunta.id
    respond_to do |format|
      if @encuestapreopcion.save
        flash['success'] = "Documento cargado con exito"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @encuestapreopcion } }
      end
    end
  end

  def update
    respond_to do |format|
      if @encuestapreopcion.update(encuestapreopcion_params)
        format.html { redirect_to @encuestapreopcion, notice: 'Encuestapreopcion was successfully updated.' }
        format.json { render :show, status: :ok, location: @encuestapreopcion }
      else
        format.html { render :edit }
        format.json { render json: @encuestapreopcion.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @encuestapregunta = Encuestapregunta.find(params[:encuestapregunta_id])
    @encuestapreopcion = Encuestapreopcion.find(params[:id])
    @encuestapreopcion.destroy
    respond_to do |format|
      format.html { redirect_to edit_encuesta_path(id: @encuestapregunta.encuesta_id), notice: 'Se ha eliminado con exito!!!' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_encuestapreopcion
    @encuestapreopcion = Encuestapreopcion.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def encuestapreopcion_params
    params.require(:encuestapreopcion).permit!
  end
end
