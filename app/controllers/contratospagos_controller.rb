class ContratospagosController < ApplicationController
  before_action :set_contratospago, only: [:show, :destroy]
  layout :set_layout

  def index
    @contratospagos = Contratospago.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratospago.find(params[:active_id]) if params[:active_id].present?
    @contrato = Contrato.find(params[:contrato_id])
    @contratospago = Contratospago.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratospago.find(params[:active_id]) if params[:active_id].present?
    @contratospago = Contratospago.find(params[:id])
    @contrato = @contratospago.contrato
    respond_to { |format| format.js }
  end

  def create
    @contrato  = Contrato.find(params[:contrato_id])
    @contratospago = Contratospago.new(contratospago_params)
    @contratospago.contrato_id = @contrato.id
    @contratospago.user_id = is_admin
    respond_to do |format|
      if @contratospago.save
        ActiveRecord::Base.connection.execute("CALL prc_prefact_saldos(#{@contratospago.contratosprefactura_id})")
        ActiveRecord::Base.connection.execute("CALL prc_contratospagos_consecutivo(#{@contratospago.id})")
        ActiveRecord::Base.connection.execute("CALL prc_ajustesaldos()")
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @contratospago } }
      end
    end
  end

  def update
    @contratospago = Contratospago.find(params[:id])
    @contratospago.user_act = is_admin
    @contrato = @contratospago.contrato
    respond_to do |format|
      if @contratospago.update(contratospago_params)
        ActiveRecord::Base.connection.execute("CALL prc_prefact_saldos(#{@contratospago.contratosprefactura_id})")
        ActiveRecord::Base.connection.execute("CALL prc_ajustesaldos()")
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratospago } }
      end
    end
  end

  def destroy
    flash['danger'] = 'Eliminado correctamente'
    idprefac = @contratospago.contratosprefactura_id
    @contratospago.destroy
    ActiveRecord::Base.connection.execute("CALL prc_prefact_saldos(#{idprefac})")
  end

  def visualizar
    @contratospago = Contratospago.find(params[:id])
    @contrato = @contratospago.contrato
  end

  private

  def set_layout
    if ['show','visualizar','mostrare','insumosinforme'].include?(action_name)
      'blank'
    else
      "application_contratos"
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_contratospago
    @contrato = Contrato.find(params[:contrato_id])
    @contratospago = Contratospago.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratospago_params
    params.require(:contratospago).permit!
  end
end
