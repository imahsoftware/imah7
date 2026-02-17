class TipospretencionesController < ApplicationController
  before_action :set_tipospretencion, only: [:show, :edit, :update, :destroy]

  #before_action :checkaccess, only: [:index, :edit], if: :user_signed_in?

  def checkaccess
    return is_permit('tipospretencions')
  end

  def index
    @q = Tipospretencion.ransack(params[:q])
    @tipospretenciones = @q.result.paginate(:page => params[:page], :per_page => 50)
    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Tipospretencion.find(params[:active_id]) if params[:active_id].present?
    @tipospretencion = Tipospretencion.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Tipospretencion.find(params[:active_id]) if params[:active_id].present?
    @tipospretencion = Tipospretencion.find(params[:id])
    respond_to { |format| format.js }
  end

  def create
    @tipospretencion = Tipospretencion.new(tipospretencion_params)
    respond_to do |format|
      if @tipospretencion.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @tipospretencion } }
      end
    end
  end

  def update
    respond_to do |format|
      if @tipospretencion.update(tipospretencion_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @tipospretencion } }
      end
    end
  end

  def destroy
    @tipospretencion.destroy
    flash['success'] = 'Eliminado con Exito'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_tipospretencion
    @tipospretencion = Tipospretencion.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tipospretencion_params
    params.require(:tipospretencion).permit!
  end
end
