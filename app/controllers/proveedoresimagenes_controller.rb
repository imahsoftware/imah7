class ProveedoresimagenesController < ApplicationController
  before_action :set_proveedoresimagen, only: [:show, :destroy]

  def index
    @proveedoresimagenes = Proveedoresimagen.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Proveedoresimagen.find(params[:active_id]) if params[:active_id].present?
    @proveedor = Proveedor.find(params[:proveedor_id])
    @proveedoresimagen = Proveedoresimagen.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Proveedoresimagen.find(params[:active_id]) if params[:active_id].present?
    @proveedoresimagen = Proveedoresimagen.find(params[:id])
    @proveedor = @proveedoresimagen.proveedor
    respond_to { |format| format.js }
  end

  def create
    @proveedor  = Proveedor.find(params[:proveedor_id])
    @proveedoresimagen = Proveedoresimagen.new(proveedoresimagen_params)
    @proveedoresimagen.proveedor_id = @proveedor.id
    @proveedoresimagen.user_id = is_admin
    respond_to do |format|
      if @proveedoresimagen.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @proveedoresimagen } }
      end
    end
  end

  def update
    @proveedoresimagen = Proveedoresimagen.find(params[:id])
    @proveedor = @proveedoresimagen.proveedor
    respond_to do |format|
      if @proveedoresimagen.update(proveedoresimagen_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @proveedoresimagen } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @proveedoresimagen.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_proveedoresimagen
    @proveedor = Proveedor.find(params[:proveedor_id])
    @proveedoresimagen = Proveedoresimagen.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def proveedoresimagen_params
    params.require(:proveedoresimagen).permit!
  end
end
