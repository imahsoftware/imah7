class VisitascompromisosController < ApplicationController
  before_action :set_visitascompromiso, only: [:show, :destroy]

  def index
    @visitascompromisos = Visitascompromiso.all
  end

  def documento
    @visitasdoc = Visitasdoc.new
    @visitascompromiso = Visitascompromiso.find(params[:id])
    @visita = @visitascompromiso.visita
  end

  def show
    respond_to { |format| format.js }
  end



  def show_detalle
    @ruta = params[:ruta]
    @fecha = params[:fecha]
  end

  def compromisos
    @visitascompromiso = Visitascompromiso.find(params[:id])
    @visita = @visitascompromiso.visita
    @identnombre = params[:identnombre]
    @nro_contrato = params[:nro_contrato]
    @userVisita = params[:userVisita]
  end

  def new
    @active_record = Visitascompromiso.find(params[:active_id]) if params[:active_id].present?
    @visita = Visita.find(params[:visita_id])
    @visitascompromiso = Visitascompromiso.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Visitascompromiso.find(params[:active_id]) if params[:active_id].present?
    @visitascompromiso = Visitascompromiso.find(params[:id])
    @visita = @visitascompromiso.visita
    respond_to { |format| format.js }
  end

  def create
    @visita = Visita.find(params[:visita_id])
    @visitascompromiso = Visitascompromiso.new(visitascompromiso_params)
    @visitascompromiso.visita_id = @visita.id
    @visitascompromiso.user_id = is_admin
    respond_to do |format|
      if @visitascompromiso.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @visitascompromiso } }
      end
    end
  end

  def update
    @ruta = params[:ruta] rescue nil
    @userVisita = Visita.find(params[:userVisita]) rescue nil
    @visitascompromiso = Visitascompromiso.find(params[:id])
    @visita = @visitascompromiso.visita
    @visitascompromiso.valida_campo(@ruta)

    respond_to do |format|
      if @visitascompromiso.update(visitascompromiso_params)
        if @visitascompromiso.obs_atencion.present?
          @visitascompromiso.fecha_atencion = Time.now
          @visitascompromiso.user_atencion = is_admin
          @visitascompromiso.estado = 'FINALIZADO'
          @visitascompromiso.save(validate: false)
        end
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @visitascompromiso } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @visitascompromiso.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_visitascompromiso
    @visita = Visita.find(params[:visita_id])
    @visitascompromiso = Visitascompromiso.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def visitascompromiso_params
    params.require(:visitascompromiso).permit!
  end
end
