class ContratosperbitacorasController < ApplicationController
  before_action :set_contratosperbitacora, only: [:show, :destroy]

  def index
    @contratosperbitacoras = Contratosperbitacora.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosperbitacora.find(params[:active_id]) if params[:active_id].present?
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratosperbitacora = Contratosperbitacora.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosperbitacora.find(params[:active_id]) if params[:active_id].present?
    @contratosperbitacora = Contratosperbitacora.find(params[:id])
    @contratospersona = @contratosperbitacora.contratospersona
    respond_to { |format| format.js }
  end

  def create
    @contratospersona  = Contratospersona.find(params[:contratospersona_id])
    @contratosperbitacora = Contratosperbitacora.new(contratosperbitacora_params)
    @contratosperbitacora.contratospersona_id = @contratospersona.id
    @contratosperbitacora.user_id = is_admin
    respond_to do |format|
      if @contratosperbitacora.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperbitacora } }
      end
    end
  end

  def update
    @contratosperbitacora = Contratosperbitacora.find(params[:id])
    @contratosperbitacora.user_act = is_admin
    @contratospersona = @contratosperbitacora.contratospersona
    respond_to do |format|
      if @contratosperbitacora.update(contratosperbitacora_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperbitacora } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosperbitacora.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosperbitacora
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratosperbitacora = Contratosperbitacora.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosperbitacora_params
    params.require(:contratosperbitacora).permit!
  end
end
