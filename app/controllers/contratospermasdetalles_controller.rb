class ContratospermasdetallesController < ApplicationController
  before_action :set_contratospermasdetalle, only: [:show, :destroy]

  def index
    @contratospermasdetalles = Contratospermasdetalle.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratospermasdetalle.find(params[:active_id]) if params[:active_id].present?
    @contratospermasiva = Contratospermasiva.find(params[:contratospermasiva_id])
    @contratospermasdetalle = Contratospermasdetalle.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratospermasdetalle.find(params[:active_id]) if params[:active_id].present?
    @contratospermasdetalle = Contratospermasdetalle.find(params[:id])
    @contratospermasiva = @contratospermasdetalle.contratospermasiva
    respond_to { |format| format.js }
  end

  def create
    @contratospermasiva  = Contratospermasiva.find(params[:contratospermasiva_id])
    @contratospermasdetalle = Contratospermasdetalle.new(contratospermasdetalle_params)
    @contratospermasdetalle.contratospermasiva_id = @contratospermasiva.id
    respond_to do |format|
      if @contratospermasdetalle.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratospermasdetalle } }
      end
    end
  end

  def update
    @contratospermasdetalle = Contratospermasdetalle.find(params[:id])
    @contratospermasiva = @contratospermasdetalle.contratospermasiva
    respond_to do |format|
      if @contratospermasdetalle.update(contratospermasdetalle_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratospermasdetalle } }
      end
    end
  end

  def proceso
    contratospermasiva_id = params[:contratospermasiva_id].to_s rescue nil
    contratospermasdetalle = params[:id].to_s rescue nil
    contratosperfecha_id = params[:contratosperfecha_id].to_s rescue nil
    proceso = params[:proceso].to_s rescue nil
    if contratospermasdetalle.to_s != ""
      @contratospermasdetalles = Contratospermasdetalle.includes([:contratospermasiva]).where(id: params[:id])
      @isadmin = is_admin
      fname = "AsearProceso_" + @contratospermasdetalles[0].contratosperfecha.contratospersona.identificacion.to_s
      respond_to do |format|
        format.pdf { render pdf:"#{fname}", template:"contratospermasdetalles/proceso", encoding: "UTF-8", page_size: 'Letter'} #,disposition: 'attachment'}
      end
    elsif contratospermasiva_id.to_s != ""
      @contratospermasdetalles = Contratospermasdetalle.includes([:contratospermasiva]).where(contratospermasiva_id: params[:contratospermasiva_id])
      @isadmin = is_admin
      fname = "AsearProceso_" + contratospermasiva_id.to_s
      respond_to do |format|
        format.pdf { render pdf:"#{fname}", template:"contratospermasdetalles/proceso", encoding: "UTF-8", page_size: 'Letter'} #,disposition: 'attachment'}
      end
    elsif contratosperfecha_id.to_s != ""
      @contratospermasdetalles = Contratospermasdetalle.joins(:contratospermasiva).where(["contratospermasdetalles.contratosperfecha_id = #{contratosperfecha_id} and contratospermasivas.proceso = '#{proceso}'"])
      @isadmin = is_admin
      fname = "AsearProceso_" + contratospermasiva_id.to_s
      respond_to do |format|
        format.pdf { render pdf:"#{fname}", template:"contratospermasdetalles/proceso", encoding: "UTF-8", page_size: 'Letter'} #,disposition: 'attachment'}
      end
    end
  end

  def proceso_masive

  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    if @contratospermasdetalle.contratospermasiva.estado.to_s == 'PENDIENTE'
      @contratospermasdetalle.destroy
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratospermasdetalle
    @contratospermasiva = Contratospermasiva.find(params[:contratospermasiva_id])
    @contratospermasdetalle = Contratospermasdetalle.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratospermasdetalle_params
    params.require(:contratospermasdetalle).permit!
  end
end
