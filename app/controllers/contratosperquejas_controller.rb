class ContratosperquejasController < ApplicationController
  before_action :set_contratosperqueja, only: [:show, :destroy]

  def index
    @contratosperquejas = Contratosperqueja.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosperqueja.find(params[:active_id]) if params[:active_id].present?
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratosperqueja = Contratosperqueja.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosperqueja.find(params[:active_id]) if params[:active_id].present?
    @contratosperqueja = Contratosperqueja.find(params[:id])
    @contratospersona = @contratosperqueja.contratospersona
    respond_to { |format| format.js }
  end

  def create
    @contratospersona  = Contratospersona.find(params[:contratospersona_id])
    @contratosperqueja = Contratosperqueja.new(contratosperqueja_params)
    @contratosperqueja.contratospersona_id = @contratospersona.id
    @contratosperqueja.user_id = is_admin
    respond_to do |format|
      if @contratosperqueja.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperqueja } }
      end
    end
  end

  def update
    @contratosperqueja = Contratosperqueja.find(params[:id])
    @contratosperqueja.user_act = is_admin
    @contratospersona = @contratosperqueja.contratospersona
    respond_to do |format|
      if @contratosperqueja.update(contratosperqueja_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperqueja } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosperqueja.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosperqueja
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratosperqueja = Contratosperqueja.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosperqueja_params
    params.require(:contratosperqueja).permit!
  end
end
