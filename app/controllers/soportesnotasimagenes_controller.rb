class SoportesnotasimagenesController < ApplicationController
  before_action :set_soportesnotasimagen, only: [:show, :destroy]

  def index
    @soportesnotasimagenes = Soportesnotasimagen.all
  end

  def documento
    @soportesnota = Soportesnota.find(params[:soportesnota_id])
    @soportesnotasimagen = Soportesnotasimagen.find(params[:soportesnotasimagen_id])
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Soportesnotasimagen.find(params[:active_id]) if params[:active_id].present?
    @soportesnota = Soportesnota.find(params[:soportesnota_id])
    @soportesnotasimagen = Soportesnotasimagen.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Soportesnotasimagen.find(params[:active_id]) if params[:active_id].present?
    @soportesnotasimagen = Soportesnotasimagen.find(params[:id])
    @soporte = @soportesnotasimagen.soporte
    respond_to { |format| format.js }
  end

  def create
    @soportesnota = Soportesnota.find(params[:soportesnota_id])
    @soportesnotasimagen = Soportesnotasimagen.new(soportesnotasimagen_params)
    @soportesnotasimagen.soportesnota_id = @soportesnota.id
    @soportesnotasimagen.user_id = is_admin
    respond_to do |format|
      if @soportesnotasimagen.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @soportesnotasimagen } }
      end
    end
  end

  def update
    @soportesnotasimagen = Soportesnotasimagen.find(params[:id])
    @soportesnota = @soportesnotasimagen.soportesnota
    respond_to do |format|
      if @soportesnotasimagen.update(soportesnotasimagen_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @soportesnotasimagen } }
      end
    end
  end

  def destroy
    @soportesnotasimagen.destroy
    respond_to do |format|
      flash['success'] = 'Eliminado correctamente'
      format.js { render inline: "location.reload();" }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_soportesnotasimagen
    @soportesnota = Soportesnota.find(params[:soportesnota_id])
    @soportesnotasimagen = Soportesnotasimagen.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def soportesnotasimagen_params
    params.require(:soportesnotasimagen).permit!
  end
end
