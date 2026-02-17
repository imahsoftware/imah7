class ContratoscargosnotasController < ApplicationController
  before_action :set_contratoscargosnota, only: [:show, :destroy, :new]

  def index
    @contratoscargosnotas = Contratoscargosnota.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratoscargosnota.find(params[:active_id]) if params[:active_id].present?
    @contratoscargo = Contratoscargo.find(params[:contratoscargo_id])
    @contratoscargosnota = Contratoscargosnota.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratoscargosnota.find(params[:active_id]) if params[:active_id].present?
    @contratoscargosnota = Contratoscargosnota.find(params[:id])
    @contratoscargo = @contratoscargosnota.contratoscargo
    respond_to { |format| format.js }
  end

  def create
    @contratoscargo  = Contratoscargo.find(params[:contratoscargo_id])
    @contratoscargosnota = Contratoscargosnota.new(contratoscargosnota_params)
    @contratoscargosnota.contratoscargo_id = @contratoscargo.id
    @contratoscargosnota.user_id = is_admin
    respond_to do |format|
      if @contratoscargosnota.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratoscargosnota } }
      end
    end
  end

  def update
    @contratoscargosnota = Contratoscargosnota.find(params[:id])
    @contratoscargo = @contratoscargosnota.contratoscargo
    respond_to do |format|
      if @contratoscargosnota.update(contratoscargosnota_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratoscargosnota } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratoscargosnota.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratoscargosnota
    @contratoscargo = Contratoscargo.find(params[:contratoscargo_id])
    @contratoscargosnota = Contratoscargosnota.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratoscargosnota_params
    params.require(:contratoscargosnota).permit!
  end
end
