class ContratoscaparesultadosController < ApplicationController
  before_action :set_contratoscaparesultado, only: [:show, :destroy]

  def update_respuesta
    @contratoscaparesultado = Contratoscaparesultado.find(params[:id])
    resultado = Capacitacionevaopcion.find(params[:opcion_id])
    @contratoscaparesultado.update(respuesta: params[:opcion_id], resultado: resultado.respuesta)
    if Contratoscaparesultado.where(contrato_id: @contratoscaparesultado.contrato_id, contratoscapapersona_id: @contratoscaparesultado.contratoscapapersona_id, capacitacion_id: @contratoscaparesultado.capacitacion_id, respuesta: nil).count.zero?
      @mostrarboton = true
    else
      @mostrarboton = false
    end
    render json: { status: 'success', message: 'Respuesta actualizada correctamente', mostrarboton: @mostrarboton }
  end


  def index
    @contratoscaparesultados = Contratoscaparesultado.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratoscaparesultado.find(params[:active_id]) if params[:active_id].present?
    @capacitacion = Capacitacion.find(params[:capacitacion_id])
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratoscaparesultado.find(params[:active_id]) if params[:active_id].present?
    @contratoscaparesultado = Contratoscaparesultado.find(params[:id])
    @capacitacion = @contratoscaparesultado.capacitacion
    respond_to { |format| format.js }
  end

  def create
    @capacitacion  = Capacitacion.find(params[:capacitacion_id])
    @contratoscaparesultado = Contratoscaparesultado.new(contratoscaparesultado_params)
    @contratoscaparesultado.capacitacion_id = @capacitacion.id
    respond_to do |format|
      if @contratoscaparesultado.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratoscaparesultado } }
      end
    end
  end

  def update
    @contratoscaparesultado = Contratoscaparesultado.find(params[:id])
    @capacitacion = @contratoscaparesultado.capacitacion
    respond_to do |format|
      if @contratoscaparesultado.update(contratoscaparesultado_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratoscaparesultado } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratoscaparesultado.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratoscaparesultado
    @capacitacion = Capacitacion.find(params[:capacitacion_id])
    @contratoscaparesultado = Contratoscaparesultado.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratoscaparesultado_params
    params.require(:contratoscaparesultado).permit!
  end
end