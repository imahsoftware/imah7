class ContratossedesController < ApplicationController
  before_action :set_contratossede, only: [:show, :destroy]

  def index
    @contratossedes = Contratossede.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratossede.find(params[:active_id]) if params[:active_id].present?
    @contrato = Contrato.find(params[:contrato_id])
    @contratossede = Contratossede.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratossede.find(params[:active_id]) if params[:active_id].present?
    @contratossede = Contratossede.find(params[:id])
    @contrato = @contratossede.contrato
    respond_to { |format| format.js }
  end

  def create
    @contrato  = Contrato.find(params[:contrato_id])
    @contratossede = Contratossede.new(contratossede_params)
    @contratossede.contrato_id = @contrato.id
    @contratossede.user_id = is_admin
    respond_to do |format|
      if @contratossede.save
        ActiveRecord::Base.connection.execute("CALL prc_ordensedes(#{@contrato.id})")
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratossede } }
      end
    end
  end

  def update
    @contratossede = Contratossede.find(params[:id])
    @contratossede.user_act = is_admin
    @contrato = @contratossede.contrato
    respond_to do |format|
      if @contratossede.update(contratossede_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratossede } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratossede.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratossede
    @contrato = Contrato.find(params[:contrato_id])
    @contratossede = Contratossede.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratossede_params
    params.require(:contratossede).permit!
  end
end
