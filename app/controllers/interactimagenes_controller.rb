# app/controllers/interactimagenes_controller.rb
class InteractimagenesController < ApplicationController
  before_action :find_interactividad_and_interactimagen
  layout 'application_interventorias'

  # ── CREATE ────────────────────────────────────────────────────────────────
  def create
    @interventoria  = @interactividad.interventoria
    @interactimagen = @interactividad.interactimagenes.build(interactimagen_params)
    @interactimagen.user_id = is_admin

    respond_to do |format|
      if @interactimagen.save
        flash[:notice] = "Soporte cargado correctamente."
        format.js
        format.html { redirect_to edit_interventoria_path(@interactividad.interventoria, etapa: '21') }
      else
        format.js { render 'layouts/errors', locals: { object: @interactimagen } }
      end
    end
  end

  # ── DESTROY ───────────────────────────────────────────────────────────────
  def destroy
    @interventoria = @interactividad.interventoria
    @interactimagen.destroy
    respond_to do |format|
      flash[:notice] = "Documento eliminado."
      format.js
      format.html { redirect_to edit_interventoria_path(@interventoria, etapa: '21') }
    end
  end

  private

  def find_interactividad_and_interactimagen
    @interactividad = Interactividad.find(params[:interactividad_id])
    @interactimagen = Interactimagen.find(params[:id]) if params[:id]
  end

  def interactimagen_params
    params.require(:interactimagen).permit!
  end
end
