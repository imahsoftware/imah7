class ContratosmodificacionesController < ApplicationController
  before_action :set_contratosmodificacion, only: [:show, :destroy]

  def index
    @contratosmodificaciones = Contratosmodificacion.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosmodificacion.find(params[:active_id]) if params[:active_id].present?
    @contrato = Contrato.find(params[:contrato_id])
    @contratosmodificacion = Contratosmodificacion.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosmodificacion.find(params[:active_id]) if params[:active_id].present?
    @contratosmodificacion = Contratosmodificacion.find(params[:id])
    @contrato = @contratosmodificacion.contrato
    respond_to { |format| format.js }
  end

  def create
    @contrato  = Contrato.find(params[:contrato_id])
    @contratosmodificacion = Contratosmodificacion.new(contratosmodificacion_params)
    @contratosmodificacion.contrato_id = @contrato.id
    @contratosmodificacion.user_id = is_admin
    respond_to do |format|
      if @contratosmodificacion.save
        flash[:notice] = "#{t :notice_crea_msj}"
        ActiveRecord::Base.connection.execute("CALL prc_calculomodificacion(#{@contrato.id})")
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosmodificacion } }
      end
    end
  end

  def update
    @contratosmodificacion = Contratosmodificacion.find(params[:id])
    @contratosmodificacion.user_act = is_admin
    @contrato = @contratosmodificacion.contrato
    respond_to do |format|
      if @contratosmodificacion.update(contratosmodificacion_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        ActiveRecord::Base.connection.execute("CALL prc_calculomodificacion(#{@contrato.id})")
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosmodificacion } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosmodificacion.destroy
    ActiveRecord::Base.connection.execute("CALL prc_calculomodificacion(#{@contratosmodificacion.contrato_id})")
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosmodificacion
    @contrato = Contrato.find(params[:contrato_id])
    @contratosmodificacion = Contratosmodificacion.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosmodificacion_params
    params.require(:contratosmodificacion).permit!
  end
end
