class SolicitudesretirosController < ApplicationController
  before_action :set_solicitudesretiro, only: [:show, :edit, :update, :destroy]
  layout :set_layout

  def search
    @solicitudesretiros = Solicitudesretiro.joins(:contrato, :contratospersona, :contratosgrupo)
                                           .select("contratospersonas.autobuscar, (select autobuscar from empresas where id = contratos.empresa_id) identnombre,
                                                       contratos.nro_contrato, contratos.id idcontrato,
                                                       contratosgrupos.descripcion, contratosgrupos.termino,
                                                       (select nombre from users where id = solicitudesretiros.user_id) usernombre,
                                                       (select nombre from users where id = solicitudesretiros.user_aprobacion) useraprobanombre,
                                                       (case when solicitudesretiros.user_aprobacion is null then 'PENDIENTE'
                                                            when (solicitudesretiros.consecutivo is not null and solicitudesretiros.estado_final is null) then 'APROBADAS PARA PAGO'
                                                            when (solicitudesretiros.consecutivo is not null and solicitudesretiros.estado_final is not null) then 'PAGADAS'
                                                            when (solicitudesretiros.user_aprobacion is not null and solicitudesretiros.user_liquidacion is null and solicitudesretiros.consecutivo is null) then 'EN PROCESO'
                                                            end) estadoliquidacion,
                                                       solicitudesretiros.*")
                                           .where(["contratospersona_id in (select id from contratospersonas where autobuscar like '%%#{replacespace(params[:dato].to_s).to_s.upcase.strip}%%')"])
                                           .order("contratospersonas.identificacion asc")
  end

  def index
    @solicitudesretiros = Solicitudesretiro.all
  end

  def show
  end

  def evaluar
    if params[:e].to_s == 'PAGADO'
      @ruta = 'SI'
      @consecutivo = params[:consecutivo].to_s
      if @consecutivo.to_i > 0
        Solicitudesretiro.where(consecutivo: @consecutivo).update_all(estado_final: 'PAGADO', fecha_final: Time.now)
        Contratosperliquidacion.where(["contratosperfecha_id in (select contratosperfecha_id from solicitudesretiros where consecutivo = #{@consecutivo})"]).update_all(estado: 'PAGADO', updated_at: Time.now)
        #Contratosperliquidacion.where(["contratosperfecha_id in (select contratosperfecha_id from solicitudesretiros where consecutivo = #{@consecutivo})"]).each do |p|
        #  WsAportesController.nov_retiro(p.contratosperfecha_id, is_portafolio)
        #end
        Ejecucion.create(user_id: is_admin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO SMS',
                         controlador_metodo: "DatasController.consolidaliquidacion(#{@consecutivo})", created_at: Time.now)
      end
    elsif params[:e].to_s == 'DIVIDIRLOTE'
      @ruta = 'SI'
      @consecutivo = params[:consecutivo].to_s
      idContrato = params[:contrato_id].to_s
      if @consecutivo.to_i > 0 and idContrato.to_i > 0
        consec1 = Objeto.find_by_sql("SELECT max(consecutivo)+1 consecutivo from solicitudesretiros")[0].consecutivo.to_i rescue 0
        ActiveRecord::Base.connection.execute("UPDATE solicitudesretiros SET consecutivo = #{consec1}
                                               WHERE  consecutivo = #{@consecutivo} AND contratosperliquidacion_id IN (SELECT id FROM contratosperliquidaciones)
                                               AND    contrato_id != #{idContrato};")
      end
    else
      @solicitudesretiro = Solicitudesretiro.find(params[:id])
      if params[:e].to_s == 'APROBADA'
        @solicitudesretiro.user_aprobacion = is_admin
        @solicitudesretiro.fecha_aprobacion = Time.now
        #Contratosperfecha.where(contrato_id: @solicitudesretiro.contrato_id, contratospersona_id: @solicitudesretiro.contratospersona_id, contratosgrupo_id: @solicitudesretiro.contratosgrupo_id).update_all(fecha_fin: @solicitudesretiro.fecha, updated_at: Time.now)
        Contratosperfecha.where(id: @solicitudesretiro.contratosperfecha_id).update_all(fecha_fin: @solicitudesretiro.fecha, updated_at: Time.now)
        ActiveRecord::Base.connection.execute("CALL prc_liquidacion(#{@solicitudesretiro.contratosperfecha_id})")
        @solicitudesretiro.save(validate: false)
        Ejecucion.create(user_id: is_admin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO SMS', controlador_metodo: "DatasController.ejecutacontrato(-1)", created_at: Time.now)
      elsif params[:e].to_s == 'LIQUIDADA'
        @solicitudesretiro.user_liquidacion = is_admin
        @solicitudesretiro.fecha_liquidacion = Time.now
        @solicitudesretiro.consecutivo = is_consecutivolote
        @solicitudesretiro.save(validate: false)
        ActiveRecord::Base.connection.execute("CALL prc_consolidaliquidacion(#{@solicitudesretiro.contratosperliquidacion_id})")
      elsif params[:e].to_s == 'ELIMINAR'
        if @solicitudesretiro.contratosperliquidacion_id.to_s != ""
          ActiveRecord::Base.connection.execute("delete from contratosperliqnovedades where contratosperliquidacion_id = #{@solicitudesretiro.contratosperliquidacion_id}")
          ActiveRecord::Base.connection.execute("delete from contratosperliquidaciones where id = #{@solicitudesretiro.contratosperliquidacion_id}")
          ActiveRecord::Base.connection.execute("update contratosperfechas set fecha_fin = null where id = #{@solicitudesretiro.contratosperfecha_id}")
        end
        @solicitudesretiro.destroy
      end
    end
    respond_to do |format|
      flash['success'] = "Proceso Realizado"
      if params[:e].to_s == 'PAGADO' or params[:e].to_s == 'DIVIDIRLOTE'
        format.js { render inline: "location.reload();" }
      else
        format.js
      end
    end
  end

  def new
    @solicitudesretiro = Solicitudesretiro.new
    @solicitudesretiro.contrato_id = params[:contrato_id].to_i
    @solicitudesretiro.contratosgrupo_id = params[:contratosgrupo_id].to_i
    @solicitudesretiro.contratospersona_id = params[:contratospersona_id].to_i
    @solicitudesretiro.contratosperfecha_id = params[:contratosperfecha_id].to_i
  end

  def edit
  end

  def create
    @solicitudesretiro = Solicitudesretiro.new(solicitudesretiro_params)
    @solicitudesretiro.user_id = is_admin
    #idfecha = Contratosperfecha.where(contrato_id: @solicitudesretiro.contrato_id, contratospersona_id: @solicitudesretiro.contratospersona_id, contratosgrupo_id: @solicitudesretiro.contratosgrupo_id)[0].id
    #@solicitudesretiro.contratosperfecha_id = idfecha
    respond_to do |format|
      if @solicitudesretiro.save
        flash['success'] = "Creado con exito"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @solicitudesretiro } }
      end
    end
  end

  def update
    respond_to do |format|
      if @solicitudesretiro.update(solicitudesretiro_params)
        flash['success'] = "Actualizado con exito"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @solicitudesretiro } }
      end
    end
  end

  def destroy
    @solicitudesretiro.destroy
    flash['success'] = "Solicitud eliminada con exito"
    redirect_to contratospernominas_path
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_solicitudesretiro
    @solicitudesretiro = Solicitudesretiro.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def solicitudesretiro_params
    params.require(:solicitudesretiro).permit!
  end

  def set_layout
    if ['search'].include?(action_name)
      "consulta_carta_layouts"
    else
      'application_admin'
    end
  end
end
