class PortafoliospersonasController < ApplicationController
  before_action :set_portafoliospersona, only: [:show, :destroy]

  def index
    @portafoliospersonas = Portafoliospersona.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Portafoliospersona.find(params[:active_id]) if params[:active_id].present?
    @portafolio = Portafolio.find(params[:portafolio_id])
    @portafoliospersona = Portafoliospersona.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Portafoliospersona.find(params[:active_id]) if params[:active_id].present?
    @portafoliospersona = Portafoliospersona.find(params[:id])
    @portafolio = @portafoliospersona.portafolio
    respond_to { |format| format.js }
  end

  def create
    @portafolio  = Portafolio.find(params[:portafolio_id])
    @portafoliospersona = Portafoliospersona.new(portafoliospersona_params)
    @portafoliospersona.portafolio_id = @portafolio.id
    @portafoliospersona.user_id = is_admin
    respond_to do |format|
      if @portafoliospersona.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @portafoliospersona } }
      end
    end
  end

  def update
    @portafoliospersona = Portafoliospersona.find(params[:id])
    @portafolio = @portafoliospersona.portafolio
    respond_to do |format|
      if @portafoliospersona.update(portafoliospersona_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @portafoliospersona } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @portafoliospersona.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_portafoliospersona
    @portafolio = Portafolio.find(params[:portafolio_id])
    @portafoliospersona = Portafoliospersona.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def portafoliospersona_params
    params.require(:portafoliospersona).permit!
  end
end
