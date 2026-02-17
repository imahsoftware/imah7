class ContratosperalertasController < ApplicationController
  before_action :set_contratosperalerta, only: [:show, :destroy]

  def index
    @contratosperalertas = Contratosperalerta.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosperalerta.find(params[:active_id]) if params[:active_id].present?
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratosperalerta = Contratosperalerta.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosperalerta.find(params[:active_id]) if params[:active_id].present?
    @contratosperalerta = Contratosperalerta.find(params[:id])
    @contratospersona = @contratosperalerta.contratospersona
    respond_to { |format| format.js }
  end

  def create
    @contratospersona  = Contratospersona.find(params[:contratospersona_id])
    @contratosperalerta = Contratosperalerta.new(contratosperalerta_params)
    @contratosperalerta.contratospersona_id = @contratospersona.id
    @contratosperalerta.user_id = is_admin
    respond_to do |format|
      if @contratosperalerta.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperalerta } }
      end
    end
  end

  def update
    @contratosperalerta = Contratosperalerta.find(params[:id])
    @contratospersona = @contratosperalerta.contratospersona
    respond_to do |format|
      if @contratosperalerta.update(contratosperalerta_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperalerta } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosperalerta.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosperalerta
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratosperalerta = Contratosperalerta.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosperalerta_params
    params.require(:contratosperalerta).permit!
  end
end
