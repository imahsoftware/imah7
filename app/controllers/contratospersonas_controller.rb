class ContratospersonasController < ApplicationController
  before_action :set_contratospersona, only: [:show, :edit, :update, :destroy]

  layout :set_layout
  before_action :checkaccess, except: ["update2"]

  def get_contratospersona_contrato_id
    @contrato = params[:ubicacion_contrato_id]
    @contratosgrupos = Contratosgrupo.where(contrato_id: @contrato) if @contrato
    respond_to { |format| format.js }
  end

  def update2
    isadmin = is_admin
    ActiveRecord::Base.connection.execute("insert into userspermisos (user_id,objeto_id,created_at,updated_at)
                                               values (#{isadmin},59,now(),now())")
    @contratospersona = Contratospersona.find(params[:id])
    valores_anteriores = @contratospersona.attributes.slice(*contratospersona_params.keys)
    @contratospersona.user_act = isadmin

    respond_to do |format|
      if @contratospersona.update(contratospersona_params)
        observacion = ""

        contratospersona_params.each do |attr, value|
          if value != valores_anteriores[attr]
            observacion += "CAMPO #{attr.to_s} : #{valores_anteriores[attr]} || "
          end
        end

        if observacion.present?
          Contratospernota.create(contratospersona_id: @contratospersona.id,fecha: DateTime.now,user_act: isadmin,
                                  observacion: observacion.chomp(" // "))
        end

        ActiveRecord::Base.connection.execute("delete from userspermisos where user_id = #{isadmin} and objeto_id = 59")

        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratospersona } }
      end
    end
  end

  def hojavida
    @contratospersona = Contratospersona.find(params[:id])
    respond_to do |format|
      format.pdf { render pdf: "Hoja de Vida #{@contratospersona.identificacion}", template: "contratospersonas/hojavida.html.erb", encoding: "UTF-8",
                          page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 } }
    end
  end

  def inventario_items
    @contratospersona = Contratospersona.find(params[:id])
    respond_to do |format|
      format.pdf { render pdf: "Inventario_#{@contratospersona.identificacion}", template: "contratospersonas/inventario_items.html.erb", encoding: "UTF-8",
                          page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 } }
    end
  end

  def inventario_items_ind
    @contratosperinventario = Contratosperinventario.find(params[:id])
    @contratospersona = @contratosperinventario.contratospersona
    respond_to do |format|
      format.pdf { render pdf: "Inventario_#{@contratosperinventario.contratospersona.identificacion}", template: "contratospersonas/inventario_items_ind.html.erb", encoding: "UTF-8",
                          page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 } }
    end
  end

  def inventario_items_contrato
    @contratosperfecha = Contratosperfecha.find(params[:contratosperfecha_id])
    @contratospersona = @contratosperfecha.contratospersona
    respond_to do |format|
      format.pdf { render pdf: "Inventario_#{@contratospersona.identificacion}", template: "contratospersonas/inventario_items_contrato.html.erb", encoding: "UTF-8",
                          page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 } }
    end
  end

  def self.hojavida_att(idPersona)
    @contratospersona = Contratospersona.find(idPersona)
    fname = "HojadeVida_#{@contratospersona.identificacion}"
    rutafact = "#{::Rails.root}/public/archivos/pdf/"
    rutanamefile = "#{::Rails.root}/public/archivos/pdf/#{fname}.pdf"
    system("rm -r #{rutanamefile}") rescue nil

    pdf = ApplicationController.render pdf: "#{fname}", template: "contratospersonas/hojavida_att.html.erb", :save_to_file => rutanamefile, :save_only => true,
                                       encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 },
                                       locals: { object: @contratospersona.id }
    save_path = Rails.root.join(rutafact, "#{fname}.pdf")
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
    file = File.open("#{::Rails.root}/public/archivos/pdf/#{fname}.pdf", 'rb')
    @contratosperimagen = Contratosperimagen.new
    @contratosperimagen.contratospersona_id = @contratospersona.id
    @contratosperimagen.user_id = 1
    @contratosperimagen.personasimagen = file
    @contratosperimagen.descripcion = 'HOJA DE VIDA'
    @contratosperimagen.estado = 'APROBADO'
    @contratosperimagen.save(validate: false)
    system("rm -r #{rutanamefile}") rescue nil
  end

  def searchevaluacion
    @isadmin = is_admin
    @idContrato = User.find(@isadmin).contrato_id
    @vcAutoCon = is_auth_c('empleadosconsulta')
    @vcAutoConb = is_auth_c('empleadosconsultabasica')
    @etapa = params[:etapa].present? ? params[:etapa] : @mes.to_s
    @anno = Time.now.strftime("%Y")
    @mes = params[:mes]
    @paginador = eval("params[:mes_#{params[:mes]}]")
    nroreg = 10
    if params[:nombre].to_s != ""
      @contratospersonas = Contratospersona.search(params[:nombre], @isadmin, @paginador, nroreg, @vcAutoCon, @vcAutoConb, @idContrato)
    else
      @periodolimite = Periodosliquidacion.where("fecha_limite IS NOT NULL AND DATE_FORMAT(fecha_limite, '%Y') = '#{@anno}'AND DATE_FORMAT(fecha_limite, '%m') = '#{@mes}' AND termino = 'MENSUAL' AND estado = 'P'").first
      @meses = [(Time.now - 1.month).strftime("%m"), Time.now.strftime("%m")]
      @contratospersonas = Contratospersona.where("id in (select contratospersona_id from contratosperusers where user_id = #{@isadmin} and fecha_fin is null)").paginate(:page => @paginador, :per_page => 15)
    end
  end

  def evaluacion_pdf
    @contratospersona = Contratospersona.find(params[:id])
    @periodos = Contratosperactob.select("user_interventor, (select concat(identificacion,' - ',nombre) from users where id = contratosperactobs.user_interventor) nombreinter, anno, mes").where("contratospersona_id = #{@contratospersona.id}").distinct.order("anno, mes asc")
    respond_to do |format|
      format.pdf { render pdf: "Evaluacion_#{@contratospersona.identificacion}", template: "contratospersonas/evaluacion_pdf.html.erb", encoding: "UTF-8",
                          page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 }, disposition: 'attachment' }
    end
  end

  def crear_cotizante
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratospersona.errores_aportes_linea = nil
    @contratospersona.save(validate: false)
    code = WsAportesController.creacion_cotizante_individual(@contratospersona, is_portafolio)
    flash[:notice] = "Proceso Ejecutado con exito!!!!"
    redirect_to edit_contratospersona_path(id: @contratospersona.id, etapa: 'A')
  end

  def buscar; end

  def proceso
    contrato = params[:ubicacion][:contrato_id].to_s rescue ""
    contratosgrupo = params[:contratospersona][:contratosgrupo_id].to_s rescue ""
    interventor = params[:contratospersona][:user_interventor].to_s rescue ""
    accion = params[:contratospersona][:tipo_usuario].to_s rescue ""
    if contrato != "" and contratosgrupo != "" and interventor != "" and accion != ""
      ActiveRecord::Base.connection.execute("CALL prc_supervisores(#{contrato},#{contratosgrupo},#{interventor},'#{accion}')")
      ActiveRecord::Base.connection.execute("CALL prc_validasupervisores()")
      flash[:notice] = "Se ha realizado el proceso con Exito!!!"
    else
      flash[:warning] = "Para el proceso de Asignación / Retiro de supervisores, debes seleccionar todos los campos!!!"
    end
    redirect_to buscar_contratospersonas_path
  end

  def checkaccess
    dato = Objeto.find_by_sql("SELECT 1 FROM controlpendiente WHERE user_id = #{is_admin}")[0] rescue nil
    return is_permit('contratospersonas')
  end

  def index
    isadmin = is_admin
    if [15910,4561,4998,22117].exclude?(isadmin) 
      dato = Objeto.find_by_sql("SELECT DISTINCT 'X' existe FROM viw_consolidabloqueo WHERE user_id = #{isadmin}")[0] rescue nil
    end
    if dato.present?
      flash[:warning] = 'Hola!!! Para donde vas si no has terminado los temas pendientes'
      redirect_to root_path
    else
      @idContrato = User.find(isadmin).contrato_id
      @vcAutoCon = is_auth_c('empleadosconsulta')
      @vcContratospersona = is_auth_c('contratospersona')
      @vcAutoConb = is_auth_c('empleadosconsultabasica')
      if isadmin == 1
        @vcAutoTraslado = true
      else
        @vcAutoTraslado = is_auth_c('contratosperfact')
      end
      @existesuper = Contratosperuser.where("user_id = ? and fecha_fin is null", isadmin).exists?
      if @existesuper
        @asignacionesnuevas = Contratosperuser.includes([:contratospersona])
                                              .where("user_id = ? and DATE_FORMAT(fecha_inicio,'%Y-%m') BETWEEN DATE_FORMAT(DATE_ADD(CURDATE(),INTERVAL -1 MONTH),'%Y-%m') AND DATE_FORMAT(DATE_ADD(CURDATE(),INTERVAL 1 MONTH),'%Y-%m') and fecha_fin is null", isadmin)
                                              .order("fecha_inicio desc")

        @docsinfirmar = Contratosperfecha.find_by_sql("SELECT p.autobuscar nombreempleado, e.autobuscar identnombre,p.movil,c.nro_contrato,cf.tipo_documento, cf.created_at
                                                       FROM   contratosperusers u, contratospersonas p, contratosperfechas f, controlfirmas cf, contratos c, empresas e
                                                       WHERE  u.user_id = #{isadmin}
                                                       AND    u.contratospersona_id = p.id
                                                       AND    u.fecha_fin IS NULL
                                                       AND    p.id = f.contratospersona_id
                                                       AND    f.estado = 'ACTIVO'
                                                       AND    f.id = cf.id_registro
                                                       AND    cf.fecha_firma IS NULL
                                                       AND    f.contrato_id = c.id
                                                       AND    c.empresa_id = e.id
                                                       UNION
                                                       SELECT  p.autobuscar nombreempleado, e.autobuscar identnombre,p.movil,c.nro_contrato, 'FIRMA DE CONTRATO', f.created_at
                                                       FROM   contratosperusers u, contratospersonas p, contratosperfechas f, contratos c, empresas e
                                                       WHERE  u.user_id = #{isadmin}
                                                       AND    u.contratospersona_id = p.id
                                                       AND    u.fecha_fin IS NULL
                                                       AND    p.id = f.contratospersona_id
                                                       AND    f.estado = 'ACTIVO'
                                                       AND    f.sol_firma_digital = 'SI'
                                                       AND    f.contrato_id = c.id
                                                       AND    c.empresa_id = e.id
                                                       ORDER BY 1")
        @procesosencurso = Contratosperfecha.find_by_sql("SELECT p.autobuscar nombreempleado, e.autobuscar identnombre,p.movil,c.nro_contrato,cf.clase,cf.created_at,
                                                                (select distinct 'X' from contratosperprosanciones where contratosperproceso_id = cf.id and desvinculacion = 'SI') desvinc
                                                       FROM   contratosperusers u, contratospersonas p, contratosperfechas f, contratosperprocesos cf, contratos c, empresas e
                                                       WHERE  u.user_id = #{isadmin}
                                                       AND    u.contratospersona_id = p.id
                                                       AND    u.fecha_fin IS NULL
                                                       AND    p.id = f.contratospersona_id
                                                       AND    f.estado = 'ACTIVO'
                                                       AND    f.id = cf.contratosperfecha_id
                                                       AND    cf.estado != 'FINALIZADO'
                                                       AND    f.contrato_id = c.id
                                                       AND    c.empresa_id = e.id
                                                       ORDER BY 1,6 desc")
        @vacacionesencurso = Contratosperfecha.find_by_sql("SELECT DISTINCT p.autobuscar nombreempleado, e.autobuscar identnombre,p.movil,c.nro_contrato,cf.fecha_inicio, cf.fecha_fin_disfrute fecha_fin
                                                          FROM   contratosperusers u, contratospersonas p, contratosperfechas f, contratospervacaciones cf, contratos c, empresas e
                                                          WHERE  u.user_id = #{isadmin}
                                                          AND    u.contratospersona_id = p.id
                                                          AND    u.fecha_fin IS NULL
                                                          AND    p.id = f.contratospersona_id
                                                          AND    f.estado = 'ACTIVO'
                                                          AND    f.id = cf.contratosperfecha_id
                                                          AND    cf.estado != 'FINALIZADO'
                                                          AND    f.contrato_id = c.id
                                                          AND    c.empresa_id = e.id
                                                          AND    NOW() BETWEEN DATE_ADD(cf.fecha_inicio, INTERVAL -10 DAY)  AND DATE_ADD(cf.fecha_fin, INTERVAL 3 DAY) 
                                                          ORDER BY 1,6 DESC")
      end
      if isadmin == 5510
        @existesuper = true
        @asignacionesnuevas = Contratosperuser.includes([:contratospersona])
                                              .select(:contratospersona_id)
                                              .where("DATE_FORMAT(fecha_inicio,'%Y-%m') BETWEEN DATE_FORMAT(DATE_ADD(CURDATE(),INTERVAL -1 MONTH),'%Y-%m') AND DATE_FORMAT(DATE_ADD(CURDATE(),INTERVAL 1 MONTH),'%Y-%m') and fecha_fin is null and contratospersona_id in (select contratospersona_id from contratosperfechas where contrato_id = 24)")
                                              .distinct
      end
      nroreg = 10
      if params[:nombre].to_s != ""
        @contratospersonas = Contratospersona.search(params[:nombre], isadmin, params[:page], nroreg, @vcAutoCon, @vcAutoConb, @idContrato)
      else
        @contratospersonas = Contratospersona.where(identificacion: -1)
      end
      respond_to do |format|
        @contratospersonas.present? ?
          flash[:notice] = "Total de registros encontrados #{@contratospersonas.count}" :
          flash[:notice] = "No hay resultado de la busqueda"
        format.js
        format.html
      end
    end
  end

  def novedad
    # Esto me permite conocer el id de contratosperfecha_id al que se esta haciendo la novedad...
    ActiveRecord::Base.connection.execute("update contratospersonas set idperfecha = #{params[:contratosperfecha_id]}
                                           where  id = #{params[:id]}")
    @contratospersona = Contratospersona.find(params[:id])
  end

  def procesos
    # Esto me permite conocer el id de contratosperfecha_id al que se esta haciendo la novedad...
    ActiveRecord::Base.connection.execute("update contratospersonas set idperfecha = #{params[:contratosperfecha_id]}
                                               where  id = #{params[:id]}")
    @contratospersona = Contratospersona.find(params[:id])
  end

  def inventario
    ActiveRecord::Base.connection.execute("update contratospersonas set idperfecha = #{params[:contratosperfecha_id]}
                                               where  id = #{params[:id]}")
    @contratospersona = Contratospersona.find(params[:id])
    @contratosperfecha = Contratosperfecha.find(params[:contratosperfecha_id])
  end

  def evaluacion
    anno = params[:anno].to_s # Time.now.strftime("%Y")
    mes = params[:mes].to_s # Time.now.strftime("%m")
    @anno = anno
    @mes = mes
    @periodolimite = Periodosliquidacion.where("fecha_limite IS NOT NULL AND DATE_FORMAT(fecha_limite, '%Y') = '#{anno}'AND DATE_FORMAT(fecha_limite, '%m') = '#{mes}' AND termino = 'MENSUAL' AND estado = 'P'").first
    isadmin = is_admin
    @contratospersona = Contratospersona.find(params[:id])
    @contratosperfecha = Contratosperfecha.find(params[:contratosperfecha_id])
    # SI NO ESTA PRESENTE INGRESA SE CREA
    if !is_sygma
      if !Contratosperactob.where("anno = '#{anno}' and mes = '#{mes}' and user_interventor = #{isadmin} and contratosperfecha_id = #{@contratosperfecha.id}").present?
        Contratoscargosact.where("contratoscargo_id = #{@contratosperfecha.contratoscargo_id} and estado = 'ACTIVO'").each do |contratoscargosact|
          contratosperactob = Contratosperactob.new
          contratosperactob.anno = anno
          contratosperactob.mes = mes
          contratosperactob.user_interventor = isadmin
          contratosperactob.contratospersona_id = @contratospersona.id
          contratosperactob.contratosperfecha_id = @contratosperfecha.id
          contratosperactob.contratoscargo_id = @contratosperfecha.contratoscargo_id
          contratosperactob.contratoscargosact_id = contratoscargosact.id
          contratosperactob.save(validate: false)
        end
      end
      @contratosperactobs = Contratosperactob.where("anno = '#{anno}' and mes = '#{mes}' and user_interventor = #{isadmin} and contratosperfecha_id = #{@contratosperfecha.id}")
    else
      @contratosperactobs = Contratosperactob.where("anno = '#{anno}' and mes = '#{mes}' and contratosperfecha_id = #{@contratosperfecha.id}")
    end
  end

  def evaluacion_masiva
    @isadmin = is_admin
    @anno = Time.now.strftime("%Y")
    if Time.now.strftime("%d").to_i <= 5
      @mes = (Time.now - 2.month).strftime("%m")
    else
      @mes = (Time.now - 2.month).strftime("%m") # Time.now.strftime("%m")
    end
    # @etapa = params[:etapa].present? ? params[:etapa] : @mes.to_s
    @etapa = params[:etapa].present? ? params[:etapa] : Time.now.strftime("%m").to_s
    @paginador = eval("params[:mes_#{@etapa}]")
    @periodolimite = Periodosliquidacion.where("fecha_limite IS NOT NULL AND DATE_FORMAT(fecha_limite, '%Y') = '#{@anno}'AND DATE_FORMAT(fecha_limite, '%m') = '#{@mes}' AND termino = 'MENSUAL' AND estado = 'P'").first
    if Parametro.find(22).valor.to_s == 'NO'
      @meses = [(Time.now - 2.month).strftime("%m"), (Time.now - 1.month).strftime("%m"), Time.now.strftime("%m")]
    else
      @meses = ["99"]
    end
    @contratospersonas = Contratospersona.where("id in (select contratospersona_id from contratosperusers where user_id = #{@isadmin} and fecha_fin is null)").paginate(:page => @paginador, :per_page => 15)
  end

  def evaluacion_documento
    @isadmin = is_admin
    @contratosperimagenes = Contratosperimagen.where("estado in ('PENDIENTE') and descripcion in (select descripcion from iparametros where id in (select iparametro_id from iparametrosusers where user_id = #{@isadmin}))").order("id asc")
  end

  def new
    @etapap = params[:etapap].present? ? params[:etapap] : '1'
    @contratospersona = Contratospersona.new
    @contratospersona.etapa = 'A'
    @contratospersona.contrato_id = params[:contrato_id]
    render "contratospersona_form"
  end

  def edit
    @etapap = params[:etapap].present? ? params[:etapap] : '1'
    isadmin = is_admin
    @cadper = []
    Userspermiso.joins(:objeto).where(["userspermisos.user_id = #{isadmin} and objetos.descripcion like 'contratosperopc%%'"]).select("replace(objetos.descripcion,'contratosperopc','') descr").each do |a|
      @cadper << a.descr
    end
    idContrato = User.find(isadmin).contrato_id.to_s rescue nil

    if idContrato.to_s != ""
      if !Contratosperfecha.where(contratospersona_id: @contratospersona.id, contrato_id: idContrato).exists?
        flash[:warning] = 'Usted no tiene Acceso a este empleado'
        redirect_to root_path
      else
        respond_to do |format|
          format.html { render :action => "contratospersona_form" }
        end
      end
    else
      respond_to do |format|
        format.html { render :action => "contratospersona_form" }
      end
    end
  end

  def visitas
    @contratospersona = Contratospersona.find(params[:id])
  end

  def create
    @contratospersona = Contratospersona.new(contratospersona_params)
    @contratospersona.etapa = 'A'
    @contratospersona.user_id = is_admin
    respond_to do |format|
      if @contratospersona.save
        format.html { redirect_to edit_contratospersona_path(etapa: "A", id: @contratospersona.id), notice: "El registro ha sido registrado con Exito." }
      else
        @contratospersona.etapa = 'A'
        @etapap = '1'
        format.html { render "contratospersona_form" }
      end
    end
  end

  def update
    @etapap = params[:etapap].present? ? params[:etapap] : '1'
    @contratospersona.user_act = is_admin
    if @contratospersona.update(contratospersona_params)
      flash[:notice] = "Actualizado con Exito"
      ActiveRecord::Base.connection.execute("update contratospersonas set tienecontrato = 'NO'
                                             where  id = #{@contratospersona.id}
                                             and    identificacion = identificacion2
                                             and    fecha_nacimiento = fecha_nacimiento2
                                             and    tienecontrato is null")
      redirect_to edit_contratospersona_path(id: @contratospersona.id, etapap: @etapap, etapa: 'A')
    else
      @contratospersona.etapa = 'A'
      render "contratospersona_form"
    end
  end

  def destroy
    idEmpresa = @contratospersona.contrato_id
    @contratospersona.destroy
    flash[:notice] = "El registro ha sido borrado con Exito."
    redirect_to edit_contrato_path(id: idEmpresa, etapa: 'A')
  end

  def cambioestado
    if params[:estado].to_s == 'FINALIZA CONTRATO'
      ActiveRecord::Base.connection.execute("update contratospersonas set tienecontrato = 'SI' where id = #{params[:id]}")
      Contratosperbitacora.create(contratospersona_id: params[:id], user_id: is_admin, estado: 'FINALIZA CONTRATO')
      redirect_to root_path
    elsif params[:estado].to_s == 'ENTREGA DOTACION'
      ActiveRecord::Base.connection.execute("update contratospersonas set dotacion = 'SI' where id = #{params[:id]}")
      Contratosperbitacora.create(contratospersona_id: params[:id], user_id: is_admin, estado: 'ENTREGA DOTACION')
      redirect_to root_path
    elsif params[:estado].to_s == 'ENTREGA CARNET'
      ActiveRecord::Base.connection.execute("update contratospersonas set carnet = 'SI' where id = #{params[:id]}")
      Contratosperbitacora.create(contratospersona_id: params[:id], user_id: is_admin, estado: 'ENTREGA CARNET')
      redirect_to root_path
    end
  end

  def controluser
    idUser = params[:id]
    control = params[:control]
    ctid = params[:ctid]
    @user = User.find(idUser)
    if control == 'inactivaruser'
      @user.activo = 'N'
      @user.save(validate: false)
      flash['success'] = "Usuario inactivado correctamente"
    elsif control == 'activaruser'
      @user.activo = 'S'
      @user.failed_attempts = 0
      @user.unlock_token = nil
      @user.locked_at = nil
      @user.save
      flash['success'] = "Usuario activado correctamente"
    elsif control == 'desbloquearusuario'
      @user.activo = 'S'
      @user.failed_attempts = 0
      @user.unlock_token = nil
      @user.locked_at = nil
      @user.save(validate: false)
      flash['success'] = "Usuario Desbloqueado correctamente"
    elsif control == 'restableceyenvia'
      @user.activo = 'S'
      @user.failed_attempts = 0
      @user.unlock_token = nil
      @user.locked_at = nil
      @user.sign_in_count = 0
      @user.password = @user.identificacion
      @user.password_confirmation = @user.identificacion
      @user.save(validate: false)
      flash['success'] = "Clave usuario restablecida correctamente"
    end
    redirect_to edit_contratospersona_path(id: ctid, etapap: 1, etapa: 'A')
  end

  def verdocumentos
    @contratosperfecha = Contratosperfecha.find(params[:id])
  end

  def get_contratospersona_genero
    @contratospersona_genero = params[:contratospersona_genero] if params[:contratospersona_genero].present? && ["Seleccione"].exclude?(params[:contratospersona_talla_pantalon])

    if @contratospersona_genero == 'FEMENINO'
      @tipo = "pantalon_mujer"
      @tipo2 = "camisa_mujer"
    else
      @tipo = "pantalon_hombre"
      @tipo2 = "camisa_hombre"
    end
    @iparametros = Iparametro.where(campo: @tipo) if @contratospersona_genero
    @iparametroscamisas = Iparametro.where(campo: @tipo2) if @contratospersona_genero
    respond_to { |format| format.js }
  end

  private

  def set_layout
    if ['index', 'new', 'evaluacion_masiva'].include?(action_name)
      'application_admin'
    elsif ['edit'].include?(action_name)
      'application_contratospersonas'
    elsif ['validacion'].include?(action_name)
      "inscripcion_layout"
    else
      "application_admin"
    end
  end

  def set_contratospersona
    params[:etapa].to_s != "" ? Contratospersona.find(params[:id]).update_columns(etapa: params[:etapa].to_s) : nil
    @contratospersona = Contratospersona.find(params[:id])
  end

  def contratospersona_params
    params.require(:contratospersona).permit!
  end
end

