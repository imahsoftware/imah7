class ParcargosdocsController < ApplicationController
  before_action :set_parcargosdocs, only: %i[ show edit update destroy new create ]
  before_action :set_active, only: %i[ edit new ]

  def index
    @parcargo = Parcargo.find(current_parcargo)
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @parcargosdoc = Parcargosdoc.new
    respond_to { |format| format.js }
  end

  def edit
    @parcargo = @parcargosdoc.parcargo
    respond_to { |format| format.js }
  end

  def create
    @parcargosdoc = Parcargosdoc.new(parcargosdoc_params)
    @parcargosdoc.user_id = current_user.id
    @parcargosdoc.parcargo_id = @parcargo.id
    respond_to do |format|
      if @parcargosdoc.save
        flash[:notice] = "Se creo con Exito!!!"
        format.js
      else
        render 'layouts/errors', locals: { object: @parcargosdoc }
        format.js
      end
    end
  end

  def update
    @parcargo = @parcargosdoc.parcargo
    respond_to do |format|
      if @parcargosdoc.update(parcargosdoc_params)
        flash[:notice] = "Se actualizo con Exito!!!"
        format.js
      else
        render 'layouts/errors', locals: { object: @parcargosdoc }
        format.js
      end
    end
  end

  def destroy
    @parcargosdoc.destroy
    flash['success'] = "Eliminado con Exito!!!"
  end

  def cancelar; end

  private

  def set_parcargosdocs
    @parcargo = Parcargo.find(params[:parcargo_id])
    @parcargosdoc = Parcargosdoc.find(params[:id]) if params[:id]
  end

  def set_active
    @active_record = Parcargosdoc.find(params[:active_id]) if params[:active_id].present?
  end

  # Only allow a list of trusted parameters through.
  def parcargosdoc_params
    params.require(:parcargosdoc).permit!
  end
end
