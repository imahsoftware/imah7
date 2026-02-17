class ContratosserviciosController < ApplicationController
  before_action :set_contratosservicio, only: [:show, :destroy]

  def index
    @contratosservicios = Contratosservicio.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosservicio.find(params[:active_id]) if params[:active_id].present?
    @contrato = Contrato.find(params[:contrato_id])
    @contratosservicio = Contratosservicio.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosservicio.find(params[:active_id]) if params[:active_id].present?
    @contratosservicio = Contratosservicio.find(params[:id])
    @contrato = @contratosservicio.contrato
    respond_to { |format| format.js }
  end

  def create
    @contrato = Contrato.find(params[:contrato_id])
    @contratosservicio = Contratosservicio.new(contratosservicio_params)
    @contratosservicio.contrato_id = @contrato.id
    @contratosservicio.user_id = is_admin
    respond_to do |format|
      if @contratosservicio.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosservicio } }
      end
    end
  end

  def update
    @contratosservicio = Contratosservicio.find(params[:id])
    @contrato = @contratosservicio.contrato
    respond_to do |format|
      if @contratosservicio.update(contratosservicio_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosservicio } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosservicio.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contratosservicio
    @contrato = Contrato.find(params[:contrato_id])
    @contratosservicio = Contratosservicio.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosservicio_params
    params.require(:contratosservicio).permit!
  end
end
