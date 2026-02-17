class ContratosperdotadicionalesController < ApplicationController
  before_action :set_contratosperdotadicional, only: [:show, :destroy, :new]

  def index
    @contratosperdotadicionales = Contratosperdotadicional.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosperdotadicional.find(params[:active_id]) if params[:active_id].present?
    @contratosperdotacion = Contratosperdotacion.find(params[:contratosperdotacion_id])
    @contratosperdotadicional = Contratosperdotadicional.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosperdotadicional.find(params[:active_id]) if params[:active_id].present?
    @contratosperdotadicional = Contratosperdotadicional.find(params[:id])
    @contratosperdotacion = @contratosperdotadicional.contratosperdotacion
    respond_to { |format| format.js }
  end

  def create
    @contratosperdotacion  = Contratosperdotacion.find(params[:contratosperdotacion_id])
    @contratosperdotadicional = Contratosperdotadicional.new(contratosperdotadicional_params)
    @contratosperdotadicional.contratosperdotacion_id = @contratosperdotacion.id
    @contratosperdotadicional.user_id = is_admin
    respond_to do |format|
      if @contratosperdotadicional.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperdotadicional } }
      end
    end
  end

  def update
    @contratosperdotadicional = Contratosperdotadicional.find(params[:id])
    @contratosperdotacion = @contratosperdotadicional.contratosperdotacion
    respond_to do |format|
      if @contratosperdotadicional.update(contratosperdotadicional_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperdotadicional } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosperdotadicional.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosperdotadicional
    @contratosperdotacion = Contratosperdotacion.find(params[:contratosperdotacion_id])
    @contratosperdotadicional = Contratosperdotadicional.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosperdotadicional_params
    params.require(:contratosperdotadicional).permit!
  end
end
