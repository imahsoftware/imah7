class EvaluacionesController < ApplicationController
  before_action :set_evaluacion, only: [:show, :edit, :update, :destroy]

  layout :set_layout
  # before_action :checkaccess

  def checkaccess
    return is_permit('evaluaciones')
  end

  def clonar
    @evaluacion = Evaluacion.find(params[:id])
    ActiveRecord::Base.connection.execute("CALL prc_duplicar_evaluacion(#{@evaluacion.id},'D')")
    respond_to do |format|
      flash[:notice] = "Evaluación Clonada con Exito!!!"
      format.js { render inline: "location.reload();" }
    end
  end

  def search
    tipo = params[:tipo] rescue nil
    @user_responsable = params[:ubicacion][:user_responsable] rescue nil
    @evaluacion = Evaluacion.find(params[:evaluacion_id]) rescue nil
    @evaluacionesejecuciones = Evaluacionesejecucion.joins(:evaluacionescontrato, :evaluacionesdetalle)
                                                    .select('DISTINCT evaluacionesdetalles.clase, evaluacionescontratos.user_responsable')
                                                    .where("evaluacionesdetalles.evaluacion_id = #{@evaluacion.id} and evaluacionescontratos.user_responsable = #{@user_responsable}
                                              and clase in (select i.descripcion from iparametros i, iparametrosusers u
                                                            where i.campo = '#{tipo}' and i.id = u.iparametro_id and u.user_id = #{is_admin})")
                                                    .where('evaluacionesejecuciones.evaluacionescontrato_id = evaluacionescontratos.id')
                                                    .where('evaluacionesejecuciones.evaluacionesdetalle_id = evaluacionesdetalles.id')
  end

  def ver_grafica_clases
    @evaluacion = Evaluacion.find(params[:id])
  end

  def ver_grafica_usuarios
    @evaluacion = Evaluacion.find(params[:id])
  end

  def contrato
    @user_id = params[:user_id]
    @contratosgrupos = Contratosgrupo.joins(:contrato)
                                     .where("contratosgrupos.id in (SELECT DISTINCT contratosgrupo_id
                                                                    FROM   contratosperusers u, contratosperfechas f
                                                                    WHERE  u.user_id = #{@user_id}
                                                                    AND    u.fecha_fin IS NULL
                                                                    AND    u.`contratospersona_id` = f.`contratospersona_id`
                                                                    AND    (f.fecha_fin IS NULL OR f.fecha_fin >= NOW()))")
                                     .select("contratosgrupos.descripcion, contratosgrupos.termino, contratos.nro_contrato,
                                             (select autobuscar from empresas where id = contratos.empresa_id) identnombre,
                                             (SELECT count(distinct f.id)
                                              FROM   contratosperusers u, contratosperfechas f
                                              WHERE  u.user_id = #{@user_id}
                                              AND    u.fecha_fin IS NULL
                                              AND    u.`contratospersona_id` = f.`contratospersona_id`
                                              AND    f.contratosgrupo_id = contratosgrupos.id
                                              AND    (f.fecha_fin IS NULL OR f.fecha_fin >= NOW())) nroempleados
                                             ")
                                     .order(3)
  end

  def mostrar_evaluacion
    @clase = params[:clase] rescue nil
    @ruta = params[:ruta] rescue nil
    @showevaluacion = params[:clase].to_s + '_' + params[:evaluacion_id].to_s rescue nil
    @evaluacion = Evaluacion.find(params[:evaluacion_id])
    @evaluacionesejecuciones = Evaluacionesejecucion.joins(:evaluacionescontrato)
                                                    .select("evaluacionescontratos.user_responsable AS user_responsable_id,
                                                           (SELECT LTRIM(RTRIM(nombre)) FROM users WHERE id = evaluacionescontratos.user_responsable) AS nombresuser,
                                                           (SELECT email FROM users WHERE id = evaluacionescontratos.user_responsable) AS emailuser,
                                                           (SELECT celular FROM users WHERE id = evaluacionescontratos.user_responsable) AS celularuser").where("evaluacionesejecuciones.evaluacion_id = ?", @evaluacion.id).distinct.order("nombresuser")

  end

  def abrir_evaluacion
    @evaluacionescontrato = Evaluacionescontrato.find(params[:usuario]) rescue nil
    @ruta = params[:ruta] rescue nil
    @showevaluacion = params[:usuario].to_s + '_' + params[:evaluacion_id].to_s rescue nil
    @evaluacion = Evaluacion.find(params[:evaluacion_id])
    @contratosperfecha = Contratosperfecha.find(params[:contratosperfecha_id])
  end

  def mostrar_evaluacion_prueba
    @evaluacionescontrato = Evaluacionescontrato.find(params[:usuario]) rescue nil
    @ruta = params[:ruta] rescue nil
    @showevaluacion = params[:usuario].to_s + '_' + params[:evaluacion_id].to_s rescue nil
    @evaluacion = Evaluacion.find(params[:evaluacion_id])
    @contratosperfecha = Contratosperfecha.find(params[:contratosperfecha_id])
  end

  def ver_grafica_general
    @evaluacion = Evaluacion.find(params[:id])
    @clase = params[:clase] rescue nil
    if @evaluacion.tipo == 'EVALUACION PERIODO PRUEBA'
      @pendientes = Evaluacionesejecucion.joins(:evaluacionesdetalle).where("evaluacionesejecuciones.evaluacion_id = #{@evaluacion.id} and evaluacionesejecuciones.estado is null").count rescue 0
      @finalizados = Evaluacionesejecucion.joins(:evaluacionesdetalle).where("evaluacionesejecuciones.evaluacion_id = #{@evaluacion.id} and evaluacionesejecuciones.estado = '1'").count rescue 0
      @no_cumple = Evaluacionesejecucion.joins(:evaluacionesdetalle).where("evaluacionesejecuciones.evaluacion_id = #{@evaluacion.id} and evaluacionesejecuciones.estado = '2'").count rescue 0
      @no_aplica = Evaluacionesejecucion.joins(:evaluacionesdetalle).where("evaluacionesejecuciones.evaluacion_id = #{@evaluacion.id} and evaluacionesejecuciones.estado = '3'").count rescue 0
      @pactialmente = Evaluacionesejecucion.joins(:evaluacionesdetalle).where("evaluacionesejecuciones.evaluacion_id = #{@evaluacion.id} and evaluacionesejecuciones.estado = '4'").count rescue 0
    else
      @pendientes = Evaluacionesejecucion.joins(:evaluacionesdetalle).where("evaluacionesejecuciones.evaluacion_id = #{@evaluacion.id} and evaluacionesejecuciones.estado is null").count rescue 0
      @finalizados = Evaluacionesejecucion.joins(:evaluacionesdetalle).where("evaluacionesejecuciones.evaluacion_id = #{@evaluacion.id} and evaluacionesejecuciones.estado = '1'").count rescue 0
      @no_cumple = Evaluacionesejecucion.joins(:evaluacionesdetalle).where("evaluacionesejecuciones.evaluacion_id = #{@evaluacion.id} and evaluacionesejecuciones.estado = '0'").count rescue 0
      @no_aplica = Evaluacionesejecucion.joins(:evaluacionesdetalle).where("evaluacionesejecuciones.evaluacion_id = #{@evaluacion.id} and evaluacionesejecuciones.estado = '1.0'").count rescue 0
      @pactialmente = Evaluacionesejecucion.joins(:evaluacionesdetalle).where("evaluacionesejecuciones.evaluacion_id = #{@evaluacion.id} and evaluacionesejecuciones.estado = '0.5'").count rescue 0
    end
  end

  def index
    @etapa = params[:etapa].present? ? params[:etapa] : 'A'
    if @etapa == 'A'
      @evaluaciones = Evaluacion.where(tipo: 'EVALUACION DESEMPENO').order("id desc")
    elsif @etapa == 'B'
      @evaluaciones = Evaluacion.where(tipo: 'EVALUACION PERIODO PRUEBA').order("id desc")
    end
  end

  def new
    @evaluacion = Evaluacion.new
    @tipo = params[:tipo]
    @evaluacion.tipo = params[:tipo]
    render "evaluacion_form"
  end

  def edit
    @etapa = params[:etapa].present? ? params[:etapa] : 'A'
    respond_to do |format|
      format.html { render :action => "evaluacion_form" }
    end
  end

  def create
    @evaluacion = Evaluacion.new(evaluacion_params)
    @evaluacion.user_id = is_admin
    respond_to do |format|
      if @evaluacion.save
        format.html { redirect_to edit_evaluacion_path(id: @evaluacion.id, etapa: 'A'), notice: "El registro ha sido registrado con Exito." }
        format.json { render :show, status: :created, location: @evaluacion }
      else
        format.html { render :action => "evaluacion_form" }
        format.json { render json: @evaluacion.errors, status: :unprocessable_entity }
      end
    end
  end

  def agregar_usuario
    @evaluacion = Evaluacion.find(params[:evaluacion_id])
    @evaluacionescontrato = Evaluacionescontrato.new
  end

  def incluirtodos
    evaluacionId = params[:evaluacion_id]
    isadmin = is_admin
    vcClase = params[:clase].to_s
    ActiveRecord::Base.connection.execute("CALL prc_evaluaciones_ejecucion(#{evaluacionId},#{isadmin},'#{vcClase}')")
    redirect_to edit_evaluacion_path(id: evaluacionId)
  end

  def update
    if @evaluacion.update(evaluacion_params)
      flash['success'] = "Actualizado con exito"
      if @evaluacion.estado.to_s == 'ACTIVO'
        ActiveRecord::Base.connection.execute("CALL prc_evaluaciones_ejecucion(#{@evaluacion.id},#{is_admin},'INICIAR')")
=begin
        #ActiveRecord::Base.connection.execute("CALL prc_cargue_ejecucion(#{@evaluacion.id})")
        Evaluacionescontrato.where("evaluacion_id = #{@evaluacion.id}").each do |evaluacionescontrato|
          Evaluacionesdetalle.where("evaluacion_id = #{@evaluacion.id}").each do |evaluacionesdetalle|
            Evaluacionesejecucion.create(evaluacionescontrato_id: evaluacionescontrato.id, evaluacion_id: @evaluacion.id, evaluacionesdetalle_id: evaluacionesdetalle.id)
          end
        end
=end
      end
      redirect_to edit_evaluacion_path(id: @evaluacion.id)
    else
      render "evaluacion_form"
    end
  end

  def destroy
    @evaluacion.destroy
    respond_to do |format|
      flash[:notice] = "Evaluacion Eliminado con Exito!!!"
      format.js { render inline: "location.reload();" }
    end
  end

  def detec
    idEvaluacion = params[:id]
    tipo = params[:tipo]
    User.find(is_admin).update_columns(subetapa: idEvaluacion.to_s)
    if tipo == 'EVALUACION DESEMPENO'
      redirect_to gestion_evaluaciones_path
    elsif tipo == 'EVALUACION PERIODO PRUEBA'
      redirect_to gestion_prueba_evaluaciones_path
    else
      redirect_to root_path
    end
  end

  def informepdf
    @evaluacion = Evaluacion.find(params[:id])
    @user = User.find(is_admin)
    @evaluacionesejecuciones = Evaluacionesejecucion.joins(:evaluacionescontrato)
                                                    .select("evaluacionescontratos.user_responsable user_responsable_id,
                                                            (select ltrim(rtrim(nombre)) from users where id = evaluacionescontratos.user_responsable) nombresuser,
                                                            (select email from users where id = evaluacionescontratos.user_responsable) emailuser,
                                                            (select celular from users where id = evaluacionescontratos.user_responsable) celularuser")
                                                    .where("evaluacionesejecuciones.evaluacion_id = ?", @evaluacion.id)
                                                    .distinct.order('2')

    respond_to do |format|
      format.pdf { render pdf: "InformeSeguimiento",
                          template: "evaluaciones/informepdf.html.erb",
                          encoding: "UTF-8", page_size: 'Letter', :margin => { top: 10, :bottom => 10, :left => 10, :right => 10 } }
    end
  end

  def gestion
    idTarea = User.find(is_admin).subetapa.to_i rescue nil
    # puts "idTarea..." + idTarea.to_s
    if idTarea.present?
      @evaluaciones = Evaluacion.select("evaluaciones.*, (select count(id) from evaluacionesdetalles where evaluacion_id = evaluaciones.id and estado = '0') pendientes,
                                       (select count(id) from evaluacionesdetalles where evaluacion_id = evaluaciones.id and estado = '0.5') procesos,
                                       (select count(id) from evaluacionesdetalles where evaluacion_id = evaluaciones.id and estado = '1.0') noaplica,
                                       (select count(id) from evaluacionesdetalles where evaluacion_id = evaluaciones.id and estado = '1') finalizadas ,
                                       (select count(id) from evaluacionesdetalles where evaluacion_id = evaluaciones.id) total")
                                .where(id: idTarea, tipo: 'EVALUACION DESEMPENO')
    end
    # puts "@evaluaciones.... " + @evaluaciones.present?.to_s
  end

  def gestion_prueba
    idTarea = User.find(is_admin).subetapa.to_i rescue nil
    if idTarea.present?
      @evaluaciones = Evaluacion.select("evaluaciones.*, (select count(id) from evaluacionesdetalles where evaluacion_id = evaluaciones.id and estado = '1') deficiente,
                                       (select count(id) from evaluacionesdetalles where evaluacion_id = evaluaciones.id and estado = '2') regular,
                                       (select count(id) from evaluacionesdetalles where evaluacion_id = evaluaciones.id and estado = '3') bueno,
                                       (select count(id) from evaluacionesdetalles where evaluacion_id = evaluaciones.id and estado = '4') excelente ,
                                       (select count(id) from evaluacionesdetalles where evaluacion_id = evaluaciones.id) total")
                                .where(id: idTarea, tipo: 'EVALUACION PERIODO PRUEBA')
    end
    # puts "@evaluaciones.... " + @evaluaciones.present?.to_s
  end

  private

  def set_layout
    if ['index', 'new'].include?(action_name)
      'application_admin'
    elsif ['edit'].include?(action_name)
      'application_admin'
    elsif ['gestion'].include?(action_name)
      'application_evaluaciones'
    elsif ['gestion_prueba'].include?(action_name)
      'application_evaluaciones_prueba'
    else
      "application_admin"
    end
  end

  def set_evaluacion
    @evaluacion = Evaluacion.find(params[:id])
  end

  def evaluacion_params
    params.require(:evaluacion).permit!
  end
end
