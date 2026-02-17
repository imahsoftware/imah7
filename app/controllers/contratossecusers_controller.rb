class ContratossecusersController < ApplicationController
  before_action :set_contratossecuser, only: [:show, :destroy, :new]

  def index
    @contratossecusers = Contratossecuser.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratossecuser.find(params[:active_id]) if params[:active_id].present?
    @contratosseccion = Contratosseccion.find(params[:contratosseccion_id])
    @contratossecuser = Contratossecuser.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratossecuser.find(params[:active_id]) if params[:active_id].present?
    @contratossecuser = Contratossecuser.find(params[:id])
    @contratosseccion = @contratossecuser.contratosseccion
    respond_to { |format| format.js }
  end

  def create
    @contratosseccion  = Contratosseccion.find(params[:contratosseccion_id])
    @contratossecuser = Contratossecuser.new(contratossecuser_params)
    @contratossecuser.contratosseccion_id = @contratosseccion.id
    @contratossecuser.userreg_id = is_admin
    respond_to do |format|
      if @contratossecuser.save
        Ejecucion.create(user_id: is_admin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO SMS',
                         controlador_metodo: "ContratosseccionesController.seccionasociacion(#{@contratosseccion.id},#{is_admin})", created_at: Time.now)
        #ActiveRecord::Base.connection.execute("CALL prc_seccionasociacion(#{@contratosseccion.id})")
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratossecuser } }
      end
    end
  end

  def update
    @contratossecuser = Contratossecuser.find(params[:id])
    @contratosseccion = @contratossecuser.contratosseccion
    respond_to do |format|
      if @contratossecuser.update(contratossecuser_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratossecuser } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    idseccion = @contratossecuser.contratosseccion_id
    @contratossecuser.destroy
    Ejecucion.create(user_id: is_admin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO SMS',
                     controlador_metodo: "ContratosseccionesController.seccionasociacion(#{idseccion},#{is_admin})", created_at: Time.now)
    #ActiveRecord::Base.connection.execute("CALL prc_seccionasociacion(#{idseccion})")
  end

  private
  def set_contratossecuser
    @contratosseccion = Contratosseccion.find(params[:contratosseccion_id])
    @contratossecuser = Contratossecuser.find(params[:id]) if params[:id]
  end

  def contratossecuser_params
    params.require(:contratossecuser).permit!
  end
end
