class ContratosautoinsumosController < ApplicationController
  before_action :set_contratosautoinsumo, only: [:show, :destroy]

  def index
    @contratosautoinsumos = Contratosautoinsumo.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosautoinsumo.find(params[:active_id]) if params[:active_id].present?
    @contrato = Contrato.find(params[:contrato_id])
    @contratosautoinsumo = Contratosautoinsumo.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosautoinsumo.find(params[:active_id]) if params[:active_id].present?
    @contratosautoinsumo = Contratosautoinsumo.find(params[:id])
    @contrato = @contratosautoinsumo.contrato
    respond_to { |format| format.js }
  end

  def create
    @contrato  = Contrato.find(params[:contrato_id])
    @contratosautoinsumo = Contratosautoinsumo.new(contratosautoinsumo_params)
    @contratosautoinsumo.contrato_id = @contrato.id
    @contratosautoinsumo.user_id = is_admin
    respond_to do |format|
      if @contratosautoinsumo.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosautoinsumo } }
      end
    end
  end

  def update
    @contratosautoinsumo = Contratosautoinsumo.find(params[:id])
    @contrato = @contratosautoinsumo.contrato
    respond_to do |format|
      if @contratosautoinsumo.update(contratosautoinsumo_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosautoinsumo } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosautoinsumo.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosautoinsumo
    @contrato = Contrato.find(params[:contrato_id])
    @contratosautoinsumo = Contratosautoinsumo.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosautoinsumo_params
    params.require(:contratosautoinsumo).permit!
  end
end
