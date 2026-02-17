class ContratoscargosController < ApplicationController
  before_action :set_contratoscargo, only: [:show, :destroy]

  def index
    @contratoscargos = Contratoscargo.all
  end

  def show
    respond_to { |format| format.js }
  end

  def cargosnota
    @contratoscargo = Contratoscargo.find(params[:id])
  end

  def cargosdetalle
    @contratoscargo = Contratoscargo.find(params[:id])
  end

  def actividades
    @contratoscargo = Contratoscargo.find(params[:id])
  end

  def cargospersona
    @contratoscargo = Contratoscargo.find(params[:id])
  end

  def actividad
    @contratoscargo = Contratoscargo.find(params[:id])
  end

  def new
    @active_record = Contratoscargo.find(params[:active_id]) if params[:active_id].present?
    @contrato = Contrato.find(params[:contrato_id])
    @contratoscargo = Contratoscargo.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratoscargo.find(params[:active_id]) if params[:active_id].present?
    @contratoscargo = Contratoscargo.find(params[:id])
    @contrato = @contratoscargo.contrato
    respond_to { |format| format.js }
  end

  def create
    @contrato  = Contrato.find(params[:contrato_id])
    @contratoscargo = Contratoscargo.new(contratoscargo_params)
    @contratoscargo.contrato_id = @contrato.id
    @contratoscargo.user_id = is_admin
    @contratoscargo.requiere_dotacion = 'NO'
    respond_to do |format|
      if @contratoscargo.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratoscargo } }
      end
    end
  end

  def update
    @contratoscargo = Contratoscargo.find(params[:id])
    @contratoscargo.user_act = is_admin
    @contrato = @contratoscargo.contrato
    respond_to do |format|
      if @contratoscargo.update(contratoscargo_params)
        Ejecucion.create(user_id: is_admin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO SMS',
                         controlador_metodo: "DatasController.ejecutacontrato(-1)", created_at: Time.now)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratoscargo } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratoscargo.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratoscargo
    @contrato = Contrato.find(params[:contrato_id])
    @contratoscargo = Contratoscargo.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratoscargo_params
    params.require(:contratoscargo).permit!
  end
end
