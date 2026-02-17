class ContratospernominasController < ApplicationController
  before_action :set_contratospernomina, only: [:show, :edit, :update, :destroy]

  layout :set_layout
  before_action :checkaccess, except: [:tirilla, :tirilla_masive]

  def checkaccess
    return is_permit('contratospernominas')
  end

  def show_detalle
    @ruta = params[:ruta]
    @consecutivo = params[:consecutivo]
    @datosobj = Solicitudesretiro.joins(:contrato, :contratospersona, :contratosgrupo)
                              .select("contratospersonas.autobuscar, (select autobuscar from empresas where id = contratos.empresa_id) identnombre, contratos.nro_contrato,
                                                    contratosgrupos.descripcion, contratosgrupos.termino,
                                                    (select nombre from users where id = solicitudesretiros.user_id) usernombre,
                                                    (select nombre from users where id = solicitudesretiros.user_aprobacion) useraprobanombre,
                                                    (select trasladado from contratosperfechas where id = solicitudesretiros.contratosperfecha_id) trasladado,
                                                    (select distinct 'X' from contratosperlimagenes where contratosperfecha_id = solicitudesretiros.contratosperfecha_id) existeimagen,
                                                    solicitudesretiros.*")
                              .where(["estado_final = 'PAGADO'"]).order("contratospersonas.identificacion asc")
    @datos1 = @datosobj.where(["consecutivo = #{@consecutivo}"])
    @datos = @datos1.paginate(:page => params[:page], :per_page => 10)
  end

  def show_detallepro
    @ruta = params[:ruta]
    @consecutivo = params[:consecutivo]
    @consecutivo2 = params[:consecutivo2]
    @datos =  Contratospermasiva.joins(:contrato, :contratosgrupo)
                                 .select("contratospermasivas.*, contratos.nro_contrato,
                                           (select e.autobuscar from empresas e, contratos c where c.id = contratospermasivas.contrato_id and c.empresa_id = e.id) identnombre,
                                           (select count(9) from contratospermasdetalles where contratospermasiva_id = contratospermasivas.id) cantdetalle,
                                           contratosgrupos.descripcion, contratosgrupos.termino")
                                 .where(["replace(contratospermasivas.proceso,' ','') = '#{@consecutivo}'"]).order("contratospermasivas.id desc")
  end

  def enviar_novedad_consecutivo
    consecutivo = params[:consecutivo]
    tiponovedad = params[:tiponovedad]
    isportafolio = is_portafolio
    code = WsAportesController.otras_novedades_masivas(isportafolio,consecutivo, tiponovedad )
    flash[:notice] = "Proceso Ejecutado con exito!!!!"
    redirect_to contratospernominas_path
  end

  def ejecutarake
    Ejecucion.create(periodosliquidacion_id: params[:periodosliquidacion_id], user_id: current_user.id, portafolio_id: is_portafolio, tipo: 'DIAN')
    Contratospernomina.where("periodosliquidacion_id = #{params[:periodosliquidacion_id]} and legalstatus_alegra = 'REJECTED'").
      update(alegra_id: nil, alegra_cune: nil, alegra_date: nil, alegra_xmlfilename: nil, alegra_zipfilename: nil,
             alegra_qrcodecontent: nil, alegra_signaturevalue: nil, status_alegra: nil,
             legalstatus_alegra: nil, governmentresponse_code: nil, governmentresponse_message: nil)
    flash[:warning] = "Se ha programado el envio de facturas a la Dian a las 10:00 PM"
    redirect_to contratospernominas_path
  end

  def ejecutarakeaportes
=begin
    Ejecucion.create(periodosliquidacion_id: params[:periodosliquidacion_id], user_id: current_user.id, portafolio_id: is_portafolio, tipo: 'APORTES')
    flash[:warning] = "Se ha programado el envio de facturas a la Dian a las 9:00 PM"
=end
    periodo = params[:periodo].to_s
    isportafolio = is_portafolio
    isadmin = is_admin
    Contratospernomina.joins(:contrato, :contratosgrupo)
                      .select("distinct contratospernominas.contrato_id, contratos.nro_contrato,
                                                          (select distinct 'X' from contratosprenimagenes where contrato_id = contratospernominas.contrato_id and contratosgrupo_id = contratospernominas.contratosgrupo_id) existedoc,
                                                          (select autobuscar from empresas where id = contratos.empresa_id) identnombre,
                                                          contratospernominas.contratosgrupo_id,
                                                          contratosgrupos.descripcion,
                                                          contratospernominas.estado,
                                                          count(9) cantidad,
                                                          sum(contratospernominas.total) total,
                                                          concat('#{periodo}',' : ',(select autobuscar from empresas where id = contratos.empresa_id),' : ',contratosgrupos.descripcion,' : ',contratos.nro_contrato) vcdetalle")
                      .where(["contratospernominas.periodosliquidacion_id in (select id from periodosliquidaciones where date_format(inicio,'%%Y-%%m') = '#{periodo}')
                              and  contratos.empresa_id in (select id from empresas where logo = 'logo_inicio_asear.png')
                              AND  contratospernominas.id IN (SELECT n.contratospernomina_id FROM contratospernovedades n, tiposnovedades t
                                                              WHERE  n.contratospernomina_id = contratospernominas.id
                                                              AND    n.tiposnovedad_id = t.id
                                                              AND    t.tiposnaporte_id IS NOT NULL)
                              and  contratospernominas.estado = 'CONSOLIDADO'
                              and  (select distinct 'X' from ejecuciones where detalle = concat('#{periodo}',' : ',(select autobuscar from empresas where id = contratos.empresa_id),' : ',contratosgrupos.descripcion,' : ',contratos.nro_contrato)) is null"])
                      .group("contratospernominas.contrato_id, contratospernominas.contratosgrupo_id, contratospernominas.estado, contratos.empresa_id")
                      .order("contratospernominas.contrato_id").each do |c|
      contratoid = c.contrato_id
      annomes = periodo
      detalle = c.vcdetalle
      contratosgrupoid = c.contratosgrupo_id
      Periodosliquidacion.select("id").where("date_format(inicio,'%Y-%m') = '#{annomes}'
                                              and id in (select distinct c.periodosliquidacion_id
                                                         from   contratospernominas c, contratospernovedades n, tiposnovedades t
                                                         where  c.contrato_id = #{contratoid}
                                                         and    c.contratosgrupo_id = #{contratosgrupoid}
                                                         and    c.estado = 'CONSOLIDADO'
                                                         AND    c.id = n.contratospernomina_id
                                                         AND    n.tiposnovedad_id = t.id
                                                         AND    t.tiposnaporte_id IS NOT NULL)").each do |a|
        Ejecucion.create(user_id: isadmin,
                         periodosliquidacion_id: a.id,
                         estado: 'PENDIENTE',
                         portafolio_id: isportafolio,
                         tipo: 'APORTESENLINEA',
                         controlador_metodo: "WsAportesController.creacion_masiva_novedades(#{isportafolio}, #{a.id}, #{contratoid}, #{contratosgrupoid})",
                         detalle: detalle)
      end
    end
    flash[:notice] = "El proceso COMPLETO ha iniciado su ejecucion!!!!"
    redirect_to contratospernominas_path
  end

  def enviar_novedad_periodo
    contratoid = params[:contrato_id]
    periodosliquidacionid = params[:periodosliquidacion_id]
    contratosgrupoid = params[:contratosgrupo_id]
    isportafolio = is_portafolio
    code = WsAportesController.creacion_masiva_novedades(isportafolio, periodosliquidacionid, contratoid, contratosgrupoid)
    flash[:notice] = "Proceso Ejecutado con exito!!!!"
    redirect_to contratospernominas_path
  end

  def enviar_novedad_annomes
    contratoid = params[:contrato_id]
    annomes = params[:annomes].to_s
    detalle = params[:detalle].to_s
    contratosgrupoid = params[:contratosgrupo_id]

    isportafolio = is_portafolio
    Periodosliquidacion.select("id").where("date_format(inicio,'%Y-%m') = '#{annomes}'
                                            and id in (select distinct c.periodosliquidacion_id
                                                       from   contratospernominas c, contratospernovedades n, tiposnovedades t
                                                       where  c.contrato_id = #{contratoid}
                                                       and    c.contratosgrupo_id = #{contratosgrupoid}
                                                       and    c.estado = 'CONSOLIDADO'
                                                       AND    c.id = n.contratospernomina_id
                                                       AND    n.tiposnovedad_id = t.id
                                                       AND    t.tiposnaporte_id IS NOT NULL)").each do |a|
      Ejecucion.create(user_id: is_admin,
                       periodosliquidacion_id: a.id,
                       estado: 'PENDIENTE',
                       portafolio_id: isportafolio,
                       tipo: 'APORTESENLINEA',
                       controlador_metodo: "WsAportesController.creacion_masiva_novedades(#{isportafolio}, #{a.id}, #{contratoid}, #{contratosgrupoid})",
                       detalle: detalle)
      #code = WsAportesController.creacion_masiva_novedades(isportafolio, a.id, contratoid, contratosgrupoid)
    end
    flash[:notice] = "El proceso ha iniciado su ejecucion!!!!"
    redirect_to contratospernominas_path
  end

  def cancelar_ejecutarake
    Ejecucion.where(periodosliquidacion_id: params[:periodosliquidacion_id], portafolio_id: is_portafolio, estado: 'PENDIENTE', tipo: 'DIAN', contrato_id: params[:contrato_id], contratosgrupo_id: params[:contratosgrupo_id]).update(estado: 'CANCELADO', user_cancela: is_admin, fecha_cancela: Time.now)
    flash[:warning] = "Se realizo la cancelación de la nomina con exito"
    redirect_to contratospernominas_path
  end



  def cancelar_ejecutarakeaportes
    Ejecucion.where(periodosliquidacion_id: params[:periodosliquidacion_id], portafolio_id: is_portafolio, estado: 'PENDIENTE', tipo: 'APORTES').update(estado: 'CANCELADO', user_cancela: is_admin, fecha_cancela: Time.now)
    flash[:warning] = "Se realizo la cancelación del envio de las novedades con exito"
    redirect_to contratospernominas_path
  end




  def get_contratospermasiva_contrato_id
    @contrato = params[:ubicacion_contrato_id]
    @contratosgrupos = Contratosgrupo.where(contrato_id: @contrato) if @contrato
    respond_to { |format| format.js }
  end

  def get_contratospernomina_contrato_id
    @contrato = params[:ubicacion_contrato_id]
    @contratoscargos = Contratoscargo.where(contrato_id: @contrato) if @contrato
    @contratosgrupos = Contratosgrupo.where(contrato_id: @contrato, termino: User.find(is_admin).etapa.to_s) if @contrato
    respond_to { |format| format.js }
  end

  def edit
    @contratos = Contrato.where(contratospernomina_id: @contratospernomina.id).all.order("fecha_inicio desc")
    respond_to do |format|
      format.html { render :action => "contratospernomina_form" }
    end
  end

  def index
    params[:etapae].blank? ? @etapae = 'P' : @etapae = params[:etapae]
    usr = User.find(is_admin)
    if usr.etapa.to_s == 'LIQUIDACION'
      #procount = Usersmodulo.joins(:modulo).where(["usersmodulos.user_id = ? and modulos.nivel = ?", isadmin, 2]).select("modulos.*").order("modulos.descripcion")
      @pendientes = Solicitudesretiro.joins(:contratospersona, :contrato, :contratosgrupo)
                                     .select("contratos.nro_contrato, contratospersonas.identificacion, contratospersonas.nombre_completo,
                                              contratosgrupos.descripcion, contratosgrupos.termino,
                                             (select autobuscar from empresas where id = contratos.empresa_id) identnombre,
                                             (select nombre from users where id = solicitudesretiros.user_id) usernombre,
                                              solicitudesretiros.*")
                                     .where(user_aprobacion: nil)
                                     .order("solicitudesretiros.fecha asc")
      @parapago = Solicitudesretiro.select("consecutivo, count(9) cantidad").where(["consecutivo is not null and estado_final is null"]).distinct.group("consecutivo").order("consecutivo desc")
      @pagadas  = Solicitudesretiro.select("consecutivo, count(9) cantidad").where(["consecutivo is not null and estado_final is not null"]).distinct.group("consecutivo").order("consecutivo desc")
    elsif usr.etapa.to_s == 'VACACIONES'
      @pendientes = Contratospervacacion.joins(:contratospersona, :contrato, :contratosperfecha)
                                     .select("contratos.nro_contrato, contratospersonas.identificacion, contratospersonas.nombre_completo,
                                           (select descripcion from contratosgrupos where id = contratosperfechas.contratosgrupo_id) descripcion,
                                           (select termino from contratosgrupos where id = contratosperfechas.contratosgrupo_id) termino,
                                           (select autobuscar from empresas where id = contratos.empresa_id) identnombre,
                                           (select nombre from users where id = contratospervacaciones.user_id) usernombre,
                                            contratospervacaciones.*")
                                     .where(estado: 'PENDIENTE')
                                     .order("contratospervacaciones.fecha_inicio asc")
      @parapago = Contratospervacacion.select("consecutivo, count(9) cantidad").where(["consecutivo is not null and estado = 'LIQUIDADA'"]).distinct.group("consecutivo").order("consecutivo desc")
      @pagadas  = Contratospervacacion.select("consecutivo, count(9) cantidad").where(["consecutivo is not null and estado = 'PAGADA'"]).distinct.group("consecutivo").order("consecutivo desc")
    end
    @autorizacionnomina = is_auth_c("autorizacionnomina")
    @autorizaciondesconsolidarnomina = is_auth_c("autorizaciondesconsolidarnomina")
    @autorizaaporteslinea = is_auth_c("autorizaaporteslinea")
    @nominaelectronica = is_auth_c("nominaelectronica")
  end

  def nomina
    periodo = params[:ubicacion][:periodosliquidacion_id].to_s rescue ""
    contrato = params[:ubicacion][:contrato_id].to_s rescue ""
    contratosgrupo = params[:contratospernomina][:contratosgrupo_id].to_s rescue ""
    if periodo == "" or contrato == ""# or contratosgrupo == ""
      flash[:warning] = "No hay resultados de la consulta!!!"
      redirect_to contratospernominas_path
    else
      if contratosgrupo.to_i == 0
        ActiveRecord::Base.connection.execute("CALL prc_creanomina2_masivo(#{contrato},#{periodo})")
        flash[:success] = "Periodo y CONTRATO generado con EXITO!!!"
      else
        if Contratospernomina.where(periodosliquidacion_id: periodo, contrato_id: contrato, contratosgrupo_id: contratosgrupo, estado: 'CONSOLIDADO').exists? == false
          ActiveRecord::Base.connection.execute("CALL prc_creanomina2(#{contrato},#{periodo},#{contratosgrupo})")
          flash[:success] = "Periodo y grupo generado con EXITO!!!"
        else
          flash[:warning] = "Periodo y grupo seleccionado ya se encuentra CONSOLIDADO!!!"
        end
      end
      redirect_to contratospernominas_path
    end
  end

  def nominaindividual
    periodo = params[:ubicacion][:periodosliquidacionindividual_id].to_s rescue ""
    identificacion = params[:contratospernomina][:autobuscar].to_s rescue ""
    consolida = params[:contratospernomina][:estado].to_s rescue ""
    if periodo == "" or identificacion == ""
      flash[:warning] = "No hay resultados de la consulta!!!"
      redirect_to contratospernominas_path
    else
      contratosperfecha = Contratosperfecha.joins(:contratospersona)
                                           .select("contratosperfechas.*")
                                           .where(["contratospersonas.identificacion = '#{identificacion.to_s}' and contratosperfechas.estado ='ACTIVO'"])[0]
      contrato = contratosperfecha.contrato_id.to_s
      contratosgrupo = contratosperfecha.contratosgrupo_id.to_s
      contratosperfecha = contratosperfecha.id
      ActiveRecord::Base.connection.execute("CALL prc_creanomina2_individual(#{contrato},#{periodo},#{contratosgrupo},#{contratosperfecha})")
      if consolida.to_s == 'SI'
        Contratospernomina.where(periodosliquidacion_id: periodo, contrato_id: contrato, contratosgrupo_id: contratosgrupo, contratosperfecha_id: contratosperfecha)
                          .update_all(estado: 'CONSOLIDADO', updated_at: Time.now)
        ActiveRecord::Base.connection.execute("CALL prc_consolidanomina2_individual(#{contrato},#{periodo},#{contratosgrupo},#{contratosperfecha})")
      end
      redirect_to contratospernominas_path
    end
  end

  def nominaesp
    periodo = params[:ubicacion][:periodosliquidacion_id].to_s rescue ""
    if periodo != ""
      termino = Periodosliquidacion.find(periodo).termino.to_s
      Contratosgrupo.select("contrato_id, id contratosgrupo_id").where(["termino = '#{termino.to_s}'
                                                                         and id in (select distinct contratosgrupo_id from contratosperfechas where contratosgrupo_id is not null)
                                                                         and id not in (select distinct contratosgrupo_id from contratospernominas
                                                                                        where periodosliquidacion_id = #{periodo}
                                                                                        and   contrato_id = contratosgrupos.contrato_id
                                                                                        and   contratosgrupo_id = contratosgrupos.id and estado = 'CONSOLIDADO')"]).each do |a|
        ActiveRecord::Base.connection.execute("CALL prc_creanomina2(#{a.contrato_id},#{periodo},#{a.contratosgrupo_id})")
      end
      flash[:success] = "Periodos generados con EXITO!!!"
    end
    redirect_to contratospernominas_path
  end

  def datos
    periodo = params[:periodosliquidacion_id].to_s rescue ""
    contrato = params[:contrato_id].to_s rescue ""
    contratosgrupo = params[:contratosgrupo_id].to_s rescue ""
    @contrato = Contrato.find(contrato)
    @periodosliquidacion = Periodosliquidacion.find(periodo)
    @contratospernominas = Contratospernomina.where(periodosliquidacion_id: periodo, contrato_id: contrato, contratosgrupo_id: contratosgrupo).order("id asc")
    @estadonomina = Contratospernomina.select("estado").where(periodosliquidacion_id: periodo, contrato_id: contrato, contratosgrupo_id: contratosgrupo).distinct
  end

  def cambioestado
    periodo = params[:periodosliquidacion_id].to_s rescue ""
    contrato = params[:contrato_id].to_s rescue ""
    contratosgrupo = params[:contratosgrupo_id].to_s rescue ""
    estado = params[:estado].to_s rescue ""
    if estado == 'ELIMINAR'
      ActiveRecord::Base.connection.execute("CALL prc_eliminanomina(#{contrato},#{periodo},#{contratosgrupo})")
      flash['success'] = "Prenomina Eliminada"
        else
      # 2022-01-30 Por aqui ingresa si es pendiente o consolidado....
      @dato = Contratospernomina.where(periodosliquidacion_id: periodo, contrato_id: contrato, contratosgrupo_id: contratosgrupo).update_all(estado: estado.to_s, updated_at: Time.now)
      ActiveRecord::Base.connection.execute("CALL prc_consolidanomina2(#{contrato},#{periodo},#{contratosgrupo})")
      flash['success'] = "Informe Consolidado"
    end
    respond_to { |format| format.js }
  end

  def edit_individual
    periodo = params[:periodosliquidacion_id].to_s rescue ""
    contrato = params[:contrato_id].to_s rescue ""
    @contrato = Contrato.find(contrato)
    @periodosliquidacion = Periodosliquidacion.find(periodo)
    @contratospernominas = Contratospernomina.where(periodosliquidacion_id: periodo, contrato_id: contrato).order("id asc")
  end

  def update_individual
    periodo = 0
    contrato = 0
    JSON.parse(params[:contratospernominas].to_json).each do |object|
      contrato = Contratospernomina.find(object[0]).contrato_id.to_s
      periodo = Contratospernomina.find(object[0]).periodosliquidacion_id.to_s
      break if periodo != ""
    end
    Contratospernomina.update(params[:contratospernominas].keys, params[:contratospernominas].values)
    redirect_to edit_individual_contratospernominas_path(periodosliquidacion_id: periodo, contrato_id: contrato)
  end

  def create
    @contratospernomina = Contratospernomina.new(contratospernomina_params)
    respond_to do |format|
      if @contratospernomina.save
        format.html { redirect_to edit_contratospernomina_path(etapa: "A", id: @contratospernomina.id), notice: "El registro ha sido registrado con Exito." }
        format.json { render :show, status: :created, location: @contratospernomina }
      else
        format.html { render :action => "contratospernomina_form" }
        format.json { render json: @contratospernomina.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @contratospernomina.update(contratospernomina_params)
      flash['success'] = "Usuario actualizado"
      redirect_to edit_contratospernomina_path(id: @contratospernomina.id, etapa: 'A')
    else
      render "contratospernomina_form"
    end
  end

  def destroy
    @contratospernomina.destroy
    flash[:notice] = "El registro ha sido borrado con Exito."
    respond_to do |format|
      format.html { redirect_to(contratospernominas_url) }
      format.xml  { head :ok }
    end
  end

  def tirilla
    idNomina = params[:idnomina].to_s rescue ""
    if idNomina.to_s != ""
      @contratospernominas = Contratospernomina.where(id: idNomina)
      @logo = Contrato.find(@contratospernominas[0].contrato_id).empresa.logo.to_s
      @periodosliquidacion = Periodosliquidacion.find(@contratospernominas[0].periodosliquidacion_id)
      @isadmin = is_admin
      identificacion = Contratospersona.find(@contratospernominas[0].contratospersona_id).identificacion.to_s rescue nil
      fname = "AsearTirilla_" + identificacion.to_s + "_" + @periodosliquidacion.descripciontirilla.to_s
    else
      periodo = params[:periodosliquidacion_id].to_s rescue ""
      contrato = params[:contrato_id].to_s rescue ""
      @logo = Contrato.find(contrato).empresa.logo.to_s
      contratospersona = params[:contratospersona_id].to_s rescue ""
      contratosgrupo = params[:contratosgrupo_id].to_s rescue ""
      @periodosliquidacion = Periodosliquidacion.find(periodo)
      @isadmin = is_admin
      if contratospersona.to_s != ""
        @contratospernominas = Contratospernomina.where(periodosliquidacion_id: periodo, contrato_id: contrato, contratospersona_id: contratospersona, contratosgrupo_id: contratosgrupo)
        identificacion = Contratospersona.find(contratospersona).identificacion.to_s rescue nil
        fname = "AsearTirilla_" + identificacion.to_s + "_" + @periodosliquidacion.descripciontirilla.to_s
      else
        nombegrupo = Contratosgrupo.find(contratosgrupo).descripcion.gsub(" ","_").to_s rescue nil
        fname = "AsearTirilla_" + nombegrupo.to_s + "_" + @periodosliquidacion.descripciontirilla.to_s
        @contratospernominas = Contratospernomina.where(periodosliquidacion_id: periodo, contrato_id: contrato, contratosgrupo_id: contratosgrupo).order("id asc")
      end
    end
    respond_to do |format|
      format.pdf { render pdf:"#{fname}", template:"contratospernominas/tirilla", encoding: "UTF-8", page_size: 'Letter',disposition: 'attachment'}
    end
  end

  def self.downloadtirilla
    Periodosliquidacion.where("inicio BETWEEN '2023-01-01' AND '2024-10-01' AND termino = 'QUINCENAL'").each do |a|
      rutacarpeta = "#{::Rails.root}/public/archivos/pdf/#{a.inicio.to_s}"
      system("mkdir #{rutacarpeta}")
      Contratosgrupo.where("contrato_id in (select id from contratos where portafolio_id = 1)").each do |b|
        if Contratospernomina.where(periodosliquidacion_id: a.id, contrato_id: b.contrato_id, contratosgrupo_id: b.id).present?
          periodo = a.id
          contrato = b.contrato_id
          @logo = Contrato.find(contrato).empresa.logo.to_s
          contratosgrupo = b.id
          @periodosliquidacion = Periodosliquidacion.find(periodo)
          nombegrupo = Contratosgrupo.find(contratosgrupo).descripcion.gsub(" ","_").to_s rescue nil
          fname = "AsearTirilla_" + nombegrupo.to_s + "_" + @periodosliquidacion.descripciontirilla.to_s
          rutafact = "#{rutacarpeta}/"
          rutanamefile = "#{rutacarpeta}/#{fname}.pdf"
          @contratospernominas = Contratospernomina.where(periodosliquidacion_id: periodo, contrato_id: contrato, contratosgrupo_id: contratosgrupo).order("id asc")
          pdf = ApplicationController.render pdf: "#{fname}", template: "contratospernominas/tirilla.pdf.erb", :save_to_file => rutanamefile, :save_only => true,
                                             encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 },
                                             locals: { object0: @contratospernominas, object1: @logo, object2: @periodosliquidacion }
          save_path = Rails.root.join(rutafact, "#{fname}.pdf")
          File.open(save_path, 'wb') do |file|
            file << pdf
          end
        end
      end
    end
  end

  def self.downloadtirilla2
    Periodosliquidacion.where("inicio BETWEEN '2023-01-01' AND '2024-10-01' AND termino = 'MENSUAL'").each do |a|
      rutacarpeta = "#{::Rails.root}/public/archivos/pdf/#{a.inicio.strftime('%Y-%m-').to_s+'16'}"
      system("mkdir #{rutacarpeta}")
      Contratosgrupo.where("contrato_id in (select id from contratos where portafolio_id = 1)").each do |b|
        if Contratospernomina.where(periodosliquidacion_id: a.id, contrato_id: b.contrato_id, contratosgrupo_id: b.id).present?
          periodo = a.id
          contrato = b.contrato_id
          @logo = Contrato.find(contrato).empresa.logo.to_s
          contratosgrupo = b.id
          @periodosliquidacion = Periodosliquidacion.find(periodo)
          nombegrupo = Contratosgrupo.find(contratosgrupo).descripcion.gsub(" ","_").to_s rescue nil
          fname = "AsearTirilla_" + nombegrupo.to_s + "_" + @periodosliquidacion.descripciontirilla.to_s
          rutafact = "#{rutacarpeta}/"
          rutanamefile = "#{rutacarpeta}/#{fname}.pdf"
          @contratospernominas = Contratospernomina.where(periodosliquidacion_id: periodo, contrato_id: contrato, contratosgrupo_id: contratosgrupo).order("id asc")
          pdf = ApplicationController.render pdf: "#{fname}", template: "contratospernominas/tirilla.pdf.erb", :save_to_file => rutanamefile, :save_only => true,
                                             encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 },
                                             locals: { object0: @contratospernominas, object1: @logo, object2: @periodosliquidacion }
          save_path = Rails.root.join(rutafact, "#{fname}.pdf")
          File.open(save_path, 'wb') do |file|
            file << pdf
          end
        end
      end
    end
  end

  #ContratospernominasController.liquidacionesmasivas
  def self.liquidacionesmasivas
    @pagadas  = Solicitudesretiro.select("consecutivo, count(9) cantidad")
                                 .where(["consecutivo >= 704 and estado_final = 'PAGADO'"])
                                 .distinct.group("consecutivo").order("consecutivo desc")
    @pagadas.each do |a|
      rutacarpeta = "#{::Rails.root}/public/archivos/pdf/liquidaciones/#{a.consecutivo.to_s}"
      system("mkdir #{rutacarpeta}")
      @consecutivo = a.consecutivo
      @solicitudesretiros = Solicitudesretiro.where(consecutivo: @consecutivo, portafolio_id: 1)
      fname = "AsearLiquidacion_" + @consecutivo.to_s
      rutafact = "#{rutacarpeta}/"
      rutanamefile = "#{rutacarpeta}/#{fname}.pdf"
      pdf = ApplicationController.render pdf: "#{fname}", template: "contratosperliquidaciones/liquidacion_masive.pdf.erb", :save_to_file => rutanamefile, :save_only => true,
                                         encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 },
                                         locals: { object0: @consecutivo, object1: @solicitudesretiros}
      save_path = Rails.root.join(rutafact, "#{fname}.pdf")
      File.open(save_path, 'wb') do |file|
        file << pdf
      end

      if Contratosperlimagen.where("contratosperfecha_id in (select contratosperfecha_id from solicitudesretiros where consecutivo = #{@consecutivo} and portafolio_id = 1)").present?
        fname1 = 'Soportes_' + @consecutivo.to_s + '_*'
        rutaFile = "#{rutacarpeta}/" + fname1.to_s
        system("rm -r #{rutaFile}")

        dfolder = "public/system/liquidacionesimagenes/"
        folderform = "public/download/"
        nombreform = ""
        dinput_filenames = []
        dinput_fileids = []
        dinput_fileperiodo = []
        a = 0
        contratosdoc = Contratosperlimagen.where("contratosperfecha_id in (select contratosperfecha_id from solicitudesretiros where consecutivo = #{@consecutivo} and portafolio_id = 1)") rescue nil
        contratosdoc.each do |d|
          dinput_filenames[a] = d.liquidacionesimagen_file_name.to_s
          dinput_fileids[a] = d.id.to_s
          dinput_fileperiodo[a] = 'COMPROBANTE'
          a = a + 1
        end

        fname = 'Soportes_' + @consecutivo.to_s + '.zip'
        zipfile_folder = "#{rutacarpeta}/" + fname
        File.delete(zipfile_folder) if File.exist?(zipfile_folder)
        Zip::File.open(zipfile_folder, Zip::File::CREATE) do |zipfile|
          a = 0
          dinput_filenames.each do |filename|
            ruta = dinput_fileids[a].to_s
            bashrc = File.join(dfolder + ruta + '/original', filename)
            if File.exist?(bashrc) # => true
              zipfile.add(dinput_fileperiodo[a].to_s + '_(' + dinput_fileids[a] + ')_' + filename, File.join(dfolder + ruta + '/original', filename))
            end
            a = a + 1
          end
        end
      end
    end
  end

  def self.liquidacionesmasivassolocomprobante
    @pagadas  = Solicitudesretiro.select("consecutivo, count(9) cantidad")
                                 .where(["consecutivo >= 704 and estado_final = 'PAGADO'"])
                                 .distinct.group("consecutivo").order("consecutivo desc")
    @pagadas.each do |a|
      rutacarpeta = "#{::Rails.root}/public/archivos/pdf/liquidaciones/#{a.consecutivo.to_s}"
      @consecutivo = a.consecutivo

      if Contratosperlimagen.where("contratosperfecha_id in (select contratosperfecha_id from solicitudesretiros where consecutivo = #{@consecutivo} and portafolio_id = 1)").present?
        system("mkdir #{rutacarpeta}")
        fname1 = 'Soportes_' + @consecutivo.to_s + '_*'
        rutaFile = "#{rutacarpeta}/" + fname1.to_s
        system("rm -r #{rutaFile}")

        dfolder = "public/system/liquidacionesimagenes/"
        folderform = "public/download/"
        nombreform = ""
        dinput_filenames = []
        dinput_fileids = []
        dinput_fileperiodo = []
        a = 0
        contratosdoc = Contratosperlimagen.where("contratosperfecha_id in (select contratosperfecha_id from solicitudesretiros where consecutivo = #{@consecutivo} and portafolio_id = 1)") rescue nil
        contratosdoc.each do |d|
          dinput_filenames[a] = d.liquidacionesimagen_file_name.to_s
          dinput_fileids[a] = d.id.to_s
          dinput_fileperiodo[a] = 'COMPROBANTE'
          a = a + 1
        end

        fname = 'Soportes_' + @consecutivo.to_s + '.zip'
        zipfile_folder = "#{rutacarpeta}/" + fname
        File.delete(zipfile_folder) if File.exist?(zipfile_folder)
        Zip::File.open(zipfile_folder, Zip::File::CREATE) do |zipfile|
          a = 0
          dinput_filenames.each do |filename|
            ruta = dinput_fileids[a].to_s
            bashrc = File.join(dfolder + ruta + '/original', filename)
            if File.exist?(bashrc) # => true
              zipfile.add(dinput_fileperiodo[a].to_s + '_(' + dinput_fileids[a] + ')_' + filename, File.join(dfolder + ruta + '/original', filename))
            end
            a = a + 1
          end
        end
      end
    end
  end

  def tirilla_masive
    @isadmin = is_admin
    contratospersona = params[:contratospersona_id].to_s rescue ""
    contratosperfecha = params[:contratosperfecha_id].to_s rescue ""
    if contratosperfecha.to_s != ""
      @contratospernominas = Contratospernomina.where(contratosperfecha_id: contratosperfecha, estado: 'CONSOLIDADO').order("periodosliquidacion_id desc")
      identificacion = Contratospersona.find(Contratosprefecha.find(contratosperfecha).contratospersona_id).identificacion.to_s rescue nil
      fname = "TirillaMasive_" + identificacion.to_s
    else
      @contratospernominas = Contratospernomina.where(contratospersona_id: contratospersona, estado: 'CONSOLIDADO').order("periodosliquidacion_id desc")
      identificacion = Contratospersona.find(contratospersona).identificacion.to_s rescue nil
      fname = "TirillaMasive_" + identificacion.to_s
    end
    contrato = @contratospernominas[0].contrato_id
    @logo = Contrato.find(contrato).empresa.logo.to_s
    respond_to do |format|
      format.pdf { render pdf:"#{fname}", template:"contratospernominas/tirilla_masive", encoding: "UTF-8", page_size: 'Letter',disposition: 'attachment'}
    end
  end

  def archivosplano
    @contratosgrupo_id = params[:contratosgrupo_id]
    @contrato_id = params[:contrato_id]
    @periodosliquidacion_id = params[:periodosliquidacion_id]
    @contratospernominas = Contratospernomina.joins(:contratospersona)
                                             .where("contratospernominas.contrato_id = #{params[:contrato_id]} AND contratospernominas.periodosliquidacion_id = #{params[:periodosliquidacion_id]}
                                                                                       AND contratospernominas.contratosgrupo_id = #{params[:contratosgrupo_id]}")
                                             .select("contratospersonas.banco, contratospersonas.tipo_cuenta, COUNT(contratospernominas.id) cantidad")
                                             .group("contratospersonas.banco, contratospersonas.tipo_cuenta")
  end

  def archivosplanoliq
    @consecutivo = params[:consecutivo]
  end

  def archivoplano
    periodo = params[:periodosliquidacion_id].to_s rescue ""
    contrato = params[:contrato_id].to_s rescue ""
    contratogrupo = params[:contratosgrupo_id].to_s rescue ""
    entidad = params[:entidad].to_s rescue ""
    tipocuenta = params[:tipocuenta].to_s rescue ""
    nombegrupo = Contratosgrupo.find(contratogrupo).descripcion.gsub(" ","_").to_s rescue nil
    if periodo.to_s != "" and contrato.to_s != "" and contratogrupo.to_s != ""
      if entidad.to_s == "BANCOLOMBIA"
        #'18110442538ASEAR S.A. E.S.P225PAGOSNOM  '
        objetos = Objeto.find_by_sql([" SELECT CONCAT('18110442538ASEAR S.A. E.S.P225',RPAD(SUBSTR(g.descripcion,1,10),10,' ')
                                                      ,DATE_FORMAT(CURDATE(),'%%y%%m%%d'),'A',DATE_FORMAT(CURDATE(),'%%y%%m%%d'),
                                               LPAD(COUNT(9),6,'0'),LPAD(SUM(ROUND(total)),24,'0'),'61335009703D') dato
                                        FROM   contratospernominas n, contratospersonas p, contratosgrupos g
                                        WHERE  n.periodosliquidacion_id = #{periodo}
                                        AND    n.contrato_id = #{contrato}
                                        AND    n.contratosgrupo_id = #{contratogrupo}
                                        AND    n.contratosgrupo_id = g.id
                                        AND    n.contratospersona_id = p.id
                                        AND    p.banco = '#{entidad}'
                                        AND    n.total > 0
                                        UNION ALL
                                        SELECT CONCAT(6,LPAD(p.identificacion,15,'0'),RPAD(SUBSTR(nombre_completo,1,18),18,' '),'005600078',LPAD(p.cuenta_bancolombia,17,'0'),
                                               'S37',LPAD(ROUND(total),10,'0'))
                                        FROM   contratospernominas n, contratospersonas p
                                        WHERE  n.periodosliquidacion_id = #{periodo}
                                        AND    n.contrato_id = #{contrato}
                                        AND    n.contratosgrupo_id = #{contratogrupo}
                                        AND    n.contratospersona_id = p.id
                                        AND    p.banco = '#{entidad}'
                                        AND    n.total > 0"])
        rutaupload = "#{::Rails.root}/public/#{entidad}_#{nombegrupo.to_s}_#{Time.now.strftime("%Y%m%d")}.txt"
        File.delete(rutaupload) rescue nil
        File.open(rutaupload, "w") do |the_file|
          objetos.each do |dat|
            the_file.write dat.dato.to_s + "\r\n"
          end
          the_file.close
        end
        send_file rutaupload, type: "text/plain", x_sendfile: true
      elsif entidad.to_s == "BANCOLOMBIA1"
        #'18110442538ASEAR S.A. E.S.P225PAGOSNOM  '
        objetos = Objeto.find_by_sql([" SELECT CONCAT('1',LPAD(8110442538,15,'0'),'I',LPAD('',15,' '),'225',
                                                      RPAD(SUBSTR('PAG.#{contratogrupo}',1,10),10,' '),
                                                      DATE_FORMAT(CURDATE(),'%%y%%m%%d'),
                                                      CONCAT(CHAR(FLOOR(RAND()*26)+65),ROUND(RAND()*10)),
                                                      DATE_FORMAT(CURDATE(),'%%y%%m%%d'),
                                                      LPAD(COUNT(9),6,'0'),
                                                      LPAD('',17,'0'),
                                                      LPAD(SUM(ROUND(total)),17,'0'),
                                                      LPAD('61335009703',11,'0'),
                                                      'D') dato
                                      FROM   contratospernominas n, contratospersonas p
                                      WHERE  n.periodosliquidacion_id = #{periodo}
                                      AND    n.contrato_id = #{contrato}
                                      AND    n.contratosgrupo_id = #{contratogrupo}
                                      AND    n.contratospersona_id = p.id
                                      AND    p.banco = '#{entidad}'
                                      AND    n.total > 0
                                      UNION ALL
                                      SELECT CONCAT(6,LPAD(p.identificacion,15,'0'),
                                                    RPAD(SUBSTR(nombre_completo,1,30),30,' '),
                                                    '005600078',
                                                    LPAD(p.cuenta_bancolombia,17,'0'),
                                                    ' 37',
                                                    LPAD(ROUND(total),17,'0'))
                                      FROM   contratospernominas n, contratospersonas p
                                      WHERE  n.periodosliquidacion_id = #{periodo}
                                      AND    n.contrato_id = #{contrato}
                                      AND    n.contratosgrupo_id = #{contratogrupo}
                                      AND    n.contratospersona_id = p.id
                                      AND    p.banco = '#{entidad}'
                                      AND    n.total > 0"])
        rutaupload = "#{::Rails.root}/public/#{entidad}_#{nombegrupo.to_s}_#{Time.now.strftime("%Y%m%d")}.txt"
        File.delete(rutaupload) rescue nil
        File.open(rutaupload, "w") do |the_file|
          objetos.each do |dat|
            the_file.write dat.dato.to_s + "\r\n"
          end
          the_file.close
        end
        send_file rutaupload, type: "text/plain", x_sendfile: true
      elsif entidad.to_s == "AVVILLAS"
        objetos = Objeto.find_by_sql([" SELECT CONCAT('01',DATE_FORMAT(CURDATE(),'%%Y%%m%%d%%h%%m%%s'),'088','02',LPAD(' ',170,' ')) dato,
                                                LPAD(CRC32(CONCAT('01',DATE_FORMAT(CURDATE(),'%%Y%%m%%d%%h%%m%%s'),'088','02',LPAD(' ',170,' '))),15,' ') dato2
                                        UNION ALL
                                        SELECT CONCAT('02','000023','06',LPAD('477014427',16,'0'),'052','01',
                                                      LPAD(p.cuenta_bancolombia,16,'0'),
                                                      LPAD(@rownum:=@rownum+1,9,'0'),
                                                      LPAD(ROUND(total),16,'0'),'00',
                                                      LPAD('0',48,'0'),
                                                      RPAD(SUBSTR(nombre_completo,1,30),30,' '),
                                                      LPAD(p.identificacion,11,'0'),
                                                      LPAD('0',26,'0'),
                                                      LPAD('0',2,'0')) dato,
                                               LPAD(CRC32(CONCAT('02','000023','06',LPAD('477014427',16,'0'),'052','01',
                                                                LPAD(p.cuenta_bancolombia,16,'0'),
                                                                LPAD(@rownum:=@rownum+1,9,'0'),
                                                LPAD(ROUND(total),16,'0'),'00',
                                                LPAD('0',48,'0'),
                                                RPAD(SUBSTR(nombre_completo,1,30),30,' '),
                                                LPAD(p.identificacion,11,'0'),
                                                LPAD('0',26,'0'),
                                                LPAD('0',2,'0'))),15,' ') dato2
                                        FROM   (SELECT @rownum:=0) r, contratospernominas n, contratospersonas p
                                        WHERE  n.periodosliquidacion_id = #{periodo}
                                        AND    n.contrato_id = #{contrato}
                                        AND    n.contratosgrupo_id = #{contratogrupo}
                                        AND    n.contratospersona_id = p.id
                                        AND    p.banco = '#{entidad}'
                                        AND    n.total > 0"])
        rutaupload = "#{::Rails.root}/public/#{entidad}_#{nombegrupo.to_s}_#{Time.now.strftime("%Y%m%d")}.txt"
        crc32 = []
        File.delete(rutaupload) rescue nil
        File.open(rutaupload, "w") do |the_file|
          objetos.each do |dat|
            crc32 << dat.dato2
            the_file.write dat.dato.to_s + "\r\n"
          end
          sqlDatos = ""
          sqlDatos << "#{crc32.join("")}"
          datofinal = Objeto.find_by_sql([" SELECT CONCAT('03',
                                                   LPAD(COUNT(9),9,'0'),
                                                   LPAD(SUM(ROUND(n.total)),18,'0'),'00',LPAD(CRC32('#{sqlDatos}'),15,' '),
                                                   LPAD(' ',145,' ')) dato
                                            FROM   contratospernominas n, contratospersonas p
                                            WHERE  n.periodosliquidacion_id = #{periodo}
                                            AND    n.contrato_id = #{contrato}
                                            AND    n.contratosgrupo_id = #{contratogrupo}
                                            AND    n.contratospersona_id = p.id
                                            AND    p.banco = '#{entidad}'
                                            AND    n.total > 0"])[0].dato.to_s
          the_file.write datofinal.to_s + "\r\n"
          the_file.close
        end
        send_file rutaupload, type: "text/plain", x_sendfile: true
      elsif entidad.to_s == "DAVIVIENDA"
          objetos = Objeto.find_by_sql(["SELECT CONCAT('RC',LPAD('8110442538',16,'0'),'NOMI','NOMI',LPAD('38070107123',16,'0'),
                                                'CA','000051',LPAD(SUM(ROUND(n.total)),16,'0'),'00',LPAD(COUNT(9),6,'0'),
                                                DATE_FORMAT(CURDATE(),'%%Y%%m%%d%%h%%m%%s'),'00009999',LPAD('0',16,'0'),'01',LPAD('0',56,'0')) dato
                                        FROM   contratospernominas n, contratospersonas p
                                        WHERE  n.periodosliquidacion_id = #{periodo}
                                        AND    n.contrato_id = #{contrato}
                                        AND    n.contratosgrupo_id = #{contratogrupo}
                                        AND    n.contratospersona_id = p.id
                                        AND    p.tipo_cuenta = '#{tipocuenta}'
                                        AND    p.banco = '#{entidad}'
                                        AND    n.total > 0
                                        UNION ALL
                                        SELECT CONCAT('TR',LPAD(p.identificacion,16,'0'),LPAD('0',16,'0'),
                                                LPAD(p.cuenta_bancolombia,16,'0'),(CASE WHEN p.tipo_cuenta = 'DAVIPLATA' THEN 'DP' ELSE 'CA' END),
                                                '000051',LPAD(ROUND(total),16,'0'),'00','000000','02','1','9999',LPAD('0',41,'0'),LPAD('0',40,'0')) dato
                                        FROM   contratospernominas n, contratospersonas p
                                        WHERE  n.periodosliquidacion_id = #{periodo}
                                        AND    n.contrato_id = #{contrato}
                                        AND    n.contratosgrupo_id = #{contratogrupo}
                                        AND    n.contratospersona_id = p.id
                                        AND    p.tipo_cuenta = '#{tipocuenta}'
                                        AND    p.banco = '#{entidad}'
                                        AND    n.total > 0"])
          objetostotal = Objeto.find_by_sql(["SELECT SUM(ROUND(n.total)) total1
                                        FROM   contratospernominas n, contratospersonas p
                                        WHERE  n.periodosliquidacion_id = #{periodo}
                                        AND    n.contrato_id = #{contrato}
                                        AND    n.contratosgrupo_id = #{contratogrupo}
                                        AND    n.contratospersona_id = p.id
                                        AND    p.tipo_cuenta = '#{tipocuenta}'
                                        AND    p.banco = '#{entidad}'
                                        AND    n.total > 0"])[0].total1 rescue nil
                                                                      
          rutaupload = "#{::Rails.root}/public/#{entidad}_#{nombegrupo.to_s}_#{tipocuenta.to_s}_#{Time.now.strftime("%Y%m%d")}_#{objetostotal.to_s}.txt"
          File.delete(rutaupload) rescue nil
          File.open(rutaupload, "w") do |the_file|
            objetos.each do |dat|
              the_file.write dat.dato.to_s + "\r\n"
            end
            the_file.close
          end
          send_file rutaupload, type: "text/plain", x_sendfile: true
      elsif entidad.to_s == "BANCO DE BOGOTA"
        ActiveRecord::Base.connection.execute("UPDATE contratospersonas SET nombre_completo = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(nombre_completo,'Ñ','N'),'Á','A'),'É','E'),'Í','I'),'Ó','O'),'Ú','U')
                                               WHERE  banco = 'BANCO DE BOGOTA'")
       #LPAD('8110442538',11,'0'),'001','0000',DATE_FORMAT(CURDATE(),'%%Y%%m%%d'),'114','N',LPAD(' ',48,' '),'N',LPAD(' ',80,' ')) dato                                        
        objetos = Objeto.find_by_sql(["SELECT CONCAT('1',DATE_FORMAT(CURDATE(),'%%Y%%m%%d'),'000000000000000000000000','1','000000',LPAD('114239866',11,'0'),RPAD('ASEAR ESP S.A.S',40,' '),
                                                     LPAD('8110442538',11,'0'),'001','0000',DATE_FORMAT(CURDATE(),'%%Y%%m%%d'),'114','N',LPAD(' ',40,' '),LPAD(' ',80,' '),'N',LPAD(' ',8,' ')) dato
                                        UNION ALL
                                        SELECT CONCAT('2C',LPAD(p.identificacion,11,'0'),RPAD(SUBSTR(p.nombre_completo,1,40),40,' '),'02',
                                                RPAD(p.cuenta_bancolombia,17,' '),LPAD(ROUND(n.total),16,'0'),'00','A','000','001','0000',RPAD('PAGO DE NOMINA',80,' '),
                                                '0',LPAD(n.id,10,'0'),'N',
                                                LPAD(' ',8,' '),LPAD(' ',16,' '),'  ',LPAD(' ',22,' '),'N',LPAD(' ',8,' ')) dato
                                        FROM   contratospernominas n, contratospersonas p
                                        WHERE  n.periodosliquidacion_id = #{periodo}
                                        AND    n.contrato_id = #{contrato}
                                        AND    n.contratosgrupo_id = #{contratogrupo}
                                        AND    n.contratospersona_id = p.id
                                        AND    p.banco = '#{entidad}'
                                        AND    n.total > 0"])
        rutaupload = "#{::Rails.root}/public/#{entidad}_#{nombegrupo.to_s}_#{Time.now.strftime("%Y%m%d")}.txt"
        File.delete(rutaupload) rescue nil
        File.open(rutaupload, "w") do |the_file|
          objetos.each do |dat|
            the_file.write dat.dato.to_s + "\r\n"
          end
          the_file.close
        end
        send_file rutaupload, type: "text/plain", x_sendfile: true
      else
        objetos = Objeto.find_by_sql([" SELECT CONCAT('NOMBRE EMPRESA',';','GRUPO DE NOMINA',';','IDENTIFICACION EMPLEADO',';','NOMBRE EMPLEADO',';','NRO DE CUENTA',';','ENTIDAD',';','TIP0 DE CUENTA',';','VALOR A PAGAR') dato
                                        UNION ALL
                                        SELECT a.dato
                                        FROM (SELECT n.id, CONCAT(e.nombre,';',g.descripcion,';',p.identificacion,';',p.nombre_completo,';',p.cuenta_bancolombia,';',p.banco,';',p.tipo_cuenta,';',ROUND(n.total)) dato
                                              FROM   contratospernominas n, contratospersonas p, contratosgrupos g, contratos c, empresas e
                                              WHERE  n.periodosliquidacion_id = #{periodo}
                                              AND    n.contrato_id = #{contrato}
                                              AND    n.contratosgrupo_id = #{contratogrupo}
                                              AND    n.contratospersona_id = p.id
                                              AND    n.contratosgrupo_id = g.id
                                              AND    n.contrato_id = c.id
                                              AND    c.empresa_id = e.id
                                              AND    p.banco = '#{entidad}'
                                              AND    n.total > 0
                                              ORDER BY n.id) a"])
        rutaupload = "#{::Rails.root}/public/#{entidad}_#{nombegrupo.to_s}_#{Time.now.strftime("%Y%m%d")}.txt"
        crc32 = []
        File.delete(rutaupload) rescue nil
        File.open(rutaupload, "w") do |the_file|
          objetos.each do |dat|
            the_file.write dat.dato.to_s + "\r\n"
          end
          the_file.close
        end
        send_file rutaupload, type: "text/plain", x_sendfile: true
      end
    elsif entidad.to_s == "TODOS" and periodo.to_s != ""
      objetos = Objeto.find_by_sql([" SELECT CONCAT('NOMBRE EMPRESA',';','GRUPO DE NOMINA',';','IDENTIFICACION EMPLEADO',';','NOMBRE EMPLEADO',';','NRO DE CUENTA',';','ENTIDAD',';','TIP0 DE CUENTA',';','VALOR A PAGAR') dato
                                        UNION ALL
                                        SELECT a.dato
                                        FROM (SELECT n.id, CONCAT(e.nombre,';',g.descripcion,';',p.identificacion,';',p.nombre_completo,';',p.cuenta_bancolombia,';',p.banco,';',p.tipo_cuenta,';',ROUND(n.total)) dato
                                              FROM   contratospernominas n, contratospersonas p, contratosgrupos g, contratos c, empresas e
                                              WHERE  n.periodosliquidacion_id = #{periodo}
                                              AND    n.contratospersona_id = p.id
                                              AND    n.contratosgrupo_id = g.id
                                              AND    n.contrato_id = c.id
                                              AND    c.empresa_id = e.id
                                              AND    p.banco NOT IN ('DAVIVIENDA','AVVILLAS','BANCOLOMBIA')
                                              AND    n.estado = 'CONSOLIDADO'
                                              AND    n.total > 0
                                              ORDER BY n.id) a"])
      rutaupload = "#{::Rails.root}/public/TodosPeriodo_#{Time.now.strftime("%Y%m%d")}.txt"
      crc32 = []
      File.delete(rutaupload) rescue nil
      File.open(rutaupload, "w") do |the_file|
        objetos.each do |dat|
          the_file.write dat.dato.to_s + "\r\n"
        end
        the_file.close
      end
      send_file rutaupload, type: "text/plain", x_sendfile: true
    else
      redirect_to root_path
    end
  end

  def etapar
    params[:etapae].blank? ? @etapae = 'P' : @etapae = params[:etapae]
    if params[:etapa].to_s != ""
      User.where(id: is_admin).update_all(etapa: params[:etapa].to_s, updated_at: Time.now)
    end
    redirect_to contratospernominas_path(etapae: @etapae)
  end

  def etapars
    params[:etapae].blank? ? @etapae = 'P' : @etapae = params[:etapae]
    if params[:subetapa].to_s != ""
      User.where(id: is_admin).update_all(subetapa: params[:subetapa].to_s, updated_at: Time.now)
    end
    redirect_to contratospernominas_path(etapae: @etapae)
  end

  def self.rake_alegra
    cc = Contratospernomina.where(["periodosliquidacion_id IN (SELECT id FROM periodosliquidaciones WHERE DATE_FORMAT(inicio,'%Y-%m') = DATE_FORMAT(DATE_ADD(NOW(), INTERVAL -10 DAY),'%Y-%m')
                                                                AND DATE_FORMAT(inicio,'%Y-%m') != DATE_FORMAT(NOW(),'%Y-%m'))
                                    AND legalstatus_alegra = 'ACCEPTED'"]).select("DISTINCT 'X' dato")[0].dato.to_s rescue nil
    if cc.present? == false
      mensaje = "ASEAR: Nomina Electronica aun no enviada a la DIAN. Pilas!"
      Userspermiso.where("objeto_id = 126").each do |a|
        Asearsms::SendsmsServices.new.send_sms_users(a.user_id, mensaje)
      end
    end
  end

  private

  def set_layout
    if ['index', 'new'].include?(action_name)
      'application_admin'
    elsif ['edit'].include?(action_name)
      'application_admin'
    elsif ['tirilla','tirilla_masive'].include?(action_name)
      'blank'
    else
      "application_admin"
    end
  end

  def set_contratospernomina
    @contratospernomina = Contratospernomina.find(params[:id])
  end

  def contratospernomina_params
    params.require(:contratospernomina).permit!
  end
end
