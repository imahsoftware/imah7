class TiposcargosController < ApplicationController
  before_action :set_tiposcargo, only: [:show, :edit, :update, :destroy]

  #before_action :checkaccess, only: [:index, :edit], if: :user_signed_in?

  def checkaccess
    return is_permit('tiposcargos')
  end

  def index
    @q = Tiposcargo.ransack(params[:q])
    @tiposcargos = @q.result.paginate(:page => params[:page], :per_page => 50)
    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Tiposcargo.find(params[:active_id]) if params[:active_id].present?
    @tiposcargo = Tiposcargo.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Tiposcargo.find(params[:active_id]) if params[:active_id].present?
    @tiposcargo = Tiposcargo.find(params[:id])
    respond_to { |format| format.js }
  end

  def create
    @tiposcargo = Tiposcargo.new(tiposcargo_params)
    respond_to do |format|
      if @tiposcargo.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @tiposcargo } }
      end
    end
  end

  def update
    respond_to do |format|
      if @tiposcargo.update(tiposcargo_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @tiposcargo } }
      end
    end
  end

  def destroy
    @tiposcargo.destroy
    flash['success'] = 'Eliminado con Exito'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_tiposcargo
    @tiposcargo = Tiposcargo.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tiposcargo_params
    params.require(:tiposcargo).permit!
  end
end