class ContratossolotrosController < ApplicationController
  before_action :set_contratossolotro, only: [:show, :destroy]

  def index
    @contratossolotros = Contratossolotro.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratossolotro.find(params[:active_id]) if params[:active_id].present?
    @contratossolicitud = Contratossolicitud.find(params[:contratossolicitud_id])
    @contratossolotro = Contratossolotro.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratossolotro.find(params[:active_id]) if params[:active_id].present?
    @contratossolotro = Contratossolotro.find(params[:id])
    @contratossolicitud = @contratossolotro.contratossolicitud
    respond_to { |format| format.js }
  end

  def create
    @contratossolicitud  = Contratossolicitud.find(params[:contratossolicitud_id])
    @contratossolotro = Contratossolotro.new(contratossolotro_params)
    @contratossolotro.contratossolicitud_id = @contratossolicitud.id
    @contratossolotro.user_id = is_admin
    respond_to do |format|
      if @contratossolotro.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratossolotro } }
      end
    end
  end

  def update
    @contratossolotro = Contratossolotro.find(params[:id])
    @contratossolotro.user_act = is_admin
    @contratossolicitud = @contratossolotro.contratossolicitud
    respond_to do |format|
      if @contratossolotro.update(contratossolotro_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratossolotro } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratossolotro.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratossolotro
    @contratossolicitud = Contratossolicitud.find(params[:contratossolicitud_id])
    @contratossolotro = Contratossolotro.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratossolotro_params
    params.require(:contratossolotro).permit!
  end
end
