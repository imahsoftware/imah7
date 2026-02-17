class ContratossolnotasController < ApplicationController
  before_action :set_contratossolnota, only: [:show, :destroy]

  def index
    @contratossolnotas = Contratossolnota.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratossolnota.find(params[:active_id]) if params[:active_id].present?
    @contratossolicitud = Contratossolicitud.find(params[:contratossolicitud_id])
    @contratossolnota = Contratossolnota.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratossolnota.find(params[:active_id]) if params[:active_id].present?
    @contratossolnota = Contratossolnota.find(params[:id])
    @contratossolicitud = @contratossolnota.contratossolicitud
    respond_to { |format| format.js }
  end

  def create
    @contratossolicitud  = Contratossolicitud.find(params[:contratossolicitud_id])
    @contratossolnota = Contratossolnota.new(contratossolnota_params)
    @contratossolnota.contratossolicitud_id = @contratossolicitud.id
    @contratossolnota.user_id = is_admin
    respond_to do |format|
      if @contratossolnota.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratossolnota } }
      end
    end
  end

  def update
    @contratossolnota = Contratossolnota.find(params[:id])
    @contratossolnota.user_act = is_admin
    @contratossolicitud = @contratossolnota.contratossolicitud
    respond_to do |format|
      if @contratossolnota.update(contratossolnota_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratossolnota } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratossolnota.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratossolnota
    @contratossolicitud = Contratossolicitud.find(params[:contratossolicitud_id])
    @contratossolnota = Contratossolnota.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratossolnota_params
    params.require(:contratossolnota).permit!
  end
end
