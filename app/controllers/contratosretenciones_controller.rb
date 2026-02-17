class ContratosretencionesController < ApplicationController
  before_action :set_contratosretencion, only: [:show, :destroy]

  def index
    @contratosretenciones = Contratosretencion.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosretencion.find(params[:active_id]) if params[:active_id].present?
    @contrato = Contrato.find(params[:contrato_id])
    @contratosretencion = Contratosretencion.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosretencion.find(params[:active_id]) if params[:active_id].present?
    @contratosretencion = Contratosretencion.find(params[:id])
    @contrato = @contratosretencion.contrato
    respond_to { |format| format.js }
  end

  def create
    @contrato  = Contrato.find(params[:contrato_id])
    @contratosretencion = Contratosretencion.new(contratosretencion_params)
    @contratosretencion.contrato_id = @contrato.id
    @contratosretencion.user_id = is_admin
    respond_to do |format|
      if @contratosretencion.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosretencion } }
      end
    end
  end

  def update
    @contratosretencion = Contratosretencion.find(params[:id])
    @contrato = @contratosretencion.contrato
    respond_to do |format|
      if @contratosretencion.update(contratosretencion_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosretencion } }
      end
    end
  end

  def destroy
    flash['danger'] = 'Eliminado correctamente'
    @contratosretencion.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosretencion
    @contrato = Contrato.find(params[:contrato_id])
    @contratosretencion = Contratosretencion.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosretencion_params
    params.require(:contratosretencion).permit!
  end
end
