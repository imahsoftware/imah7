class EproveedorescreditosController < ApplicationController
  before_action :set_eproveedorescredito, only: [:show, :destroy]

  def ver
    @eproveedorescredito = Eproveedorescredito.find(params[:id])
    fname = "NotaCredito_"+@eproveedorescredito.id.to_s rescue nil
    respond_to do |format|
      format.pdf {render pdf: "#{fname}", template: "eproveedorescreditos/ver", encoding: "UTF-8", page_size: 'Letter',:margin => {top: 15, :bottom => 20, :left => 15,:right => 15}}
    end
  end

  def index
    @eproveedorescreditos = Eproveedorescredito.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Eproveedorescredito.find(params[:active_id]) if params[:active_id].present?
    @eproveedor = Eproveedor.find(params[:eproveedor_id])
    @eproveedorescredito = Eproveedorescredito.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Eproveedorescredito.find(params[:active_id]) if params[:active_id].present?
    @eproveedorescredito = Eproveedorescredito.find(params[:id])
    @eproveedor = @eproveedorescredito.eproveedor
    respond_to { |format| format.js }
  end

  def create
    @eproveedor  = Eproveedor.find(params[:eproveedor_id])
    @eproveedorescredito = Eproveedorescredito.new(eproveedorescredito_params)
    @eproveedorescredito.eproveedor_id = @eproveedor.id
    @eproveedorescredito.user_id = is_admin
    respond_to do |format|
      if @eproveedorescredito.save
        ActiveRecord::Base.connection.execute("CALL prc_eproveedores(#{@eproveedorescredito.eproveedorescompra_id})")
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @eproveedorescredito } }
      end
    end
  end

  def update
    @eproveedorescredito = Eproveedorescredito.find(params[:id])
    @eproveedorescredito.user_act = is_admin
    @eproveedor = @eproveedorescredito.eproveedor
    respond_to do |format|
      if @eproveedorescredito.update(eproveedorescredito_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @eproveedorescredito } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    idEpr = @eproveedorescredito.eproveedorescompra_id
    @eproveedorescredito.destroy
    ActiveRecord::Base.connection.execute("CALL prc_eproveedores(#{idEpr})")
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_eproveedorescredito
    @eproveedor = Eproveedor.find(params[:eproveedor_id])
    @eproveedorescredito = Eproveedorescredito.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def eproveedorescredito_params
    params.require(:eproveedorescredito).permit!
  end
end
