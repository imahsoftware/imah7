class ContratostiposnovedadesController < ApplicationController
  before_action :set_contratostiposnovedad, only: [:show, :destroy]

  def index
    @contratostiposnovedades = Contratostiposnovedad.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratostiposnovedad.find(params[:active_id]) if params[:active_id].present?
    @contrato = Contrato.find(params[:contrato_id])
    @contratostiposnovedad = Contratostiposnovedad.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratostiposnovedad.find(params[:active_id]) if params[:active_id].present?
    @contratostiposnovedad = Contratostiposnovedad.find(params[:id])
    @contrato = @contratostiposnovedad.contrato
    respond_to { |format| format.js }
  end

  def create
    @contrato  = Contrato.find(params[:contrato_id])
    @contratostiposnovedad = Contratostiposnovedad.new(contratostiposnovedad_params)
    @contratostiposnovedad.contrato_id = @contrato.id
    respond_to do |format|
      if @contratostiposnovedad.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratostiposnovedad } }
      end
    end
  end

  def update
    @contratostiposnovedad = Contratostiposnovedad.find(params[:id])
    @contrato = @contratostiposnovedad.contrato
    respond_to do |format|
      if @contratostiposnovedad.update(contratostiposnovedad_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratostiposnovedad } }
      end
    end
  end

  def destroy
    flash['danger'] = 'Eliminado correctamente'
    @contratostiposnovedad.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratostiposnovedad
    @contrato = Contrato.find(params[:contrato_id])
    @contratostiposnovedad = Contratostiposnovedad.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratostiposnovedad_params
    params.require(:contratostiposnovedad).permit!
  end
end
