class ContratosactividadesController < ApplicationController
  before_action :set_contratosactividad, only: [:show, :destroy]

  def index
    @contratosactividades = Contratosactividad.all
  end

  def seleccionar
    eje = Contratosactejecucion.new
    eje.contratosactividad_id = params[:contratosactividad_id]
    eje.contratosnodo_id = params[:contratosnodo_id]
    eje.contratossede_id = Contratosnodo.find(params[:contratosnodo_id]).contratossede_id
    eje.user_id = is_admin
    eje.realizada = 'SI'
    eje.save
    params[:a] = params[:contratosactividad_id]
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosactividad.find(params[:active_id]) if params[:active_id].present?
    @contrato = Contrato.find(params[:contrato_id])
    @contratosactividad = Contratosactividad.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosactividad.find(params[:active_id]) if params[:active_id].present?
    @contratosactividad = Contratosactividad.find(params[:id])
    @contrato = @contratosactividad.contrato
    respond_to { |format| format.js }
  end

  def create
    @contrato  = Contrato.find(params[:contrato_id])
    @contratosactividad = Contratosactividad.new(contratosactividad_params)
    @contratosactividad.contrato_id = @contrato.id
    @contratosactividad.user_id = is_admin
    respond_to do |format|
      if @contratosactividad.save
        ActiveRecord::Base.connection.execute("CALL prc_ordenactividades(#{@contrato.id})")
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosactividad } }
      end
    end
  end

  def update
    @contratosactividad = Contratosactividad.find(params[:id])
    @contratosactividad.user_act = is_admin
    @contrato = @contratosactividad.contrato
    respond_to do |format|
      if @contratosactividad.update(contratosactividad_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosactividad } }
      end
    end
  end

  def ver
    @contratosactejecuciones = Contratosactejecucion.where(["user_id= #{is_admin} and date(created_at) = date(now()) "]).order("id desc")
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosactividad.destroy
  end

  def edit2
    @contratosactividad = Contratosactividad.find(params[:id])
    @contrato  = Contrato.find(@contratosactividad.contrato_id)
  end

  def update2
    @contratosactividad = Contratosactividad.find(params[:id])
    @contratosactividad.user_act = is_admin
    respond_to do |format|
      if @contratosactividad.update(contratosactividad_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosactividad } }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosactividad
    @contrato = Contrato.find(params[:contrato_id])
    @contratosactividad = Contratosactividad.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosactividad_params
    params.require(:contratosactividad).permit!
  end
end
