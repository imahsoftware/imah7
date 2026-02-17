class InsumosfichasController < ApplicationController
  before_action :set_insumosficha, only: [:show, :destroy]

  def index
    @insumosfichas = Insumosficha.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Insumosficha.find(params[:active_id]) if params[:active_id].present?
    @insumo = Insumo.find(params[:insumo_id])
    @insumosficha = Insumosficha.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Insumosficha.find(params[:active_id]) if params[:active_id].present?
    @insumosficha = Insumosficha.find(params[:id])
    @insumo = @insumosficha.insumo
    respond_to { |format| format.js }
  end

  def create
    @insumo  = Insumo.find(params[:insumo_id])
    @insumosficha = Insumosficha.new(insumosficha_params)
    @insumosficha.insumo_id = @insumo.id
    @insumosficha.user_id = is_admin
    respond_to do |format|
      if @insumosficha.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @insumosficha } }
      end
    end
  end

  def update
    @insumosficha = Insumosficha.find(params[:id])
    @insumo = @insumosficha.insumo
    respond_to do |format|
      if @insumosficha.update(insumosficha_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @insumosficha } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @insumosficha.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_insumosficha
    @insumo = Insumo.find(params[:insumo_id])
    @insumosficha = Insumosficha.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def insumosficha_params
    params.require(:insumosficha).permit!
  end
end
