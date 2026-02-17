class ContratosimagenesController < ApplicationController
  before_action :set_contratosimagen, only: [:show, :destroy]

  def index
    @contratosimagenes = Contratosimagen.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosimagen.find(params[:active_id]) if params[:active_id].present?
    @contrato = Contrato.find(params[:contrato_id])
    @contratosimagen = Contratosimagen.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosimagen.find(params[:active_id]) if params[:active_id].present?
    @contratosimagen = Contratosimagen.find(params[:id])
    @contrato = @contratosimagen.contrato
    respond_to { |format| format.js }
  end

  def create
    @contrato  = Contrato.find(params[:contrato_id])
    @contratosimagen = Contratosimagen.new(contratosimagen_params)
    @contratosimagen.contrato_id = @contrato.id
    @contratosimagen.user_id = is_admin
    respond_to do |format|
      if @contratosimagen.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosimagen } }
      end
    end
  end

  def update
    @contratosimagen = Contratosimagen.find(params[:id])
    @contrato = @contratosimagen.contrato
    respond_to do |format|
      if @contratosimagen.update(contratosimagen_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosimagen } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosimagen.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosimagen
    @contrato = Contrato.find(params[:contrato_id])
    @contratosimagen = Contratosimagen.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosimagen_params
    params.require(:contratosimagen).permit!
  end
end
