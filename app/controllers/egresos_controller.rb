class EgresosController < ApplicationController
  before_action :set_egreso, only: [:show, :edit, :update, :destroy, :veregreso]

  def veregreso
    fname = "Egreso_"+@egreso.nro_egreso.to_s rescue nil
    respond_to do |format|
      format.pdf {render pdf: "#{fname}", template: "egresos/veregreso", encoding: "UTF-8", page_size: 'Letter',:margin => {top: 15, :bottom => 20, :left => 15,:right => 15}}
    end
  end

  def cambio
    @egreso = Egreso.find(params[:id])
    estado = params[:estado].to_s
    if estado == 'ANULAR' or estado == 'ELIMINAR'
      ActiveRecord::Base.connection.execute("CALL prc_egresos_anulacion(#{@egreso.id},#{is_admin},'#{estado}')")
    elsif estado == 'DEPURAR' and params[:eproveedorescompra_id].to_i > 0
      ActiveRecord::Base.connection.execute("CALL prc_egresos_anulacion(#{@egreso.id},#{params[:eproveedorescompra_id].to_i},'#{estado}')")
    end
    flash[:notice] = "Realizado con exito"
    redirect_to edit_eproveedor_path(@egreso.eproveedor_id)
    #rescue
    #flash[:notice] = "Hay inconvenientes en el egreso"
    #redirect_to edit_eproveedor_path(@egreso.eproveedor_id)
  end

  private
  def set_egreso
    @egreso = Egreso.find(params[:id])
  end

  def egreso_params
    params.require(:egreso).permit!
  end
end

