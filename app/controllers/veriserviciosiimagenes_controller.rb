  class VeriserviciosiimagenesController < ApplicationController
  before_action :set_veriserviciosiimagen, only: [:show, :destroy]

  def index
    @veriserviciosiimagenes = Veriserviciosiimagen.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Veriserviciosiimagen.find(params[:active_id]) if params[:active_id].present?
    @veriserviciositem = Veriserviciositem.find(params[:veriserviciositem_id])
    @veriserviciosiimagen = Veriserviciosiimagen.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Veriserviciosiimagen.find(params[:active_id]) if params[:active_id].present?
    @veriserviciosiimagen = Veriserviciosiimagen.find(params[:id])
    @veriserviciositem = @veriserviciosiimagen.veriserviciositem
    respond_to { |format| format.js }
  end

  def create
    @veriserviciositem = Veriserviciositem.find(params[:veriserviciositem_id])
    @veriserviciosiimagen = Veriserviciosiimagen.new(veriserviciosiimagen_params)
    @veriserviciosiimagen.veriserviciositem_id = @veriserviciositem.id
    @veriserviciosiimagen.user_id = is_admin
    respond_to do |format|
      if @veriserviciosiimagen.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @veriserviciosiimagen } }
      end
    end
  end

  def captura
    @veriserviciositem = Veriserviciositem.find(params[:veriserviciositem_id])
    @image = Veriserviciosiimagen.new
  end

  def captura_trasera
    @veriserviciositem = Veriserviciositem.find(params[:veriserviciositem_id])
    @image = Veriserviciosiimagen.new
  end


  def update
    @veriserviciosiimagen = Veriserviciosiimagen.find(params[:id])
    @veriserviciositem = @veriserviciosiimagen.veriserviciositem
    respond_to do |format|
      if @veriserviciosiimagen.update(veriserviciosiimagen_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @veriserviciosiimagen } }
      end
    end
  end

  def destroy
    @veriserviciosiimagen.destroy
    respond_to do |format|
      flash[:notice] = "Eliminado correctamente!!"
      format.js { render inline: "location.reload();" }
    end
  end
  

  def create2
    @veriserviciositem = Veriserviciositem.find(params[:id])
    @veriserviciosiimagen = Veriserviciosiimagen.new(veriserviciosiimagen_params)
    @veriserviciosiimagen.user_id = is_admin
    @veriserviciosiimagen.veriserviciositem_id = @veriserviciositem.id
    respond_to do |format|
      if @veriserviciosiimagen.save
        flash[:notice] = "Documento Registrado con Exito."
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @veriserviciosiimagen } }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_veriserviciosiimagen
      @veriserviciositem = Veriserviciositem.find(params[:veriserviciositem_id])
      @veriserviciosiimagen = Veriserviciosiimagen.find(params[:id]) if params[:id]
    end

    # Only allow a list of trusted parameters through.
    def veriserviciosiimagen_params
      params.require(:veriserviciosiimagen).permit!
    end
end
