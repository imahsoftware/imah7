class CentroscostosController < ApplicationController
  before_action :set_centroscosto, only: [:show, :edit, :update, :destroy]

  #before_action :checkaccess, only: [:index, :edit], if: :user_signed_in?

  def checkaccess
    return is_permit('centroscostos')
  end

  def index
    @q = Centroscosto.ransack(params[:q])
    @centroscostos = @q.result.paginate(:page => params[:page], :per_page => 50)
    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Centroscosto.find(params[:active_id]) if params[:active_id].present?
    @centroscosto = Centroscosto.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Centroscosto.find(params[:active_id]) if params[:active_id].present?
    @centroscosto = Centroscosto.find(params[:id])
    respond_to { |format| format.js }
  end

  def create
    @centroscosto = Centroscosto.new(centroscosto_params)
    respond_to do |format|
      if @centroscosto.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @centroscosto } }
      end
    end
  end

  def update
    respond_to do |format|
      if @centroscosto.update(centroscosto_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @centroscosto } }
      end
    end
  end

  def destroy
    @centroscosto.destroy
    flash['success'] = 'Eliminado con Exito'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_centroscosto
    @centroscosto = Centroscosto.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def centroscosto_params
    params.require(:centroscosto).permit!
  end
end
