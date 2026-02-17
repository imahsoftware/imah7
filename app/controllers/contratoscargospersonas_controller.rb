class ContratoscargospersonasController < ApplicationController
  before_action :set_contratoscargospersona, only: [:show, :destroy, :new]

  def index
    @contratoscargospersonas = Contratoscargospersona.all
  end

  def show
    respond_to { |format| format.js }
  end

  def cambioestado
    @contratoscargospersona = Contratoscargospersona.find(params[:id])
    @contratoscargospersona.estado = params[:estado]
    @contratoscargospersona.fecha_estado= Time.now
    @contratoscargospersona.save
    redirect_to redirect_to index_convocatorias_migraciones_path
  end

  def new
    @active_record = Contratoscargospersona.find(params[:active_id]) if params[:active_id].present?
    @contratoscargo = Contratoscargo.find(params[:contratoscargo_id])
    @contratoscargospersona = Contratoscargospersona.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratoscargospersona.find(params[:active_id]) if params[:active_id].present?
    @contratoscargospersona = Contratoscargospersona.find(params[:id])
    @contratoscargo = @contratoscargospersona.contratoscargo
    respond_to { |format| format.js }
  end

  def create
    @contratoscargo  = Contratoscargo.find(params[:contratoscargo_id])
    @contratoscargospersona = Contratoscargospersona.new(contratoscargospersona_params)
    @contratoscargospersona.contratoscargo_id = @contratoscargo.id
    @contratoscargospersona.user_id = is_admin
    @contratoscargospersona.estado = 'PENDIENTE'
    respond_to do |format|
      if @contratoscargospersona.save
        #MNotificacion SMS
        Ejecucion.create(user_id: is_admin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO SMS',
                         controlador_metodo: "DatasController.notificacionvacante(#{@contratoscargospersona.id})", created_at: Time.now)
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratoscargospersona } }
      end
    end
  end

  def update
    @contratoscargospersona = Contratoscargospersona.find(params[:id])
    @contratoscargo = @contratoscargospersona.contratoscargo
    respond_to do |format|
      if @contratoscargospersona.update(contratoscargospersona_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratoscargospersona } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratoscargospersona.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratoscargospersona
    @contratoscargo = Contratoscargo.find(params[:contratoscargo_id])
    @contratoscargospersona = Contratoscargospersona.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratoscargospersona_params
    params.require(:contratoscargospersona).permit!
  end
end
