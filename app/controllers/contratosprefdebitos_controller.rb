class ContratosprefdebitosController < ApplicationController
  before_action :set_contratosprefdebito, only: [:show, :destroy]
  layout :set_layout

  def index
    @contratosprefdebitos = Contratosprefdebito.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosprefdebito.find(params[:active_id]) if params[:active_id].present?
    @contrato = Contrato.find(params[:contrato_id])
    @contratosprefdebito = Contratosprefdebito.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosprefdebito.find(params[:active_id]) if params[:active_id].present?
    @contratosprefdebito = Contratosprefdebito.find(params[:id])
    @contrato = @contratosprefdebito.contrato
    respond_to { |format| format.js }
  end

  def create
    @contrato  = Contrato.find(params[:contrato_id])
    @contratosprefdebito = Contratosprefdebito.new(contratosprefdebito_params)
    @contratosprefdebito.contrato_id = @contrato.id
    @contratosprefdebito.user_id = is_admin
    respond_to do |format|
      if @contratosprefdebito.save
        ActiveRecord::Base.connection.execute("CALL prc_prefact_saldos(#{@contratosprefdebito.contratosprefactura_id})")
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosprefdebito } }
      end
    end
  end

  def update
    @contratosprefdebito = Contratosprefdebito.find(params[:id])
    @contrato = @contratosprefdebito.contrato
    respond_to do |format|
      if @contratosprefdebito.update(contratosprefdebito_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosprefdebito } }
      end
    end
  end

  def destroy
    flash['danger'] = 'Eliminado correctamente'
    idprefac = @contratosprefdebito.contratosprefactura_id
    @contratosprefdebito.destroy
    ActiveRecord::Base.connection.execute("CALL prc_prefact_saldos(#{idprefac})")
  end

  def visualizar
    @contratosprefdebito = Contratosprefdebito.find(params[:id])
    @contrato = @contratosprefdebito.contrato
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
  def set_contratosprefdebito
    @contrato = Contrato.find(params[:contrato_id])
    @contratosprefdebito = Contratosprefdebito.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosprefdebito_params
    params.require(:contratosprefdebito).permit!
  end
end
