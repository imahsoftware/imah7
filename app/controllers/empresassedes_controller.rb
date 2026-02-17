class EmpresassedesController < ApplicationController
  before_action :set_empresassede, only: [:show, :destroy]

  def index
    @empresassedes = Empresassede.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Empresassede.find(params[:active_id]) if params[:active_id].present?
    @empresa = Empresa.find(params[:empresa_id])
    @empresassede = Empresassede.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Empresassede.find(params[:active_id]) if params[:active_id].present?
    @empresassede = Empresassede.find(params[:id])
    @empresa = @empresassede.empresa
    respond_to { |format| format.js }
  end

  def create
    @empresa  = Empresa.find(params[:empresa_id])
    @empresassede = Empresassede.new(empresassede_params)
    @empresassede.empresa_id = @empresa.id
    @empresassede.user_id = is_admin
    respond_to do |format|
      if @empresassede.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @empresassede } }
      end
    end
  end

  def update
    @empresassede = Empresassede.find(params[:id])
    @empresa = @empresassede.empresa
    respond_to do |format|
      if @empresassede.update(empresassede_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @empresassede } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @empresassede.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_empresassede
    @empresa = Empresa.find(params[:empresa_id])
    @empresassede = Empresassede.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def empresassede_params
    params.require(:empresassede).permit!
  end
end
