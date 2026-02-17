class ContratosperfactsController < ApplicationController
  before_action :set_contratosperfact, only: [:show, :edit, :update, :destroy]

  def showinfo
    @ruta = params[:ruta]
    @periodo = params[:periodo].to_s
    @estado = params[:estado].to_s
    @datos = Contratosperfact.joins(:contrato, :contratosgrupo, :contratoscargo, :contratospersona)
                            .select("contratosperfacts.contrato_id, contratos.nro_contrato, contratosperfacts.id,
                                    contratospersonas.autobuscar,
                                    (select autobuscar from empresas where id = contratos.empresa_id) identnombre,
                                    contratosperfacts.contratosgrupo_id,
                                    contratosgrupos.descripcion,
                                    contratosgrupos.termino,
                                    contratoscargos.perfil,
                                    contratosperfacts.estado,
                                    contratosperfacts.created_at, contratosperfacts.user_id,
                                    (select autobuscar from empresas where id = (select empresa_id from contratos where id = contratosperfacts.oricontrato_id)) ori_identnombre,
                                    (select nro_contrato from contratos where id = contratosperfacts.oricontrato_id) ori_nro_contrato,
                                    (select descripcion from contratosgrupos where id = contratosperfacts.oricontratosgrupo_id) ori_descripcion,
                                    (select termino from contratosgrupos where id = contratosperfacts.oricontratosgrupo_id) ori_termino,
                                    (select perfil from contratoscargos where id = contratosperfacts.oricontratoscargo_id) ori_perfil,
                                    (select distinct 'X' from contratospernominas where contratosperfecha_id = contratosperfacts.contratosperfechanew) existenomina,
                                    (select distinct 'X' from contratosperimagenes where contratosperfecha_id = contratosperfacts.contratosperfecha_id
                                     and descripcion LIKE 'OTRO SI CAMBIO DE CENTRO DE TRABAJO%') existedoc_continuidad,
                                    (select username from users where id = contratosperfacts.user_id) username,
                                    contratosperfacts.tipo, contratosperfacts.contratospersona_id, contratosperfacts.contratosperfecha_id")
                            .where(["date_format(contratosperfacts.created_at,'%%Y-%%m') = '#{@periodo}'
                                     and contratosperfacts.estado = '#{@estado}'"])
                            .order("contratosperfacts.id desc")
  end

  def get_contratosperfact_contrato_id
    @contrato = params[:contratosperfact_contrato_id]
    @contratoscargos = Contratoscargo.where(["contrato_id = #{@contrato} and ifnull(disponibles,0) > 0"]) if @contrato
    @contratosgrupos = Contratosgrupo.where(contrato_id: @contrato) if @contrato
    respond_to { |format| format.js }
  end

  def index
    @contratosperfacts = Contratosperfact.all
  end

  def carta
    @contratosperfact = Contratosperfact.joins(:contrato, :contratosgrupo, :contratoscargo, :contratospersona)
                                        .select("contratosperfacts.contrato_id, contratos.nro_contrato,contratosperfacts.fecha_inicio, contratosperfacts.id,
                                                 (select logo from empresas where id = contratos.empresa_id) logo,
                                                 (select portafolio_id from empresas where id = contratos.empresa_id) portafolio_id,
                                                  contratospersonas.autobuscar,
                                                  contratospersonas.nombre_completo,
                                                  contratospersonas.identificacion,
                                                  (select autobuscar from empresas where id = contratos.empresa_id) identnombre,
                                                  (select nombre from empresas where id = contratos.empresa_id) empresanombre,
                                                  contratosperfacts.contratosgrupo_id,
                                                  contratosgrupos.descripcion,
                                                  contratosgrupos.termino,
                                                  contratoscargos.perfil,
                                                  contratoscargos.salario,
                                                  contratosperfacts.estado,
                                                  (select fecha_inicio from contratosperfechas where id = contratosperfacts.contratosperfecha_id) fecha_inicioc,
                                                  contratosperfacts.created_at, contratosperfacts.user_id,
                                                  (select autobuscar from empresas where id = (select empresa_id from contratos where id = contratosperfacts.oricontrato_id)) ori_identnombre,
                                                  (select nro_contrato from contratos where id = contratosperfacts.oricontrato_id) ori_nro_contrato,
                                                  (select descripcion from contratosgrupos where id = contratosperfacts.oricontratosgrupo_id) ori_descripcion,
                                                  (select termino from contratosgrupos where id = contratosperfacts.oricontratosgrupo_id) ori_termino,
                                                  (select perfil from contratoscargos where id = contratosperfacts.oricontratoscargo_id) ori_perfil,
                                                  contratosperfacts.tipo, contratosperfacts.contratosperfecha_id")
                                        .where(["contratosperfacts.id = #{params[:id]}"])[0]
    @logo = @contratosperfact.logo.to_s
    fname = "CartaTraslado_"+@contratosperfact.identificacion.to_s rescue nil
    respond_to do |format|
      format.pdf {render pdf: "#{fname}", template: "contratosperfacts/carta", encoding: "UTF-8", page_size: 'Letter',:margin => {top: 15, :bottom => 20, :left => 15,:right => 15}}
    end
  end

  def show
  end

  def evaluar
    if ['APROBADO','RECHAZADO'].include?(params[:e].to_s)
      contratosperfact = Contratosperfact.find(params[:id])
      contratosperfact.user_procesa = is_admin
      contratosperfact.fecha_procesa = Time.now
      contratosperfact.estado = params[:e].to_s
      contratosperfact.save
      if params[:e].to_s == 'APROBADO'
        ActiveRecord::Base.connection.execute("CALL prc_contratosperfact(#{contratosperfact.id})")
      end
    elsif ['ELIMINAR'].include?(params[:e].to_s)
      contratosperfact = Contratosperfact.find(params[:id])
      contratosperfact.destroy
    elsif ['REVERSAR'].include?(params[:e].to_s)
      contratosperfact = Contratosperfact.find(params[:id])
      ActiveRecord::Base.connection.execute("delete from contratosperfechas where id = #{contratosperfact.contratosperfechanew}")
      ActiveRecord::Base.connection.execute("update contratosperfechas set salario = null, fecha_fin = null,estado = 'ACTIVO', trasladado = 'NO' where id = #{contratosperfact.contratosperfecha_id}")
      contratosperfact.destroy
    end
    flash['success'] = "Proceso Realizado"
    redirect_to contratospernominas_path
  end

  def new
    @contratosperfact = Contratosperfact.new
    pf = Contratosperfecha.find(params[:contratosperfecha_id].to_i)
    @contratosperfact.oricontrato_id = pf.contrato_id
    @contratosperfact.oricontratosgrupo_id = pf.contratosgrupo_id
    @contratosperfact.oricontratoscargo_id = pf.contratoscargo_id
    @contratosperfact.contratospersona_id = pf.contratospersona_id
    @contratosperfact.contratosperfecha_id = pf.id
  end

  def edit
  end

  def create
    @contratosperfact = Contratosperfact.new(contratosperfact_params)
    @contratosperfact.user_id = is_admin
    @contratosperfact.estado = 'PENDIENTE'
    respond_to do |format|
      if @contratosperfact.save
        flash['success'] = "Creado con exito"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperfact } }
      end
    end
  end

  def update
    respond_to do |format|
      if @contratosperfact.update(contratosperfact_params)
        flash['success'] = "Actualizado con exito"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperfact } }
      end
    end
  end

  def destroy
    @contratosperfact.destroy
    flash['success'] = "Solicitud eliminada con exito"
    redirect_to contratospernominas_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contratosperfact
    @contratosperfact = Contratosperfact.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosperfact_params
    params.require(:contratosperfact).permit!
  end
end
