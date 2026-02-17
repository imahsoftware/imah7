class ContratosperrodamientosController < ApplicationController
  before_action :set_contratosperrodamiento, only: [:show, :destroy]

  def index
    @contratosperrodamientos = Contratosperrodamiento.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosperrodamiento.find(params[:active_id]) if params[:active_id].present?
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratosperrodamiento = Contratosperrodamiento.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosperrodamiento.find(params[:active_id]) if params[:active_id].present?
    @contratosperrodamiento = Contratosperrodamiento.find(params[:id])
    @contratospersona = @contratosperrodamiento.contratospersona
    respond_to { |format| format.js }
  end

  def create
    @contratospersona  = Contratospersona.find(params[:contratospersona_id])
    @contratosperrodamiento = Contratosperrodamiento.new(contratosperrodamiento_params)
    @contratosperrodamiento.contratospersona_id = @contratospersona.id
    @contratosperrodamiento.user_id = is_admin
    respond_to do |format|
      if @contratosperrodamiento.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperrodamiento } }
      end
    end
  end

  def update
    @contratosperrodamiento = Contratosperrodamiento.find(params[:id])
    @contratospersona = @contratosperrodamiento.contratospersona
    respond_to do |format|
      if @contratosperrodamiento.update(contratosperrodamiento_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperrodamiento } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosperrodamiento.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosperrodamiento
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratosperrodamiento = Contratosperrodamiento.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosperrodamiento_params
    params.require(:contratosperrodamiento).permit!
  end
end
