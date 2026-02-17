class VeriserviciosicompromisosController < ApplicationController
  before_action :set_veriserviciosicompromiso, only: [:show, :destroy]

  def index
    @veriserviciosicompromisos = Veriserviciosicompromiso.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Veriserviciosicompromiso.find(params[:active_id]) if params[:active_id].present?
    @veriserviciositem = Veriserviciositem.find(params[:veriserviciositem_id])
    @veriserviciosicompromiso = Veriserviciosicompromiso.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Veriserviciosicompromiso.find(params[:active_id]) if params[:active_id].present?
    @veriserviciosicompromiso = Veriserviciosicompromiso.find(params[:id])
    @veriserviciositem = @veriserviciosicompromiso.veriserviciositem
    respond_to { |format| format.js }
  end

  def create
    @veriserviciositem = Veriserviciositem.find(params[:veriserviciositem_id])
    @veriserviciosicompromiso = Veriserviciosicompromiso.new(veriserviciosicompromiso_params)
    @veriserviciosicompromiso.veriserviciositem_id = @veriserviciositem.id
    @veriserviciosicompromiso.estado = 'PENDIENTE'
    @veriserviciosicompromiso.user_id = is_admin
    respond_to do |format|
      if @veriserviciosicompromiso.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @veriserviciosicompromiso } }
      end
    end
  end

  def update
    @veriserviciosicompromiso = Veriserviciosicompromiso.find(params[:id])
    @veriserviciositem = @veriserviciosicompromiso.veriserviciositem
    respond_to do |format|
      if @veriserviciosicompromiso.update(veriserviciosicompromiso_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @veriserviciosicompromiso } }
      end
    end
  end

  def destroy
    @veriserviciosicompromiso.destroy
    respond_to do |format|
      flash[:notice] = "Eliminado correctamente!!"
      format.js { render inline: "location.reload();" }
    end
  end

  def create2
    @veriserviciositem = Veriserviciositem.find(params[:id])
    @veriserviciosicompromiso = Veriserviciosicompromiso.new(veriserviciosicompromiso_params)
    @veriserviciosicompromiso.user_id = is_admin
    @veriserviciosicompromiso.veriserviciositem_id = @veriserviciositem.id
    @veriserviciosicompromiso.estado = 'PENDIENTE'
    respond_to do |format|
      if @veriserviciosicompromiso.save
        flash[:notice] = "Compromiso Registrado con Exito."
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @veriserviciosicompromiso } }
      end
    end
  end


  private

  # Use callbacks to share common setup or constraints between actions.

  def set_veriserviciosicompromiso
    @veriserviciositem = Veriserviciositem.find(params[:veriserviciositem_id])
    @veriserviciosicompromiso = Veriserviciosicompromiso.find(params[:id]) if params[:id]
  end

  # Only allow a list of trusted parameters through.
  def veriserviciosicompromiso_params
    params.require(:veriserviciosicompromiso).permit!
  end
end
