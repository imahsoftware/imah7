class ContratosperliqnovedadesController < ApplicationController
  before_action :set_contratosperliqnovedad, only: [:show, :destroy, :new]

  def index
    @contratosperliqnovedades = Contratosperliqnovedad.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosperliqnovedad.find(params[:active_id]) if params[:active_id].present?
    @contratosperliquidacion = Contratosperliquidacion.find(params[:contratosperliquidacion_id])
    @contratosperliqnovedad = Contratosperliqnovedad.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosperliqnovedad.find(params[:active_id]) if params[:active_id].present?
    @contratosperliqnovedad = Contratosperliqnovedad.find(params[:id])
    @contratosperliquidacion = @contratosperliqnovedad.contratosperliquidacion
    respond_to { |format| format.js }
  end

  def create
    @contratosperliquidacion = Contratosperliquidacion.find(params[:contratosperliquidacion_id])
    @contratosperliqnovedad = Contratosperliqnovedad.new(contratosperliqnovedad_params)
    @contratosperliqnovedad.contratosperliquidacion_id = @contratosperliquidacion.id
    @contratosperliqnovedad.user_id = is_admin
    @contratosperliqnovedad.clase = 'M'
    respond_to do |format|
      if @contratosperliqnovedad.save
        idfech = @contratosperliquidacion.contratosperfecha_id
        ActiveRecord::Base.connection.execute("CALL prc_liquidacion_recal_esp(#{idfech});")
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperliqnovedad } }
      end
    end
  end

  def update
    @contratosperliqnovedad = Contratosperliqnovedad.find(params[:id])
    @contratosperliquidacion = @contratosperliqnovedad.contratosperliquidacion
    respond_to do |format|
      if @contratosperliqnovedad.update(contratosperliqnovedad_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperliqnovedad } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    idfech = @contratosperliquidacion.contratosperfecha_id
    @contratosperliqnovedad.destroy
    ActiveRecord::Base.connection.execute("CALL prc_liquidacion_recal_esp(#{idfech});")
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosperliqnovedad
    @contratosperliquidacion = Contratosperliquidacion.find(params[:contratosperliquidacion_id])
    @contratosperliqnovedad = Contratosperliqnovedad.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosperliqnovedad_params
    params.require(:contratosperliqnovedad).permit!
  end
end
