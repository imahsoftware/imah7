class ContratosotrosController < ApplicationController
  before_action :set_contratosotro, only: [:show, :destroy]

  def index
    @contratosotros = Contratosotro.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosotro.find(params[:active_id]) if params[:active_id].present?
    @contrato = Contrato.find(params[:contrato_id])
    @contratosotro = Contratosotro.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosotro.find(params[:active_id]) if params[:active_id].present?
    @contratosotro = Contratosotro.find(params[:id])
    @contrato = @contratosotro.contrato
    respond_to { |format| format.js }
  end

  def create
    @contrato  = Contrato.find(params[:contrato_id])
    @contratosotro = Contratosotro.new(contratosotro_params)
    @contratosotro.contrato_id = @contrato.id
    @contratosotro.user_id = is_admin
    respond_to do |format|
      if @contratosotro.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosotro } }
      end
    end
  end

  def update
    @contratosotro = Contratosotro.find(params[:id])
    @contratosotro.user_act = is_admin
    @contrato = @contratosotro.contrato
    respond_to do |format|
      if @contratosotro.update(contratosotro_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosotro } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosotro.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosotro
    @contrato = Contrato.find(params[:contrato_id])
    @contratosotro = Contratosotro.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosotro_params
    params.require(:contratosotro).permit!
  end
end
