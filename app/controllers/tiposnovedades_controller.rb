class TiposnovedadesController < ApplicationController
  before_action :set_tiposnovedad, only: [:show, :edit, :update, :destroy]

  #before_action :checkaccess, only: [:index, :edit], if: :user_signed_in?

  def checkaccess
    return is_permit('tiposnovedades')
  end

  def index
    @q = Tiposnovedad.ransack(params[:q])
    @tiposnovedades = @q.result.paginate(:page => params[:page], :per_page => 50)
    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Tiposnovedad.find(params[:active_id]) if params[:active_id].present?
    @tiposnovedad = Tiposnovedad.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Tiposnovedad.find(params[:active_id]) if params[:active_id].present?
    @tiposnovedad = Tiposnovedad.find(params[:id])
    respond_to { |format| format.js }
  end

  def create
    @tiposnovedad = Tiposnovedad.new(tiposnovedad_params)
    respond_to do |format|
      if @tiposnovedad.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @tiposnovedad } }
      end
    end
  end

  def update
    respond_to do |format|
      if @tiposnovedad.update(tiposnovedad_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @tiposnovedad } }
      end
    end
  end

  def destroy
    @tiposnovedad.destroy
    flash['success'] = 'Eliminado con Exito'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_tiposnovedad
    @tiposnovedad = Tiposnovedad.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tiposnovedad_params
    params.require(:tiposnovedad).permit!
  end
end