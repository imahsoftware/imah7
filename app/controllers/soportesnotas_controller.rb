class SoportesnotasController < ApplicationController
  before_action :set_soportesnota, only: [:show, :destroy]

  def index
    @soportesnotas = Soportesnota.all
  end

  def documento
    @soporte = Soporte.find(params[:soporte_id])
    @soportesnota = Soportesnota.find(params[:soportesnota_id])
    @soportesnotasimagen = Soportesnotasimagen.new
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Soportesnota.find(params[:active_id]) if params[:active_id].present?
    @soporte = Soporte.find(params[:soporte_id])
    @soportesnota = Soportesnota.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Soportesnota.find(params[:active_id]) if params[:active_id].present?
    @soportesnota = Soportesnota.find(params[:id])
    @soporte = @soportesnota.soporte
    respond_to { |format| format.js }
  end

  def create
    @soporte  = Soporte.find(params[:soporte_id])
    @soportesnota = Soportesnota.new(soportesnota_params)
    @soportesnota.soporte_id = @soporte.id
    @soportesnota.user_id = is_admin
    respond_to do |format|
      if @soportesnota.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @soportesnota } }
      end
    end
  end

  def update
    @soportesnota = Soportesnota.find(params[:id])
    @soporte = @soportesnota.soporte
    respond_to do |format|
      if @soportesnota.update(soportesnota_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @soportesnota } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @soportesnota.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_soportesnota
    @soporte = Soporte.find(params[:soporte_id])
    @soportesnota = Soportesnota.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def soportesnota_params
    params.require(:soportesnota).permit!
  end
end
