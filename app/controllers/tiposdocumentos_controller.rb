class TiposdocumentosController < ApplicationController
  before_action :set_tiposdocumento, only: [:show, :edit, :update, :destroy]

  #before_action :checkaccess, only: [:index, :edit], if: :user_signed_in?

  def checkaccess
    return is_permit('tiposdocumentos')
  end

  def index
    @q = Tiposdocumento.ransack(params[:q])
    @tiposdocumentos = @q.result.paginate(:page => params[:page], :per_page => 50)
    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Tiposdocumento.find(params[:active_id]) if params[:active_id].present?
    @tiposdocumento = Tiposdocumento.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Tiposdocumento.find(params[:active_id]) if params[:active_id].present?
    @tiposdocumento = Tiposdocumento.find(params[:id])
    respond_to { |format| format.js }
  end

  def create
    @tiposdocumento = Tiposdocumento.new(tiposdocumento_params)
    respond_to do |format|
      if @tiposdocumento.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @tiposdocumento } }
      end
    end
  end

  def update
    respond_to do |format|
      if @tiposdocumento.update(tiposdocumento_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @tiposdocumento } }
      end
    end
  end

  def destroy
    @tiposdocumento.destroy
    flash['success'] = 'Eliminado con Exito'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_tiposdocumento
    @tiposdocumento = Tiposdocumento.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tiposdocumento_params
    params.require(:tiposdocumento).permit!
  end
end