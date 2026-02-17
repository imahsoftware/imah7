
class ContratosprefimagenesController < ApplicationController
  before_action :set_contratosprefimagen, only: [:show, :destroy]

  def index
    @contratosprefimagenes = Contratosprefimagen.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosprefimagen.find(params[:active_id]) if params[:active_id].present?
    @contratosprefactura = Contratosprefactura.find(params[:contratosprefactura_id])
    @contratosprefimagen = Contratosprefimagen.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosprefimagen.find(params[:active_id]) if params[:active_id].present?
    @contratosprefimagen = Contratosprefimagen.find(params[:id])
    @contratosprefactura = @contratosprefimagen.contratosprefactura
    respond_to { |format| format.js }
  end

  def create
    @contratosprefactura  = Contratosprefactura.find(params[:contratosprefactura_id])
    @contratosprefimagen = Contratosprefimagen.new(contratosprefimagen_params)
    @contratosprefimagen.contratosprefactura_id = @contratosprefactura.id
    @contratosprefimagen.user_id = is_admin
    respond_to do |format|
      if @contratosprefimagen.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosprefimagen } }
      end
    end
  end

  def update
    @contratosprefimagen = Contratosprefimagen.find(params[:id])
    @contratosprefactura = @contratosprefimagen.contratosprefactura
    respond_to do |format|
      if @contratosprefimagen.update(contratosprefimagen_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosprefimagen } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosprefimagen.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosprefimagen
    @contratosprefactura = Contratosprefactura.find(params[:contratosprefactura_id])
    @contratosprefimagen = Contratosprefimagen.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosprefimagen_params
    params.require(:contratosprefimagen).permit!
  end
end
