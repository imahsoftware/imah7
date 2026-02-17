class ContratosseccionesController < ApplicationController
  before_action :set_contratosseccion, only: [:show, :destroy]

  def index
    @contratossecciones = Contratosseccion.all
  end

  def show
    respond_to { |format| format.js }
  end

  def search
    @descripcion = params[:descripcion2]
    @contrato = Contrato.find(params[:contrato_id])
    @contratossecciones = Contratosseccion.where("(descripcion2 like '%#{@descripcion.to_s}%' or descripcion like '%#{@descripcion.to_s}%') and contrato_id = #{@contrato.id}").paginate(:page => params[:contratossecciones], :per_page => 10).order("id desc")
  end

  def procesos
    @contrato = Contrato.find(params[:contrato_id])
    ActiveRecord::Base.connection.execute("CALL prc_seccionasociacion(-1);")
    redirect_to edit_contrato_path(@contrato.id)
  end

  def new
    @active_record = Contratosseccion.find(params[:active_id]) if params[:active_id].present?
    @contrato = Contrato.find(params[:contrato_id])
    @contratosseccion = Contratosseccion.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosseccion.find(params[:active_id]) if params[:active_id].present?
    @contratosseccion = Contratosseccion.find(params[:id])
    @contrato = @contratosseccion.contrato
    respond_to { |format| format.js }
  end

  def create
    @contrato = Contrato.find(params[:contrato_id])
    @contratosseccion = Contratosseccion.new(contratosseccion_params)
    @contratosseccion.contrato_id = @contrato.id
    @contratosseccion.user_id = is_admin
    respond_to do |format|
      if @contratosseccion.save
        Ejecucion.create(user_id: is_admin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO SMS',
                         controlador_metodo: "ContratosseccionesController.seccionasociacion(#{@contratosseccion.id},#{is_admin})", created_at: Time.now)
        #ActiveRecord::Base.connection.execute("CALL prc_seccionasociacion(#{@contratosseccion.id})")
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosseccion } }
      end
    end
  end

  def self.seccionasociacion(idSeccion,isAdmin)
    user = User.find(isAdmin)
    #if vcClase == 'B'
      ActiveRecord::Base.connection.execute("CALL prc_seccionasociacion(#{idSeccion})")
    #end
    mensaje = "ASEAR: Estimad@ #{user.nombre.capitalize rescue nil}, proceso de asociacion de Seccion - Finalizado (#{idSeccion})".html_safe
    Asearsms::SendsmsServices.new.send_sms_procesos(user.celular.to_s, mensaje)
  end

  def update
    @contratosseccion = Contratosseccion.find(params[:id])
    @contrato = @contratosseccion.contrato
    respond_to do |format|
      if @contratosseccion.update(contratosseccion_params)
        Ejecucion.create(user_id: is_admin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO SMS',
                         controlador_metodo: "ContratosseccionesController.seccionasociacion(#{@contratosseccion.id},#{is_admin})", created_at: Time.now)
        #ActiveRecord::Base.connection.execute("CALL prc_seccionasociacion(#{@contratosseccion.id})")
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosseccion } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosseccion.destroy
  end

  def secuser
    @contratosseccion = Contratosseccion.find(params[:id])
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contratosseccion
    @contrato = Contrato.find(params[:contrato_id])
    @contratosseccion = Contratosseccion.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosseccion_params
    params.require(:contratosseccion).permit!
  end
end
