class ContratosprefcreditosController < ApplicationController
  before_action :set_contratosprefcredito, only: [:show, :destroy]
  layout :set_layout

  def index
    @contratosprefcreditos = Contratosprefcredito.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosprefcredito.find(params[:active_id]) if params[:active_id].present?
    @contrato = Contrato.find(params[:contrato_id])
    @contratosprefcredito = Contratosprefcredito.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosprefcredito.find(params[:active_id]) if params[:active_id].present?
    @contratosprefcredito = Contratosprefcredito.find(params[:id])
    @contrato = @contratosprefcredito.contrato
    respond_to { |format| format.js }
  end

  def create
    @contrato  = Contrato.find(params[:contrato_id])
    @contratosprefcredito = Contratosprefcredito.new(contratosprefcredito_params)
    @contratosprefcredito.contrato_id = @contrato.id
    @contratosprefcredito.user_id = is_admin
    respond_to do |format|
      if @contratosprefcredito.save
        ActiveRecord::Base.connection.execute("CALL prc_prefact_saldos(#{@contratosprefcredito.contratosprefactura_id})")
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosprefcredito } }
      end
    end
  end

  def update
    @contratosprefcredito = Contratosprefcredito.find(params[:id])
    @contrato = @contratosprefcredito.contrato
    respond_to do |format|
      if @contratosprefcredito.update(contratosprefcredito_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosprefcredito } }
      end
    end
  end

  def destroy
    flash['danger'] = 'Eliminado correctamente'
    idprefac = @contratosprefcredito.contratosprefactura_id
    @contratosprefcredito.destroy
    ActiveRecord::Base.connection.execute("CALL prc_prefact_saldos(#{idprefac})")
  end

  def visualizar
    @contratosprefcredito = Contratosprefcredito.find(params[:id])
    @contrato = @contratosprefcredito.contrato
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
  def set_contratosprefcredito
    @contrato = Contrato.find(params[:contrato_id])
    @contratosprefcredito = Contratosprefcredito.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosprefcredito_params
    params.require(:contratosprefcredito).permit!
  end
end
