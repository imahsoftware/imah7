class VisitasnotasController < ApplicationController
  before_action :set_visitasnota, only: [:show, :destroy]

  def index
    @visitasnotas = Visitasnota.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Visitasnota.find(params[:active_id]) if params[:active_id].present?
    @visita = Visita.find(params[:visita_id])
    @visitasnota = Visitasnota.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Visitasnota.find(params[:active_id]) if params[:active_id].present?
    @visitasnota = Visitasnota.find(params[:id])
    @visita = @visitasnota.visita
    respond_to { |format| format.js }
  end

  def create
    @visita  = Visita.find(params[:visita_id])
    @visitasnota = Visitasnota.new(visitasnota_params)
    @visitasnota.visita_id = @visita.id
    @visitasnota.user_id = is_admin
    respond_to do |format|
      if @visitasnota.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @visitasnota } }
      end
    end
  end

  def update
    @visitasnota = Visitasnota.find(params[:id])
    @visita = @visitasnota.visita
    respond_to do |format|
      if @visitasnota.update(visitasnota_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @visitasnota } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @visitasnota.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_visitasnota
    @visita = Visita.find(params[:visita_id])
    @visitasnota = Visitasnota.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def visitasnota_params
    params.require(:visitasnota).permit!
  end
end
