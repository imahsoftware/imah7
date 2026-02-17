class ControlfirmasController < ApplicationController

  layout :set_layout

  def index
    isadmin = is_admin
    @usr = User.find(isadmin)
    contratospersonaId = -1
    if @usr.contratospersona_id.present?
      contratospersonaId = @usr.contratospersona_id
    end
    @procesos = Contratosperproceso.where("firma_usuario is null and contratospersona_id = #{contratospersonaId}") rescue nil
    @testigos1 = Contratosperproceso.where("firma_testigo1 is null and user_testigo1 = #{@usr.id}") rescue nil
    @testigos2 = Contratosperproceso.where("firma_testigo2 is null and user_testigo2 = #{@usr.id}") rescue nil
    if Contratosperfecha.where("contratospersona_id = #{contratospersonaId} and sol_firma_digital = 'SI'").present?
      @existeContratoPendiente = 'SI'
    elsif Controlfirma.where("estado = 'PENDIENTE' and user_firma = #{isadmin}").present?
      @existeContratoFirmaPendiente = 'SI'
    elsif @procesos.present? || @testigos1.present? || @testigos2.present?
      @existeControlProceso = 'SI'
    elsif Objeto.find_by_sql("SELECT * FROM view_compromisossinatender WHERE user_id = #{@usr.id}").present?
      @existeCompromisos = 'SI'
    else
      redirect_to root_path
    end
  end

  def bloqueofirma
    isadmin = is_admin
    @userbloqueo = User.find(isadmin)
    exitNow = 'NO'
    if Parametro.where("id = 21 and valor = '#{@userbloqueo.id}'").present?
      @contratossinfirmar_cantidad = Objeto.find_by_sql("select cantidad from view_contratossinfirmar")[0].cantidad rescue 0
      @contratossinfirmar = Objeto.find_by_sql("SELECT DISTINCT e.nombre, c.`nro_contrato`, pe.`identificacion`, pe.`nombre_completo`, pe.`movil`,
                                                   pe.`correo`, p.`fecha_inicio`, p.fecha_fin
                                              FROM   contratosperfechas p, contratospersonas pe, contratos c, empresas e
                                              WHERE  p.sol_firma_digital = 'SI' and p.sol_firma_fecha < curdate()
                                              AND    p.estado = 'ACTIVO'
                                              AND    p.`contratospersona_id` = pe.id
                                              AND    p.contrato_id = c.`id`
                                              AND    c.`empresa_id` = e.id
                                              ORDER BY p.`fecha_inicio` ASC")
      if @contratossinfirmar_cantidad.to_i == 0
        exitNow = 'SI'
      end
    else
      exitNow = 'SI'
    end
    @docsinfirmar_cantidad =  Objeto.find_by_sql("SELECT cantidad FROM view_docsinfirmar WHERE user_id = #{@userbloqueo.id}")[0].cantidad rescue 0
    @docsinfirmar = Objeto.find_by_sql("SELECT DISTINCT c.tipo_documento, c.created_at fecha_solicitud_firma,
                                               e.nombre, ce.`nro_contrato`, pe.`identificacion`, pe.`nombre_completo`, pe.`movil`, pe.`correo`,
                                               p.`fecha_inicio`, p.fecha_fin
                                        FROM   controlfirmas c, contratosperfechas p, contratosperusers u, contratospersonas pe,
                                               contratos ce, empresas e
                                        WHERE  c.estado = 'PENDIENTE'
                                        AND    c.id_registro = p.id
                                        AND    p.estado = 'ACTIVO'
                                        AND    p.contratospersona_id = u.contratospersona_id
                                        AND    u.fecha_fin IS NULL
                                        AND    p.`contratospersona_id` = pe.id
                                        AND    p.contrato_id = ce.`id`
                                        AND    ce.`empresa_id` = e.id
                                        AND    u.user_id =  #{@userbloqueo.id}
                                        ORDER BY c.created_at ASC")
    #BLoqueo por Compromisos
    @compromisos = Objeto.find_by_sql("SELECT DISTINCT c.id,c.fecha_entrega fecha_solicitud_firma,
                                               e.nombre, ce.`nro_contrato`, pe.`identificacion`, pe.`nombre_completo`, pe.`movil`, pe.`correo`,
                                               p.`fecha_inicio`, p.fecha_fin,
                                               (select descripcion from parcargosdocs where id = c.parcargosdoc_id) tipo_documento,
                                               (select distinct 'X' from contratosperimagenes where compromiso_id = c.id) imagen
                                        FROM   compromisos c, contratosperfechas p, contratospersonas pe, contratos ce, empresas e
                                        WHERE  c.estado = 'PENDIENTE'
                                        and    (c.fecha_entrega - INTERVAL 2 DAY) <= CURDATE()
                                        AND    c.contratosperfecha_id = p.id
                                        AND    p.estado = 'ACTIVO'
                                        AND    p.`contratospersona_id` = pe.id
                                        AND    p.contrato_id = ce.`id`
                                        AND    ce.`empresa_id` = e.id
                                        and    (c.user_compromiso = #{@userbloqueo.id}  or c.user_contrato = #{@userbloqueo.id})
                                        union
                                        SELECT DISTINCT c.id,c.fecha_entrega fecha_solicitud_firma,
                                               e.nombre, ce.`nro_contrato`, pe.`identificacion`, pe.`nombre_completo`, pe.`movil`, pe.`correo`,
                                               p.`fecha_inicio`, p.fecha_fin,
                                               (select descripcion from parcargosdocs where id = c.parcargosdoc_id) tipo_documento,
                                               (select distinct 'X' from contratosperimagenes where compromiso_id = c.id) imagen
                                        FROM   compromisos c, contratosperfechas p, contratospersonas pe, contratos ce, empresas e, contratosperusers u
                                        WHERE  c.estado = 'PENDIENTE'
                                        and    (c.fecha_entrega + INTERVAL 2 DAY) <= CURDATE()
                                        AND    c.contratosperfecha_id = p.id
                                        AND    p.estado = 'ACTIVO'
                                        AND    p.`contratospersona_id` = pe.id
                                        AND    p.contrato_id = ce.`id`
                                        AND    ce.`empresa_id` = e.id
                                        and    c.contratospersona_id = u.contratospersona_id
                                        AND    u.fecha_fin IS NULL
                                        AND    u.user_id = #{@userbloqueo.id}
                                        ORDER BY 2 ASC")
    exitComp = 'NO'
    if Objeto.find_by_sql("SELECT * FROM view_compromisossinatender WHERE user_id = #{@userbloqueo.id}").present? == false
      exitComp = 'SI'
    end
    #bloque por Dotacion entregada no firmada
    @dotacion_cantidad =  Objeto.find_by_sql("SELECT cantidad FROM view_dotacionsinfirmar WHERE user_id = #{@userbloqueo.id}")[0].cantidad rescue 0

    @dotacion = Objeto.find_by_sql("SELECT DISTINCT c.fecha_entrega fecha_solicitud_firma,
                                               e.nombre, ce.`nro_contrato`, pe.`identificacion`, pe.`nombre_completo`, pe.`movil`, pe.`correo`,
                                               p.`fecha_inicio`, p.fecha_fin,null tipo_documento
                                    FROM   contratosperdotaciones c, contratosperfechas p, contratospersonas pe, contratos ce, empresas e, contratosperusers u
                                    WHERE  c.estado = 'ENTREGADO'
                                    and    c.fecha_entrega <= DATE_ADD(CURDATE(), INTERVAL -5 DAY)
                                    AND    c.contratosperfecha_id = p.id
                                    AND    p.estado = 'ACTIVO'
                                    AND    p.`contratospersona_id` = pe.id
                                    AND    p.contrato_id = ce.`id`
                                    AND    ce.`empresa_id` = e.id
                                    and    c.contratospersona_id = u.contratospersona_id
                                    AND    u.fecha_fin IS NULL
                                    AND    u.user_id = #{@userbloqueo.id}
                                    ORDER BY 1 ASC")
    exitDot = 'NO'
    if @dotacion.present? == false
      exitDot = 'SI'
    end
    #bloque por Dotacion sin recibir
    @dotacionsinr_cantidad =  Objeto.find_by_sql("SELECT cantidad FROM view_dotacionsinrecoger WHERE user_id = #{@userbloqueo.id}")[0].cantidad rescue 0
    @dotacionsinr = Objeto.find_by_sql("SELECT DISTINCT c.fecha_entrega fecha_solicitud_firma,
                                               e.nombre, ce.`nro_contrato`, pe.`identificacion`, pe.`nombre_completo`, pe.`movil`, pe.`correo`,
                                               p.`fecha_inicio`, p.fecha_fin, null tipo_documento
                                    FROM   contratosperdotaciones c, contratosperfechas p, contratospersonas pe, contratos ce, empresas e, contratosperusers u
                                    WHERE  c.estado = 'PENDIENTE' AND c.recogida = 'SI'
                                    AND    c.contratosperfecha_id = p.id
                                    AND    p.estado = 'ACTIVO'
                                    AND    p.`contratospersona_id` = pe.id
                                    AND    p.contrato_id = ce.`id`
                                    AND    ce.`empresa_id` = e.id
                                    and    c.contratospersona_id = u.contratospersona_id
                                    AND    u.fecha_fin IS NULL
                                    AND    u.user_id = #{@userbloqueo.id}
                                    ORDER BY 1 ASC")
    exitDotr = 'NO'
    if @dotacionsinr.present? == false
      exitDotr = 'SI'
    end
    #bloque por Capacitaciones sin Firmar
    @capa_cantidad =  Objeto.find_by_sql("SELECT cantidad FROM view_capacitacionescant WHERE user_id = #{@userbloqueo.id}")[0].cantidad rescue 0
    @capa = Objeto.find_by_sql("SELECT  DISTINCT a.created_at fecha_solicitud_firma,
                                        e.nombre, ce.`nro_contrato`, pe.`identificacion`, pe.`nombre_completo`, pe.`movil`, pe.`correo`,
                                        f.`fecha_inicio`, f.fecha_fin, cc.descripcion tipo_documento
                                FROM   contratoscapapersonas a, contratosperusers u, contratosperfechas f,
                                       contratospersonas pe, contratos ce, empresas e, capacitaciones cc
                                WHERE  a.contratospersona_id = u.contratospersona_id
                                AND    u.user_id = #{@userbloqueo.id}
                                AND    u.fecha_fin IS NULL
                                AND    a.contratosperfecha_id = f.id
                                AND    a.estado_evaluacion = 'INICIAR CAPACITACION'
                                AND    a.updated_at <= (CURDATE() + INTERVAL - (8)DAY)
                                AND    f.estado = 'ACTIVO'
                                AND    a.`contratospersona_id` = pe.id
                                AND    f.contrato_id = ce.`id`
                                AND    ce.`empresa_id` = e.id
                                AND    a.capacitacion_id = cc.id
                                ORDER BY 1 ASC")
    exitCap = 'NO'
    if @capa.present? == false
      exitCap = 'SI'
    end
    if Parametro.find(30).valor.to_s == 'SI'
      ActiveRecord::Base.connection.execute("delete from error")
      ActiveRecord::Base.connection.execute("insert into error values ('#{@userbloqueo.id} - @docsinfirmar_cantidad -> #{@docsinfirmar_cantidad}..')")
      ActiveRecord::Base.connection.execute("insert into error values ('#{@userbloqueo.id} - @docsinfirmar -> #{@docsinfirmar}..')")
      ActiveRecord::Base.connection.execute("insert into error values ('#{@userbloqueo.id} - @compromisos -> #{@compromisos}..')")
      ActiveRecord::Base.connection.execute("insert into error values ('#{@userbloqueo.id} - @dotacion_cantidad -> #{@dotacion_cantidad}..')")
      ActiveRecord::Base.connection.execute("insert into error values ('#{@userbloqueo.id} - @dotacion -> #{@dotacion}..')")
      ActiveRecord::Base.connection.execute("insert into error values ('#{@userbloqueo.id} - @dotacionsinr_cantidad -> #{@dotacionsinr_cantidad}..')")
      ActiveRecord::Base.connection.execute("insert into error values ('#{@userbloqueo.id} - @dotacionsinr -> #{@dotacionsinr}..')")
      ActiveRecord::Base.connection.execute("insert into error values ('#{@userbloqueo.id} - @capa_cantidad -> #{@capa_cantidad}..')")
      ActiveRecord::Base.connection.execute("insert into error values ('#{@userbloqueo.id} - exitNow -> #{exitNow}..')")
      ActiveRecord::Base.connection.execute("insert into error values ('#{@userbloqueo.id} - exitComp -> #{exitComp}..')")
      ActiveRecord::Base.connection.execute("insert into error values ('#{@userbloqueo.id} - exitDot -> #{exitDot}..')")
      ActiveRecord::Base.connection.execute("insert into error values ('#{@userbloqueo.id} - exitDotr -> #{exitDotr}..')")
      ActiveRecord::Base.connection.execute("insert into error values ('#{@userbloqueo.id} - exitCap -> #{exitCap}..')")
    end
    if exitNow == 'SI' and @docsinfirmar_cantidad.to_i == 0 and exitComp == 'SI' and exitDot == 'SI' and exitDotr == 'SI' and exitCap == 'SI'
      flash[:notice] = "UFFF que bien, ya no tienes temas pendientes!!! Muy Bien!!"
      redirect_to root_path
    end
  end

  def generar_otp
    @controlfirma = Controlfirma.find(params[:controlfirma_id])
    if @controlfirma.estado == 'PENDIENTE'
      @controlfirma.update(codigo_otp: nil, respuesta_otp: nil, codigo_otp2: nil, respuesta_otp2: nil, fecha_firma: nil)
    end
  end

  def generar_otp1
    @controlfirma = Controlfirma.find(params[:controlfirma_id])
    @contratosperfecha = Contratosperfecha.find(@controlfirma.id_registro)
    if @controlfirma.codigo_otp.blank?
      codigo = rand(100000..999999).to_s.gsub("0", "#{rand(1..9)}")
      mensaje = "ASEAR: Estimad@ #{@contratosperfecha.contratospersona.nombres}, se ha generado tu primer codigo para la firma del documento - #{codigo}".html_safe
      Asearsms::SendsmsServices.new.send_sms_otp(@contratosperfecha.id, mensaje, 'otp1')
      Asearmail::SendmailServices.new.sendEmailCodigo(@contratosperfecha.contratospersona.correo, "Primer codigo para la firma del documento", "asear_mailer/envio_codigo.html.erb", nil, nil, -1,codigo)
      @controlfirma.update(codigo_otp: codigo, respuesta_otp: nil, codigo_otp2: nil, respuesta_otp2: nil, fecha_firma: nil)
    end
  end

  def ws_otp
    nr1 = params[:nr1]
    nr2 = params[:nr2]
    nr3 = params[:nr3]
    nr4 = params[:nr4]
    nr5 = params[:nr5]
    nr6 = params[:nr6]
    @controlfirma = Controlfirma.find(params[:controlfirma_id])
    @contratosperfecha = Contratosperfecha.find(@controlfirma.id_registro)
    code = nr1 + nr2 + nr3 + nr4 + nr5 + nr6
    if code == @controlfirma.codigo_otp
      codigo = rand(100000..999999).to_s.gsub("0", "#{rand(1..9)}")
      mensaje = "ASEAR: Estimad@ #{@contratosperfecha.contratospersona.nombres}, se ha generado tu segundo codigo para la firma del documento - #{codigo}".html_safe
      Asearsms::SendsmsServices.new.send_sms_otp(@contratosperfecha.id, mensaje, 'otp2')
      Asearmail::SendmailServices.new.sendEmailCodigo(@contratosperfecha.contratospersona.correo, "Segundo codigo para la firma del documento", "asear_mailer/envio_codigo.html.erb", nil, nil, -1,codigo)
      @controlfirma.update(respuesta_otp: code, codigo_otp2: codigo)
      @valida = false
    else
      @valida = true
    end
  end

  def ws_otp2
    nr7 = params[:nr7]
    nr8 = params[:nr8]
    nr9 = params[:nr9]
    nr10 = params[:nr10]
    nr11 = params[:nr11]
    nr12 = params[:nr12]
    @controlfirma = Controlfirma.find(params[:controlfirma_id])
    code = nr7 + nr8 + nr9 + nr10 + nr11 + nr12
    if code == @controlfirma.codigo_otp2
      @codigoFirma = SecureRandom.hex
      @controlfirma.respuesta_otp2 = code
      @controlfirma.codigo_firma = @codigoFirma.to_s
      @controlfirma.fecha_firma = Time.now
      @controlfirma.estado = 'FIRMADO'
      @controlfirma.user_firma = is_admin
      @controlfirma.firma_agent = request.env['HTTP_USER_AGENT'].to_s rescue nil
      @controlfirma.firma_ip = request.env['REMOTE_ADDR'].to_s rescue nil
      @controlfirma.save(validate: false)
      Ejecucion.create(user_id: is_admin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO SMS',
                       controlador_metodo: "ControlfirmasController.firmadocumento(#{@controlfirma.id})", created_at: Time.now)
    else
      @valida = true
    end
  end

  def self.envio_notificacion(contratospersonaId)
    p = Contratospersona.find(contratospersonaId)
    mensaje = "ASEAR: Estimad@ #{p.nombres}, Tienes un documento pendiente de firmar, ingresa y realiza el proceso en https://appasearesp.com".html_safe
    Asearsms::SendsmsServices.new.send_sms_inicio(p.id, mensaje)
  end

  def self.firmadocumento(controlfirmaId)
    @controlfirma = Controlfirma.find(controlfirmaId)
    @modelo = Contratosperfecha.find(@controlfirma.id_registro)
    @contratospersona = Contratospersona.find(@modelo.contratospersona_id)
    fname = "#{@controlfirma.url}_" + @modelo.id.to_s
    rutafact = "#{::Rails.root}/public/archivos/pdf/"
    rutanamefile = "#{::Rails.root}/public/archivos/pdf/#{fname}.pdf"
    system("rm -r #{rutanamefile}") rescue nil

    pdf = ApplicationController.render pdf: "#{fname}", template: "controlfirmas/formatos_pdf", :save_to_file => rutanamefile, :save_only => true,
                                       encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 },
                                       locals: { object: @controlfirma.id }
    save_path = Rails.root.join(rutafact, "#{fname}.pdf")
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
    file = File.open("#{::Rails.root}/public/archivos/pdf/#{fname}.pdf", 'rb')
    @contratosperimagen = Contratosperimagen.new
    @contratosperimagen.contratospersona_id = @contratospersona.id
    @contratosperimagen.user_id = @controlfirma.user_firma
    @contratosperimagen.personasimagen = file
    @contratosperimagen.contratosperfecha_id = @modelo.id
    @contratosperimagen.descripcion = @controlfirma.tipo_documento
    @contratosperimagen.estado = 'APROBADO'
    @contratosperimagen.created_at = @controlfirma.fecha_firma
    @contratosperimagen.updated_at = @controlfirma.fecha_firma
    @contratosperimagen.save(validate: false)
    system("rm -r #{rutanamefile}") rescue nil
  end

  def pdfdocumento
    controlfirmaId = params[:controlfirmaid].to_s rescue ""
    @controlfirma = Controlfirma.find(controlfirmaId)
    @modelo = Contratosperfecha.find(@controlfirma.id_registro)
    @contratospersona = Contratospersona.find(@modelo.contratospersona_id)
    fname = "#{@controlfirma.url}_" + @modelo.id.to_s
    rutafact = "#{::Rails.root}/public/archivos/pdf/"
    rutanamefile = "#{::Rails.root}/public/archivos/pdf/#{fname}.pdf"
    system("rm -r #{rutanamefile}") rescue nil

    pdf = ApplicationController.render pdf: "#{fname}", template: "controlfirmas/formatos_pdf", :save_to_file => rutanamefile, :save_only => true,
                                       encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 },
                                       locals: { object: @controlfirma.id }
    save_path = Rails.root.join(rutafact, "#{fname}.pdf")
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
    rootName = "#{::Rails.root}/public/archivos/pdf/#{fname}.pdf"
    send_file rootName.to_s, :disposition => "attachment"
  end

  def levantar_firma
    @controlfirma = Controlfirma.find(params[:id])
    # 2023-06-10 Quita la fecha fin
    if Solicitudesretiro.where(contratosperfecha_id: @controlfirma.id_registro).exists? == false
      ActiveRecord::Base.connection.execute("update contratosperfechas set fecha_fin = null where id = #{@controlfirma.id_registro}")
      @controlfirma.destroy
      flash[:notice] = "Marcacion retirada con Exito!!!"
    else
      flash[:warning] = "NO puede quitarse la marcacion, el usuario ya tiene liquidacion"
    end
    respond_to do |format|
      format.js { render inline: "location.reload();" }
    end
  end

  def levantarfirma
    @controlfirma = Controlfirma.find(params[:id])
    @controlfirma.destroy
    flash[:notice] = "Marcacion retirada con Exito!!!"
    respond_to do |format|
      format.js { render inline: "location.reload();" }
    end
  end

  private

  def set_layout
    if ['index'].include?(action_name)
      'inscripcion_layoutmetro'
    else
      "inscripcion_layoutmetro"
    end
  end

  # Only allow a list of trusted parameters through.
  def controlfirma_params
    params.require(:controlfirma).permit(:controledor, :metodo, :id_registro, :codigo_otp, :respuesta_otp, :codigo_otp2, :respuesta_otp2, :estado)
  end
end
