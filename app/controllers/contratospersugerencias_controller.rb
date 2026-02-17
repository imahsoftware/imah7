class ContratospersugerenciasController < ApplicationController
  before_action :set_contratospersugerencia, only: [:show, :destroy]

  def index
    @contratospersugerencias = Contratospersugerencia.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratospersugerencia.find(params[:active_id]) if params[:active_id].present?
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratospersugerencia = Contratospersugerencia.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratospersugerencia.find(params[:active_id]) if params[:active_id].present?
    @contratospersugerencia = Contratospersugerencia.find(params[:id])
    @contratospersona = @contratospersugerencia.contratospersona
    respond_to { |format| format.js }
  end

  def create
    @contratospersona  = Contratospersona.find(params[:contratospersona_id])
    @contratospersugerencia = Contratospersugerencia.new(contratospersugerencia_params)
    @contratospersugerencia.contratospersona_id = @contratospersona.id
    @contratospersugerencia.user_id = is_admin
    respond_to do |format|
      if @contratospersugerencia.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratospersugerencia } }
      end
    end
  end

  def update
    @contratospersugerencia = Contratospersugerencia.find(params[:id])
    @contratospersugerencia.user_act = is_admin
    @contratospersona = @contratospersugerencia.contratospersona
    respond_to do |format|
      if @contratospersugerencia.update(contratospersugerencia_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratospersugerencia } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratospersugerencia.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratospersugerencia
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratospersugerencia = Contratospersugerencia.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratospersugerencia_params
    params.require(:contratospersugerencia).permit!
  end
end
