class ContratosperdescuentosController < ApplicationController
  before_action :set_contratosperdescuento, only: [:show, :destroy]

  def index
    @contratosperdescuentos = Contratosperdescuento.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosperdescuento.find(params[:active_id]) if params[:active_id].present?
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratosperdescuento = Contratosperdescuento.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosperdescuento.find(params[:active_id]) if params[:active_id].present?
    @contratosperdescuento = Contratosperdescuento.find(params[:id])
    @contratospersona = @contratosperdescuento.contratospersona
    respond_to { |format| format.js }
  end

  def create
    @contratospersona  = Contratospersona.find(params[:contratospersona_id])
    @contratosperdescuento = Contratosperdescuento.new(contratosperdescuento_params)
    @contratosperdescuento.contratospersona_id = @contratospersona.id
    @contratosperdescuento.user_id = is_admin
    respond_to do |format|
      if @contratosperdescuento.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperdescuento } }
      end
    end
  end

  def update
    @contratosperdescuento = Contratosperdescuento.find(params[:id])
    @contratospersona = @contratosperdescuento.contratospersona
    respond_to do |format|
      if @contratosperdescuento.update(contratosperdescuento_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperdescuento } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosperdescuento.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosperdescuento
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratosperdescuento = Contratosperdescuento.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosperdescuento_params
    params.require(:contratosperdescuento).permit!
  end
end
