class EproveedoresrecibosController < ApplicationController
  before_action :set_eproveedoresrecibo, only: [:show, :destroy]

  def index
    @eproveedoresrecibos = Eproveedoresrecibo.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Eproveedoresrecibo.find(params[:active_id]) if params[:active_id].present?
    @eproveedor = Eproveedor.find(params[:eproveedor_id])
    @eproveedoresrecibo = Eproveedoresrecibo.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Eproveedoresrecibo.find(params[:active_id]) if params[:active_id].present?
    @eproveedoresrecibo = Eproveedoresrecibo.find(params[:id])
    @eproveedor = @eproveedoresrecibo.eproveedor
    respond_to { |format| format.js }
  end

  def create
    @eproveedor  = Eproveedor.find(params[:eproveedor_id])
    @eproveedoresrecibo = Eproveedoresrecibo.new(eproveedoresrecibo_params)
    @eproveedoresrecibo.eproveedor_id = @eproveedor.id
    @eproveedoresrecibo.user_id = is_admin
    respond_to do |format|
      if @eproveedoresrecibo.save
        #ActiveRecord::Base.connection.execute("CALL prc_eproveedores(#{@eproveedoresrecibo.eproveedorescompra_id})")
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @eproveedoresrecibo } }
      end
    end
  end

  def update
    @eproveedoresrecibo = Eproveedoresrecibo.find(params[:id])
    @eproveedoresrecibo.user_act = is_admin
    @eproveedor = @eproveedoresrecibo.eproveedor
    respond_to do |format|
      if @eproveedoresrecibo.update(eproveedoresrecibo_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @eproveedoresrecibo } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    idEpr = @eproveedoresrecibo.eproveedorescompra_id
    @eproveedoresrecibo.destroy
    #ActiveRecord::Base.connection.execute("CALL prc_eproveedores(#{idEpr})")
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_eproveedoresrecibo
    @eproveedor = Eproveedor.find(params[:eproveedor_id])
    @eproveedoresrecibo = Eproveedoresrecibo.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def eproveedoresrecibo_params
    params.require(:eproveedoresrecibo).permit!
  end
end
