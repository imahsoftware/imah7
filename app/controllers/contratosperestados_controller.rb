class ContratosperestadosController < ApplicationController
  before_action :set_contratosperestado, only: [:show, :destroy]

  def index
    @contratosperestados = Contratosperestado.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosperestado.find(params[:active_id]) if params[:active_id].present?
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratosperestado = Contratosperestado.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosperestado.find(params[:active_id]) if params[:active_id].present?
    @contratosperestado = Contratosperestado.find(params[:id])
    @contratospersona = @contratosperestado.contratospersona
    respond_to { |format| format.js }
  end

  def create
    @contratospersona  = Contratospersona.find(params[:contratospersona_id])
    @contratosperestado = Contratosperestado.new(contratosperestado_params)
    @contratosperestado.contratospersona_id = @contratospersona.id
    @contratosperestado.user_id = is_admin
    respond_to do |format|
      if @contratosperestado.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperestado } }
      end
    end
  end

  def update
    @contratosperestado = Contratosperestado.find(params[:id])
    @contratosperestado.user_act = is_admin
    @contratospersona = @contratosperestado.contratospersona
    respond_to do |format|
      if @contratosperestado.update(contratosperestado_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperestado } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosperestado.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosperestado
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratosperestado = Contratosperestado.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosperestado_params
    params.require(:contratosperestado).permit!
  end
end
