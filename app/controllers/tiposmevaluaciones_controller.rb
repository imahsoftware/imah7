class TiposmevaluacionesController < ApplicationController
  before_action :set_tiposmevaluacion, only: [:show, :edit, :update, :destroy]

  #before_action :checkaccess, only: [:index, :edit], if: :user_signed_in?

  def checkaccess
    return is_permit('tiposmevaluacion')
  end

  def index
    @q = Tiposmevaluacion.ransack(params[:q])
    @tiposmevaluaciones = @q.result.paginate(:page => params[:page], :per_page => 50)
    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Tiposmevaluacion.find(params[:active_id]) if params[:active_id].present?
    @tiposmevaluacion = Tiposmevaluacion.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Tiposmevaluacion.find(params[:active_id]) if params[:active_id].present?
    @tiposmevaluacion = Tiposmevaluacion.find(params[:id])
    respond_to { |format| format.js }
  end

  def create
    @tiposmevaluacion = Tiposmevaluacion.new(tiposmevaluacion_params)
    respond_to do |format|
      if @tiposmevaluacion.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @tiposmevaluacion } }
      end
    end
  end

  def update
    respond_to do |format|
      if @tiposmevaluacion.update(tiposmevaluacion_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @tiposmevaluacion } }
      end
    end
  end

  def destroy
    @tiposmevaluacion.destroy
    flash['success'] = 'Eliminado con Exito'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_tiposmevaluacion
    @tiposmevaluacion = Tiposmevaluacion.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tiposmevaluacion_params
    params.require(:tiposmevaluacion).permit!
  end
end