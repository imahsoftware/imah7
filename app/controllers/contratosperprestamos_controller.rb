class ContratosperprestamosController < ApplicationController
  before_action :set_contratosperprestamo, only: [:show, :destroy]

  def index
    @contratosperprestamos = Contratosperprestamo.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosperprestamo.find(params[:active_id]) if params[:active_id].present?
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratosperprestamo = Contratosperprestamo.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosperprestamo.find(params[:active_id]) if params[:active_id].present?
    @contratosperprestamo = Contratosperprestamo.find(params[:id])
    @contratospersona = @contratosperprestamo.contratospersona
    respond_to { |format| format.js }
  end

  def create
    @contratospersona  = Contratospersona.find(params[:contratospersona_id])
    @contratosperprestamo = Contratosperprestamo.new(contratosperprestamo_params)
    @contratosperprestamo.contratospersona_id = @contratospersona.id
    @contratosperprestamo.user_id = is_admin
    @contratosperprestamo.saldo = @contratosperprestamo.valor
    respond_to do |format|
      if @contratosperprestamo.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperprestamo } }
      end
    end
  end

  def update
    @contratosperprestamo = Contratosperprestamo.find(params[:id])
    @contratospersona = @contratosperprestamo.contratospersona
    respond_to do |format|
      if @contratosperprestamo.update(contratosperprestamo_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperprestamo } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosperprestamo.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosperprestamo
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratosperprestamo = Contratosperprestamo.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosperprestamo_params
    params.require(:contratosperprestamo).permit!
  end
end
