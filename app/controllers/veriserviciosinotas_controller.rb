class VeriserviciosinotasController < ApplicationController
  before_action :set_veriserviciosinota, only: [:show, :destroy]

  def index
    @veriserviciosinotas = Veriserviciosinota.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Veriserviciosinota.find(params[:active_id]) if params[:active_id].present?
    @veriserviciositem = Veriserviciositem.find(params[:veriserviciositem_id])
    @veriserviciosinota = Veriserviciosinota.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Veriserviciosinota.find(params[:active_id]) if params[:active_id].present?
    @veriserviciosinota = Veriserviciosinota.find(params[:id])
    @veriserviciositem = @veriserviciosinota.veriserviciositem
    respond_to { |format| format.js }
  end

  def create
    @veriserviciositem = Veriserviciositem.find(params[:veriserviciositem_id])
    @veriserviciosinota = Veriserviciosinota.new(veriserviciosinota_params)
    @veriserviciosinota.veriserviciositem_id = @veriserviciositem.id
    @veriserviciosinota.user_id = is_admin
    respond_to do |format|
      if @veriserviciosinota.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @veriserviciosinota } }
      end
    end
  end

  def update
    @veriserviciosinota = Veriserviciosinota.find(params[:id])
    @veriserviciositem = @veriserviciosinota.veriserviciositem
    respond_to do |format|
      if @veriserviciosinota.update(veriserviciosinota_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @veriserviciosinota } }
      end
    end
  end

  def destroy
    @veriserviciosinota.destroy
    respond_to do |format|
      flash[:notice] = "Eliminado correctamente!!"
      format.js { render inline: "location.reload();" }
    end
  end

  def create2
    @veriserviciositem = Veriserviciositem.find(params[:id])
    @veriserviciosinota = Veriserviciosinota.new(veriserviciosinota_params)
    @veriserviciosinota.user_id = is_admin
    @veriserviciosinota.veriserviciositem_id = @veriserviciositem.id
    respond_to do |format|
      if @veriserviciosinota.save
        flash[:notice] = "Observación Registrado con Exito."
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @veriserviciosinota } }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_veriserviciosinota
      @veriserviciositem = Veriserviciositem.find(params[:veriserviciositem_id])
      @veriserviciosinota = Veriserviciosinota.find(params[:id]) if params[:id]
    end

    # Only allow a list of trusted parameters through.
    def veriserviciosinota_params
      params.require(:veriserviciosinota).permit!
    end
end
