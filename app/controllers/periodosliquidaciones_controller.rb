class PeriodosliquidacionesController < ApplicationController
  before_action :set_periodosliquidacion, only: [:show, :edit, :update, :destroy]

  def checkaccess
    return is_permit('periodosliquidaciones')
  end

  def showinfo
    @ruta = params[:ruta]
    @periodo = params[:periodo].to_s
    @datos = Contratospernomina.joins(:contrato, :contratosgrupo)
                      .select("(select autobuscar from contratospersonas where id = contratospernominas.contratospersona_id) nombreempleado,
                                                        contratos.nro_contrato,
                                                        (select autobuscar from empresas where id = contratos.empresa_id) identnombre,
                                                        contratosgrupos.descripcion, contratospernominas.estado, contratospernominas.id, contratospernominas.contratospersona_id,
                                                        (SELECT CONCAT(inicio,' - ',fin) FROM periodosliquidaciones where id = contratospernominas.periodosliquidacion_id) periodoliq")
                      .where(["manual = 'SI' and periodosliquidacion_id = #{@periodo}"])
                      .order("contratospernominas.id desc")
  end

  def index
    @periodosliquidaciones = Periodosliquidacion.order("inicio asc")
    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Periodosliquidacion.find(params[:active_id]) if params[:active_id].present?
    @periodosliquidacion = Periodosliquidacion.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Periodosliquidacion.find(params[:active_id]) if params[:active_id].present?
    @periodosliquidacion = Periodosliquidacion.find(params[:id])
    respond_to { |format| format.js }
  end

  def create
    @periodosliquidacion = Periodosliquidacion.new(periodosliquidacion_params)
    respond_to do |format|
      if @periodosliquidacion.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @periodosliquidacion } }
      end
    end
  end

  def update
    respond_to do |format|
      if @periodosliquidacion.update(periodosliquidacion_params)
        #ActiveRecord::Base.connection.execute("CALL prc_mantenimiento()")
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @periodosliquidacion } }
      end
    end
  end

  def destroy
    @periodosliquidacion.destroy
    flash['success'] = 'Eliminado con Exito'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_periodosliquidacion
    @periodosliquidacion = Periodosliquidacion.find(params[:id])
    @is_auth_c_periodosliquidacion = is_auth_c('periodosliquidacion')
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def periodosliquidacion_params
    params.require(:periodosliquidacion).permit!
  end
end