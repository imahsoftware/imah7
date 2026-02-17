class TiposentidadesController < ApplicationController
  before_action :set_tiposentidad, only: [:show, :edit, :update, :destroy]

  #before_action :checkaccess, only: [:index, :edit], if: :user_signed_in?

  def checkaccess
    return is_permit('tiposentidades')
  end

  def index
    @tiposentidades = Tiposentidad.order("created_at desc")
    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Tiposentidad.find(params[:active_id]) if params[:active_id].present?
    @tiposentidad = Tiposentidad.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Tiposentidad.find(params[:active_id]) if params[:active_id].present?
    @tiposentidad = Tiposentidad.find(params[:id])
    respond_to { |format| format.js }
  end

  def create
    @tiposentidad = Tiposentidad.new(tiposentidad_params)
    respond_to do |format|
      if @tiposentidad.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @tiposentidad } }
      end
    end
  end

  def update
    respond_to do |format|
      if @tiposentidad.update(tiposentidad_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @tiposentidad } }
      end
    end
  end

  def destroy
    @tiposentidad.destroy
    flash['success'] = 'Eliminado con Exito'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_tiposentidad
    @tiposentidad = Tiposentidad.find(params[:id])
    @is_auth_c_tiposentidad = is_auth_c('tiposentidad')
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tiposentidad_params
    params.require(:tiposentidad).permit!
  end
end