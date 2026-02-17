class CuentasController < ApplicationController
  before_action :set_cuenta, only: [:show, :edit, :update, :destroy]

  #before_action :checkaccess, only: [:index, :edit], if: :user_signed_in?

  def checkaccess
    return is_permit('cuentas')
  end

  def index
    @q = Cuenta.ransack(params[:q])
    @cuentas = @q.result.paginate(:page => params[:page], :per_page => 50)
    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Cuenta.find(params[:active_id]) if params[:active_id].present?
    @cuenta = Cuenta.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Cuenta.find(params[:active_id]) if params[:active_id].present?
    @cuenta = Cuenta.find(params[:id])
    respond_to { |format| format.js }
  end

  def create
    @cuenta = Cuenta.new(cuenta_params)
    respond_to do |format|
      if @cuenta.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @cuenta } }
      end
    end
  end

  def update
    respond_to do |format|
      if @cuenta.update(cuenta_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @cuenta } }
      end
    end
  end

  def destroy
    @cuenta.destroy
    flash['success'] = 'Eliminado con Exito'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_cuenta
    @cuenta = Cuenta.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def cuenta_params
    params.require(:cuenta).permit!
  end
end
