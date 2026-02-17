class ContratosperembargosController < ApplicationController
  before_action :set_contratosperembargo, only: [:show, :destroy]

  def index
    @contratosperembargos = Contratosperembargo.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosperembargo.find(params[:active_id]) if params[:active_id].present?
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratosperembargo = Contratosperembargo.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosperembargo.find(params[:active_id]) if params[:active_id].present?
    @contratosperembargo = Contratosperembargo.find(params[:id])
    @contratospersona = @contratosperembargo.contratospersona
    respond_to { |format| format.js }
  end

  def create
    @contratospersona  = Contratospersona.find(params[:contratospersona_id])
    @contratosperembargo = Contratosperembargo.new(contratosperembargo_params)
    @contratosperembargo.contratospersona_id = @contratospersona.id
    @contratosperembargo.user_id = is_admin
    if @contratosperembargo.tope.to_i > 0
      @contratosperembargo.saldo = @contratosperembargo.tope
    else
      @contratosperembargo.saldo = @contratosperembargo.valor
    end
    respond_to do |format|
      if @contratosperembargo.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperembargo } }
      end
    end
  end

  def update
    @contratosperembargo = Contratosperembargo.find(params[:id])
    @contratospersona = @contratosperembargo.contratospersona
    respond_to do |format|
      if @contratosperembargo.update(contratosperembargo_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperembargo } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosperembargo.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosperembargo
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratosperembargo = Contratosperembargo.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosperembargo_params
    params.require(:contratosperembargo).permit!
  end
end
