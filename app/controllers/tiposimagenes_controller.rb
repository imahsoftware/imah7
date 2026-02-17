class TiposimagenesController < ApplicationController
  before_action :set_tiposimagen, only: [:show, :edit, :update, :destroy]

  #before_action :checkaccess, only: [:index, :edit], if: :user_signed_in?

  def checkaccess
    return is_permit('tiposimagenes')
  end

  def index
    @q = Tiposimagen.ransack(params[:q])
    @tiposimagenes = @q.result.paginate(:page => params[:page], :per_page => 50)
    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Tiposimagen.find(params[:active_id]) if params[:active_id].present?
    @tiposimagen = Tiposimagen.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Tiposimagen.find(params[:active_id]) if params[:active_id].present?
    @tiposimagen = Tiposimagen.find(params[:id])
    respond_to { |format| format.js }
  end

  def create
    @tiposimagen = Tiposimagen.new(tiposimagen_params)
    respond_to do |format|
      if @tiposimagen.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @tiposimagen } }
      end
    end
  end

  def update
    respond_to do |format|
      if @tiposimagen.update(tiposimagen_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @tiposimagen } }
      end
    end
  end

  def destroy
    @tiposimagen.destroy
    flash['success'] = 'Eliminado con Exito'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_tiposimagen
    @tiposimagen = Tiposimagen.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tiposimagen_params
    params.require(:tiposimagen).permit!
  end
end