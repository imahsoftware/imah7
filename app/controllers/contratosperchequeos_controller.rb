class ContratosperchequeosController < ApplicationController
  before_action :set_contratosperchequeo, only: [:show, :destroy]

  def index
    @contratosperchequeos = Contratosperchequeo.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosperchequeo.find(params[:active_id]) if params[:active_id].present?
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratosperchequeo = Contratosperchequeo.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosperchequeo.find(params[:active_id]) if params[:active_id].present?
    @contratosperchequeo = Contratosperchequeo.find(params[:id])
    @contratospersona = @contratosperchequeo.contratospersona
    respond_to { |format| format.js }
  end

  def create
    @contratospersona  = Contratospersona.find(params[:contratospersona_id])
    @contratosperchequeo = Contratosperchequeo.new(contratosperchequeo_params)
    @contratosperchequeo.contratospersona_id = @contratospersona.id
    @contratosperchequeo.user_id = is_admin
    respond_to do |format|
      if @contratosperchequeo.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperchequeo } }
      end
    end
  end

  def update
    @contratosperchequeo = Contratosperchequeo.find(params[:id])
    @contratosperchequeo.user_act = is_admin
    @contratospersona = @contratosperchequeo.contratospersona
    respond_to do |format|
      if @contratosperchequeo.update(contratosperchequeo_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperchequeo } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosperchequeo.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosperchequeo
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratosperchequeo = Contratosperchequeo.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosperchequeo_params
    params.require(:contratosperchequeo).permit!
  end
end
