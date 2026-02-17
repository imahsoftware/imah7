class ContratossoleppsbitacorasController < ApplicationController
  before_action :set_contratossoleppsbitacora, only: [:show, :destroy]

  def index
    @contratossoleppsbitacoras = Contratossoleppsbitacora.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratossoleppsbitacora.find(params[:active_id]) if params[:active_id].present?
    @contratossolepp = Contratossolepp.find(params[:contratossolepp_id])
    @contratossoleppsbitacora = Contratossoleppsbitacora.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratossoleppsbitacora.find(params[:active_id]) if params[:active_id].present?
    @contratossoleppsbitacora = Contratossoleppsbitacora.find(params[:id])
    @contratossolepp = @contratossoleppsbitacora.contratossolepp
    respond_to { |format| format.js }
  end

  def create
    @contratossolepp  = Contratossolepp.find(params[:contratossolepp_id])
    @contratossoleppsbitacora = Contratossoleppsbitacora.new(contratossoleppsbitacora_params)
    @contratossoleppsbitacora.contratossolepp_id = @contratossolepp.id
    respond_to do |format|
      if @contratossoleppsbitacora.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratossoleppsbitacora } }
      end
    end
  end

  def update
    @contratossoleppsbitacora = Contratossoleppsbitacora.find(params[:id])
    @contratossolepp = @contratossoleppsbitacora.contratossolepp
    respond_to do |format|
      if @contratossoleppsbitacora.update(contratossoleppsbitacora_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratossoleppsbitacora } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratossoleppsbitacora.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratossoleppsbitacora
    @contratossolepp = Contratossolepp.find(params[:contratossolepp_id])
    @contratossoleppsbitacora = Contratossoleppsbitacora.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratossoleppsbitacora_params
    params.require(:contratossoleppsbitacora).permit!
  end
end
