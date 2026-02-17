class VisitassedesController < ApplicationController
  before_action :set_visitassede, only: [:show, :destroy]

  def index
    @visitassedes = Visitassede.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Visitassede.find(params[:active_id]) if params[:active_id].present?
    @visita = Visita.find(params[:visita_id])
    @visitassede = Visitassede.new
    @contratossedes = Contratossede.where(["contrato_id = #{@visita.contrato_id}"])
    if @contratossedes.present?
      @sede = true
    else
      @sede = false
    end
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Visitassede.find(params[:active_id]) if params[:active_id].present?
    @visitassede = Visitassede.find(params[:id])
    @visita = @visitassede.visita
    respond_to { |format| format.js }
  end

  def create
    @visita  = Visita.find(params[:visita_id])
    @visitassede = Visitassede.new(visitassede_params)
    @visitassede.visita_id = @visita.id
    @visitassede.user_id = is_admin
    respond_to do |format|
      if @visitassede.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @visitassede } }
      end
    end
  end

  def update
    @visitassede = Visitassede.find(params[:id])
    @visita = @visitassede.visita
    respond_to do |format|
      if @visitassede.update(visitassede_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @visitassede } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @visitassede.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_visitassede
    @visita = Visita.find(params[:visita_id])
    @visitassede = Visitassede.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def visitassede_params
    params.require(:visitassede).permit!
  end
end
