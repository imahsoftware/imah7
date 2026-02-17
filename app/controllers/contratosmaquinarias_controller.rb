class ContratosmaquinariasController < ApplicationController
  before_action :set_contratosmaquinaria, only: [:show, :destroy]

  def index
    @contratosmaquinarias = Contratosmaquinaria.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosmaquinaria.find(params[:active_id]) if params[:active_id].present?
    @contrato = Contrato.find(params[:contrato_id])
    @contratosmaquinaria = Contratosmaquinaria.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosmaquinaria.find(params[:active_id]) if params[:active_id].present?
    @contratosmaquinaria = Contratosmaquinaria.find(params[:id])
    @contrato = @contratosmaquinaria.contrato
    respond_to { |format| format.js }
  end

  def create
    @contrato  = Contrato.find(params[:contrato_id])
    @contratosmaquinaria = Contratosmaquinaria.new(contratosmaquinaria_params)
    @contratosmaquinaria.contrato_id = @contrato.id
    @contratosmaquinaria.user_id = is_admin
    respond_to do |format|
      if @contratosmaquinaria.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosmaquinaria } }
      end
    end
  end

  def update
    @contratosmaquinaria = Contratosmaquinaria.find(params[:id])
    @contratosmaquinaria.user_act = is_admin
    @contrato = @contratosmaquinaria.contrato
    respond_to do |format|
      if @contratosmaquinaria.update(contratosmaquinaria_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosmaquinaria } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosmaquinaria.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosmaquinaria
    @contrato = Contrato.find(params[:contrato_id])
    @contratosmaquinaria = Contratosmaquinaria.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosmaquinaria_params
    params.require(:contratosmaquinaria).permit!
  end
end
