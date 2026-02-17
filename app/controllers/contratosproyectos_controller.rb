class ContratosproyectosController < ApplicationController
  before_action :set_contratosproyecto, only: [:show, :destroy, :abrirsedes]

  def index
    @contratosproyectos = Contratosproyecto.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosproyecto.find(params[:active_id]) if params[:active_id].present?
    @contrato = Contrato.find(params[:contrato_id])
    @contratosproyecto = Contratosproyecto.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosproyecto.find(params[:active_id]) if params[:active_id].present?
    @contratosproyecto = Contratosproyecto.find(params[:id])
    @contrato = @contratosproyecto.contrato
    respond_to { |format| format.js }
  end

  def create
    @contrato  = Contrato.find(params[:contrato_id])
    @contratosproyecto = Contratosproyecto.new(contratosproyecto_params)
    @contratosproyecto.contrato_id = @contrato.id
    @contratosproyecto.user_id = is_admin
    respond_to do |format|
      if @contratosproyecto.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosproyecto } }
      end
    end
  end

  def update
    @contratosproyecto = Contratosproyecto.find(params[:id])
    @contratosproyecto.user_act = is_admin
    @contrato = @contratosproyecto.contrato
    respond_to do |format|
      if @contratosproyecto.update(contratosproyecto_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosproyecto } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosproyecto.destroy
  end

  def recalcular

    ActiveRecord::Base.connection.execute("UPDATE contratosproyectos SET usado = 0, saldo = valor WHERE contrato_id = #{params[:id]}")

    Contratossolicitud.where(["contrato_id = #{params[:id]} and estado != 'PENDIENTE'"]).each do |a|
      ActiveRecord::Base.connection.execute("CALL prc_pruebarecursos_unif(#{a.contrato_id},#{a.user_id},#{a.id})")
    end
    flash['success'] = 'Recalculo realizado!'
    redirect_to edit_contrato_path(etapa: "H", id: params[:id])
  end

  # Descripcion: Metodo modal que abre una ventana para asociar las sedes
  # Fecha Creacion: 29-Junio-2022
  # Autor: AFP
  def abrirsedes; end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosproyecto
    @contrato = Contrato.find(params[:contrato_id])
    @contratosproyecto = Contratosproyecto.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosproyecto_params
    params.require(:contratosproyecto).permit!
  end
end
