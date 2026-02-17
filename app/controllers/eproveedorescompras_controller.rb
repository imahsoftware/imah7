class EproveedorescomprasController < ApplicationController
  before_action :set_eproveedorescompra, only: [:show, :destroy]

  def index
    @eproveedorescompras = Eproveedorescompra.all
  end

  def show
    respond_to { |format| format.js }
  end

  def show_detalle
    @ruta = params[:ruta]
    @consecutivo = params[:eproveedorescompra_id]
    @datos = Eproveedorescompra.find(@consecutivo)
  end

  def new
    @active_record = Eproveedorescompra.find(params[:active_id]) if params[:active_id].present?
    @eproveedor = Eproveedor.find(params[:eproveedor_id])
    @eproveedorescompra = Eproveedorescompra.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Eproveedorescompra.find(params[:active_id]) if params[:active_id].present?
    @eproveedorescompra = Eproveedorescompra.find(params[:id])
    @eproveedor = @eproveedorescompra.eproveedor
    respond_to { |format| format.js }
  end

  def create
    @eproveedor  = Eproveedor.find(params[:eproveedor_id])
    @eproveedorescompra = Eproveedorescompra.new(eproveedorescompra_params)
    @eproveedorescompra.eproveedor_id = @eproveedor.id
    @eproveedorescompra.user_id = is_admin
    @eproveedorescompra.estado = 'PENDIENTE'
    respond_to do |format|
      if @eproveedorescompra.save
        ActiveRecord::Base.connection.execute("CALL prc_eproveedores_retenciones(#{@eproveedorescompra.id})")
        ActiveRecord::Base.connection.execute("CALL prc_eproveedores(#{@eproveedorescompra.id})")
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js {render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @eproveedorescompra } }
      end
    end
  end

  def update
    @eproveedorescompra = Eproveedorescompra.find(params[:id])
    @eproveedorescompra.user_act = is_admin
    @eproveedor = @eproveedorescompra.eproveedor
    respond_to do |format|
      if @eproveedorescompra.update(eproveedorescompra_params)
        ActiveRecord::Base.connection.execute("CALL prc_eproveedores_retenciones(#{@eproveedorescompra.id})")
        ActiveRecord::Base.connection.execute("CALL prc_eproveedores(#{@eproveedorescompra.id})")
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js {render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @eproveedorescompra } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @eproveedorescompra.destroy

  end

  def vercausacion
    @eproveedorescompra = Eproveedorescompra.find(params[:id])
    fname = "Causacion_"+@eproveedorescompra.id.to_s rescue nil
    respond_to do |format|
      format.pdf {render pdf: "#{fname}", template: "eproveedorescompras/vercausacion", encoding: "UTF-8", page_size: 'Letter',:margin => {top: 15, :bottom => 20, :left => 15,:right => 15}}
    end
  end

  def equivalente
    @eproveedorescompra = Eproveedorescompra.find(params[:id])
    fname = "DocEquivalente_"+@eproveedorescompra.id.to_s rescue nil
    respond_to do |format|
      format.pdf {render pdf: "#{fname}", template: "eproveedorescompras/equivalente", encoding: "UTF-8", page_size: 'Letter',:margin => {top: 15, :bottom => 20, :left => 15,:right => 15}}
    end
  end

  def adicionar
    @eproveedorescompra = Eproveedorescompra.find(params[:id])
    eproveedorestempcompra = Eproveedorestempcompra.where(eproveedor_id: @eproveedorescompra.eproveedor_id)[0]
    e = Eproveedorestempcompra.new
    e.eproveedor_id = @eproveedorescompra.eproveedor_id
    e.user_id = is_admin
    e.forma_pago = eproveedorestempcompra.forma_pago
    e.cuenta_id = eproveedorestempcompra.cuenta_id
    e.fecha = eproveedorestempcompra.fecha
    e.total = @eproveedorescompra.saldo
    e.eproveedorescompra_id = @eproveedorescompra.id
    e.save
    ActiveRecord::Base.connection.execute("CALL prc_eproveedores(#{eproveedorestempcompra.id})")
    flash[:notice] = "Compra agregada con exito a la causacion"
    redirect_to edit_eproveedor_path(id: @eproveedorescompra.eproveedor_id, etapa: 'B')
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_eproveedorescompra
    @eproveedor = Eproveedor.find(params[:eproveedor_id])
    @eproveedorescompra = Eproveedorescompra.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def eproveedorescompra_params
    params.require(:eproveedorescompra).permit!
  end
end
