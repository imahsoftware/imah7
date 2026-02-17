class EproveedoresimagenesController < ApplicationController
  before_action :set_eproveedoresimagen, only: [:show, :destroy]

  def index
    @eproveedoresimagenes = Eproveedoresimagen.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Eproveedoresimagen.find(params[:active_id]) if params[:active_id].present?
    @eproveedor = Eproveedor.find(params[:eproveedor_id])
    @eproveedoresimagen = Eproveedoresimagen.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Eproveedoresimagen.find(params[:active_id]) if params[:active_id].present?
    @eproveedoresimagen = Eproveedoresimagen.find(params[:id])
    @eproveedor = @eproveedoresimagen.eproveedor
    respond_to { |format| format.js }
  end

  def create
    @eproveedor  = Eproveedor.find(params[:eproveedor_id])
    @eproveedoresimagen = Eproveedoresimagen.new(eproveedoresimagen_params)
    @eproveedoresimagen.eproveedor_id = @eproveedor.id
    @eproveedoresimagen.user_id = is_admin
    respond_to do |format|
      if @eproveedoresimagen.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @eproveedoresimagen } }
      end
    end
  end

  def update
    @eproveedoresimagen = Eproveedoresimagen.find(params[:id])
    @eproveedor = @eproveedoresimagen.eproveedor
    respond_to do |format|
      if @eproveedoresimagen.update(eproveedoresimagen_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @eproveedoresimagen } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @eproveedoresimagen.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_eproveedoresimagen
    @eproveedor = Eproveedor.find(params[:eproveedor_id])
    @eproveedoresimagen = Eproveedoresimagen.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def eproveedoresimagen_params
    params.require(:eproveedoresimagen).permit!
  end
end
