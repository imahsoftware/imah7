class TiposcuentasController < ApplicationController
  before_action :set_tiposcuenta, only: [:show, :edit, :update, :destroy]

  #before_action :checkaccess, only: [:index, :edit], if: :user_signed_in?

  def checkaccess
    return is_permit('tiposcuentas')
  end

  def index
    @q = Tiposcuenta.ransack(params[:q])
    @tiposcuentas = @q.result.paginate(:page => params[:page], :per_page => 50)
    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Tiposcuenta.find(params[:active_id]) if params[:active_id].present?
    @tiposcuenta = Tiposcuenta.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Tiposcuenta.find(params[:active_id]) if params[:active_id].present?
    @tiposcuenta = Tiposcuenta.find(params[:id])
    respond_to { |format| format.js }
  end

  def create
    @tiposcuenta = Tiposcuenta.new(tiposcuenta_params)
    respond_to do |format|
      if @tiposcuenta.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @tiposcuenta } }
      end
    end
  end

  def update
    respond_to do |format|
      if @tiposcuenta.update(tiposcuenta_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @tiposcuenta } }
      end
    end
  end

  def destroy
    @tiposcuenta.destroy
    flash['success'] = 'Eliminado con Exito'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_tiposcuenta
    @tiposcuenta = Tiposcuenta.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tiposcuenta_params
    params.require(:tiposcuenta).permit!
  end
end