class VisitasasistentesController < ApplicationController
  before_action :set_visitasasistente, only: [:show, :destroy]

  def index
    @visitasasistentes = Visitasasistente.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Visitasasistente.find(params[:active_id]) if params[:active_id].present?
    @visita = Visita.find(params[:visita_id])
    @visitasasistente = Visitasasistente.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Visitasasistente.find(params[:active_id]) if params[:active_id].present?
    @visitasasistente = Visitasasistente.find(params[:id])
    @visita = @visitasasistente.visita
    respond_to { |format| format.js }
  end


  def create
    @visita  = Visita.find(params[:visita_id])
    @visitasasistente = Visitasasistente.new(visitasasistente_params)
    @visitasasistente.visita_id = @visita.id
    @visitasasistente.user_id = is_admin
    respond_to do |format|
      if @visitasasistente.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @visitasasistente } }
      end
    end
  end

  def update
    @visitasasistente = Visitasasistente.find(params[:id])
    @visita = @visitasasistente.visita
    respond_to do |format|
      if @visitasasistente.update(visitasasistente_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @visitasasistente } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @visitasasistente.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_visitasasistente
    @visita = Visita.find(params[:visita_id])
    @visitasasistente = Visitasasistente.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def visitasasistente_params
    params.require(:visitasasistente).permit!
  end
end
