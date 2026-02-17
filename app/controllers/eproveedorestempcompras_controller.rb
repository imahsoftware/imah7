class EproveedorestempcomprasController < ApplicationController
  before_action :set_eproveedorestempcompra, only: [:show, :destroy]

  def index
    @eproveedorestempcompras = Eproveedorestempcompra.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Eproveedorestempcompra.find(params[:active_id]) if params[:active_id].present?
    @eproveedor = Eproveedor.find(params[:eproveedor_id])
    @eproveedorestempcompra = Eproveedorestempcompra.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Eproveedorestempcompra.find(params[:active_id]) if params[:active_id].present?
    @eproveedorestempcompra = Eproveedorestempcompra.find(params[:id])
    @eproveedor = @eproveedorestempcompra.eproveedor
    respond_to { |format| format.js }
  end

  def create
    @eproveedor  = Eproveedor.find(params[:eproveedor_id])
    @eproveedorestempcompra = Eproveedorestempcompra.new(eproveedorestempcompra_params)
    @eproveedorestempcompra.eproveedor_id = @eproveedor.id
    @eproveedorestempcompra.user_id = is_admin
    respond_to do |format|
      if @eproveedorestempcompra.save
        ActiveRecord::Base.connection.execute("CALL prc_eproveedores(#{@eproveedorestempcompra.eproveedorescompra_id})")
        if @eproveedorestempcompra.incluir_otras.to_s == 'SI'
          Eproveedorescompra.where(["eproveedor_id =  #{@eproveedor.id} and saldo > 0"]).order(:nro_factura).each do |a|
            e = Eproveedorestempcompra.new
            e.eproveedor_id = @eproveedor.id
            e.user_id = is_admin
            e.forma_pago = @eproveedorestempcompra.forma_pago
            e.cuenta_id = @eproveedorestempcompra.cuenta_id
            e.fecha = @eproveedorestempcompra.fecha
            e.total = a.saldo
            e.eproveedorescompra_id = a.id
            e.save
            ActiveRecord::Base.connection.execute("CALL prc_eproveedores(#{a.id})")
          end
          flash[:notice] = "#{t :notice_crea_msj}"
          format.js {render inline: "location.reload();" }
        else
          flash[:notice] = "#{t :notice_crea_msj}"
          format.js
        end
      else
        format.js { render 'layouts/errors', locals: { object: @eproveedorestempcompra } }
      end
    end
  end

  def update
    @eproveedorestempcompra = Eproveedorestempcompra.find(params[:id])
    @eproveedorestempcompra.user_act = is_admin
    @eproveedor = @eproveedorestempcompra.eproveedor
    respond_to do |format|
      if @eproveedorestempcompra.update(eproveedorestempcompra_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @eproveedorestempcompra } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    idEpr = @eproveedorestempcompra.eproveedorescompra_id
    @eproveedorestempcompra.destroy
    ActiveRecord::Base.connection.execute("CALL prc_eproveedores(#{idEpr})")
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_eproveedorestempcompra
    @eproveedor = Eproveedor.find(params[:eproveedor_id])
    @eproveedorestempcompra = Eproveedorestempcompra.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def eproveedorestempcompra_params
    params.require(:eproveedorestempcompra).permit!
  end
end
