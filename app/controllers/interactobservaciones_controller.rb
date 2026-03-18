# app/controllers/interactobservaciones_controller.rb
class InteractobservacionesController < ApplicationController
  layout 'application_interventorias'

  # ── CREATE ────────────────────────────────────────────────────────────────
  def create
    @interactividad      = Interactividad.find(params[:interactividad_id])
    @interventoria       = @interactividad.interventoria
    @interactobservacion = @interactividad.interactobservaciones.build(interactobservacion_params)
    @interactobservacion.user_id = is_admin

    respond_to do |format|
      if @interactobservacion.save
        flash[:notice] = "Observación registrada correctamente."
        format.js
        format.html { redirect_to edit_interventoria_path(@interventoria, etapa: '21') }
      else
        format.js { render 'layouts/errors', locals: { object: @interactobservacion } }
      end
    end
  end

  # ── DESTROY ───────────────────────────────────────────────────────────────
  def destroy
    @interactobservacion = Interactobservacion.find(params[:id])
    @interactividad      = @interactobservacion.interactividad
    @interactobservacion.destroy
    respond_to do |format|
      flash[:success] = "Observación eliminada."
      format.js
      format.html { redirect_to edit_interventoria_path(@interactividad.interventoria, etapa: '21') }
    end
  end

  private

  def interactobservacion_params
    params.require(:interactobservacion).permit(:observaciones)
  end
end
