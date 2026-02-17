class CapacitacionevaopcionesController < ApplicationController
  before_action :set_capacitacionevaopcion, only: [:update]

  def new
    @capacitacionevaluacion = Capacitacionevaluacion.find(params[:capacitacionevaluacion_id])
    @capacitacionevaopcion = Capacitacionevaopcion.new
  end

  def create
    @capacitacionevaluacion = Capacitacionevaluacion.find(params[:capacitacionevaluacion_id])
    @capacitacionevaopcion = Capacitacionevaopcion.new(capacitacionevaopcion_params)
    @capacitacionevaopcion.capacitacionevaluacion_id = @capacitacionevaluacion.id
    respond_to do |format|
      if @capacitacionevaopcion.save
        flash['success'] = "Documento cargado con exito"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @capacitacionevaopcion } }
      end
    end
  end

  def update
    respond_to do |format|
      if @capacitacionevaopcion.update(capacitacionevaopcion_params)
        format.html { redirect_to @capacitacionevaopcion, notice: 'Capacitacionevaopcion was successfully updated.' }
        format.json { render :show, status: :ok, location: @capacitacionevaopcion }
      else
        format.html { render :edit }
        format.json { render json: @capacitacionevaopcion.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @capacitacionevaluacion = Capacitacionevaluacion.find(params[:capacitacionevaluacion_id])
    @capacitacionevaopcion = Capacitacionevaopcion.find(params[:id])
    @capacitacionevaopcion.destroy
    respond_to do |format|
      format.html { redirect_to edit_capacitacion_path(id: @capacitacionevaluacion.capacitacion_id, subetapa: '2'), notice: 'Se ha eliminado con exito!!!' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_capacitacionevaopcion
    @capacitacionevaopcion = Capacitacionevaopcion.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def capacitacionevaopcion_params
    params.require(:capacitacionevaopcion).permit!
  end
end
