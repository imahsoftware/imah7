class ProveedorescontactosController < ApplicationController
  before_action :set_proveedorescontacto, only: [:show, :destroy]

  def index
    @proveedorescontactos = Proveedorescontacto.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Proveedorescontacto.find(params[:active_id]) if params[:active_id].present?
    @proveedor = Proveedor.find(params[:proveedor_id])
    @proveedorescontacto = Proveedorescontacto.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Proveedorescontacto.find(params[:active_id]) if params[:active_id].present?
    @proveedorescontacto = Proveedorescontacto.find(params[:id])
    @proveedor = @proveedorescontacto.proveedor
    respond_to { |format| format.js }
  end

  def create
    @proveedor  = Proveedor.find(params[:proveedor_id])
    @proveedorescontacto = Proveedorescontacto.new(proveedorescontacto_params)
    @proveedorescontacto.proveedor_id = @proveedor.id
    @proveedorescontacto.user_id = is_admin
    respond_to do |format|
      if @proveedorescontacto.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @proveedorescontacto } }
      end
    end
  end

  def update
    @proveedorescontacto = Proveedorescontacto.find(params[:id])
    @proveedor = @proveedorescontacto.proveedor
    respond_to do |format|
      if @proveedorescontacto.update(proveedorescontacto_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @proveedorescontacto } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @proveedorescontacto.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_proveedorescontacto
    @proveedor = Proveedor.find(params[:proveedor_id])
    @proveedorescontacto = Proveedorescontacto.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def proveedorescontacto_params
    params.require(:proveedorescontacto).permit!
  end
end
