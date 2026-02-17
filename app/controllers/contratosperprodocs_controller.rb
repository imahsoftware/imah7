class ContratosperprodocsController < ApplicationController
  before_action :set_contratosperprodoc, only: [:show, :destroy]

  def index
    @contratosperprodocs = Contratosperprodoc.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosperprodoc.find(params[:active_id]) if params[:active_id].present?
    @contratosperproceso = Contratosperproceso.find(params[:contratosperproceso_id])
    @contratosperprodoc = Contratosperprodoc.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosperprodoc.find(params[:active_id]) if params[:active_id].present?
    @contratosperprodoc = Contratosperprodoc.find(params[:id])
    @contratosperproceso = @contratosperprodoc.contratosperproceso
    respond_to { |format| format.js }
  end

  def create
    @ruta = params[:ruta] rescue nil
    @contratosperproceso  = Contratosperproceso.find(params[:contratosperproceso_id])
    @contratosperprodoc = Contratosperprodoc.new(contratosperprodoc_params)
    @contratosperprodoc.contratosperproceso_id = @contratosperproceso.id
    @contratosperprodoc.contratospersona_id = @contratosperproceso.contratospersona_id
    @contratosperprodoc.user_id = is_admin
    respond_to do |format|
      if @contratosperprodoc.save
        flash[:notice] = "#{t :notice_crea_msj}"
        if @ruta == 'PROCESO'
          format.js
        else
          format.js { render inline: "location.reload();" }
        end
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperprodoc } }
      end
    end
  end

  def update
    @contratosperprodoc = Contratosperprodoc.find(params[:id])
    @contratosperproceso = @contratosperprodoc.contratosperproceso
    respond_to do |format|
      if @contratosperprodoc.update(contratosperprodoc_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperprodoc } }
      end
    end
  end

  def destroy
    @ruta = params[:ruta] rescue nil
    flash['success'] = 'Eliminado correctamente'
    @contratosperprodoc.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosperprodoc
    @contratosperproceso = Contratosperproceso.find(params[:contratosperproceso_id])
    @contratosperprodoc = Contratosperprodoc.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosperprodoc_params
    params.require(:contratosperprodoc).permit!
  end
end
