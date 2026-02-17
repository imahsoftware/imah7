class EproveedorestemegresosController < ApplicationController
  before_action :set_eproveedorestemegreso, only: [:show, :destroy]

  def index
    @eproveedorestemegresos = Eproveedorestemegreso.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Eproveedorestemegreso.find(params[:active_id]) if params[:active_id].present?
    @eproveedor = Eproveedor.find(params[:eproveedor_id])
    @eproveedorestemegreso = Eproveedorestemegreso.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Eproveedorestemegreso.find(params[:active_id]) if params[:active_id].present?
    @eproveedorestemegreso = Eproveedorestemegreso.find(params[:id])
    @eproveedor = @eproveedorestemegreso.eproveedor
    respond_to { |format| format.js }
  end

  def create
    @eproveedor  = Eproveedor.find(params[:eproveedor_id])
    @eproveedorestemegreso = Eproveedorestemegreso.new(eproveedorestemegreso_params)
    @eproveedorestemegreso.eproveedor_id = @eproveedor.id
    @eproveedorestemegreso.user_id = is_admin
    respond_to do |format|
      if @eproveedorestemegreso.save
        #ActiveRecord::Base.connection.execute("CALL prc_eproveedores(#{@eproveedorestemegreso.eproveedoresegreso_id})")
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @eproveedorestemegreso } }
      end
    end
  end

  def update
    @eproveedorestemegreso = Eproveedorestemegreso.find(params[:id])
    @eproveedorestemegreso.user_act = is_admin
    @eproveedor = @eproveedorestemegreso.eproveedor
    respond_to do |format|
      if @eproveedorestemegreso.update(eproveedorestemegreso_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @eproveedorestemegreso } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @eproveedorestemegreso.destroy
    #ActiveRecord::Base.connection.execute("CALL prc_eproveedores(#{idEpr})")
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_eproveedorestemegreso
    @eproveedor = Eproveedor.find(params[:eproveedor_id])
    @eproveedorestemegreso = Eproveedorestemegreso.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def eproveedorestemegreso_params
    params.require(:eproveedorestemegreso).permit!
  end
end
