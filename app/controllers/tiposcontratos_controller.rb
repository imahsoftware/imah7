class TiposcontratosController < ApplicationController
  before_action :set_tiposcontrato, only: [:show, :edit, :update, :destroy]

  #before_action :checkaccess, only: [:index, :edit], if: :user_signed_in?

  def checkaccess
    return is_permit('tiposcontratos')
  end

  def index
    @q = Tiposcontrato.ransack(params[:q])
    @tiposcontratos = @q.result.paginate(:page => params[:page], :per_page => 50)
    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Tiposcontrato.find(params[:active_id]) if params[:active_id].present?
    @tiposcontrato = Tiposcontrato.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Tiposcontrato.find(params[:active_id]) if params[:active_id].present?
    @tiposcontrato = Tiposcontrato.find(params[:id])
    respond_to { |format| format.js }
  end

  def create
    @tiposcontrato = Tiposcontrato.new(tiposcontrato_params)
    respond_to do |format|
      if @tiposcontrato.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @tiposcontrato } }
      end
    end
  end

  def update
    respond_to do |format|
      if @tiposcontrato.update(tiposcontrato_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @tiposcontrato } }
      end
    end
  end

  def destroy
    @tiposcontrato.destroy
    flash['success'] = 'Eliminado con Exito'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_tiposcontrato
    @tiposcontrato = Tiposcontrato.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tiposcontrato_params
    params.require(:tiposcontrato).permit!
  end
end
