class ContratosperfechasController < ApplicationController
  before_action :set_contratosperfecha, only: [:show, :destroy, :edit]

  before_action :authenticate_user!, except: [:contrato, :cartapre, :cartam]

  layout :set_layout

  before_action :checkaccess, except: ['generar_otp','generar_otp1','ws_otp','ws_otp2','entregar_dotacion','cartam','search_persona']

  def checkaccess
    return is_permit('contratospersonas')
  end

  def search_persona
    begin
      @contratosperfechas = Contratosperfecha.where('(fecha_fin is null or fecha_fin > now()) and contratospersona_id in (select id from contratospersonas where upper(autobuscar) like ?)', "%#{params[:q].upcase}%").limit(15)
      respond_to do |format|
        format.json { render json: @contratosperfechas.map { |p| { id: p.id, name: "#{p.contratospersona.autobuscar} - Contrato: #{p.contrato.empresa.identnombre} - #{p.contrato.nro_contrato}" } } }
      end
    rescue => e
      flash[:error] = "Ha ocurrido un error al buscar la persona."
      redirect_to root_path
    end
  end

  def firmar_conjunto
    begin
      user = User.find(is_admin)
      @contratosperfecha = Contratosperfecha.find(params[:contratosperfecha_id])
      @contratospersona = Contratospersona.find(params[:contratospersona_id])
      nombres = @contratospersona.nombre_completo.split(' ') rescue nil
      primer_nombre = nombres.first rescue nil
      codigo = rand(100000..999999).to_s.gsub("0", "#{rand(1..9)}")
      @contratosperfecha.update(codigo_conjunto: codigo)
      mensaje = "ASEAR: Estimad@ #{primer_nombre}, si AUTORIZAS este es tu codigo #{codigo} para firmar en conjunto con #{user.nombre rescue nil}".html_safe
      Asearsms::SendsmsServices.new.send_sms_procesos(@contratosperfecha.contratospersona.movil.to_s, mensaje)
      Asearmail::SendmailServices.new.sendEmailCodigo(@contratosperfecha.contratospersona.correo, "Codigo para la firma en conjunto", "asear_mailer/envio_codigo.html.erb", nil, nil, -1, codigo)
    rescue => e
      # Bugsnag.notify(e)
      flash[:error] = "Ha ocurrido un error al intentar firmar en conjunto."
      redirect_to root_path
    end
  end

  def firmar_conjunto_otp
    begin
      nr1 = params[:nr1]
      nr2 = params[:nr2]
      nr3 = params[:nr3]
      nr4 = params[:nr4]
      nr5 = params[:nr5]
      nr6 = params[:nr6]
      @contratosperfecha = Contratosperfecha.find(params[:contratosperfecha_id])
      @contratospersona = Contratospersona.find(params[:contratospersona_id])
      code = nr1 + nr2 + nr3 + nr4 + nr5 + nr6
      if code == @contratosperfecha.codigo_conjunto
        @contratosperfecha.update(fecha_conjunto_resp: Time.now, codigo_conjunto_resp: code)
        @valida = false
      else
        @valida = true
      end
    rescue => e
      # Bugsnag.notify(e)
      flash[:error] = "Ha ocurrido un error al intentar firmar en conjunto con OTP."
    end
  end

  def get_contratosperfecha_contrato_id
    begin
      @contrato = params[:contratosperfecha_contrato_id]
      @contratoscargos = Contratoscargo.where(contrato_id: @contrato) if @contrato
      @contratosgrupos = Contratosgrupo.where(contrato_id: @contrato) if @contrato
      respond_to { |format| format.js }
    rescue => e
      # Bugsnag.notify(e)
      flash[:error] = "Ha ocurrido un error al obtener los contratos de la fecha."
    end
  end

  def update_fecha_real
    begin
      @contratosperfecha = Contratosperfecha.find(params[:id])
      @contratosperfecha.fecha_inicio_real = params[:contratosperfecha][:fecha_inicio_real].to_date
      @contratosperfecha.user_fecha_real = is_admin
      @contratosperfecha.save(validate: false)
    rescue => e
      # Bugsnag.notify(e)
      flash[:error] = "Ha ocurrido un error al actualizar."
    end
  end

  def seguridad_salud
    respond_to do |format|
      format.pdf { render pdf: "Seguridad y Salud",
                          template: "contratosperfechas/seguridad_salud",
                          encoding: "UTF-8",
                          page_size: 'Letter',
                          :margin => { top: 40, :bottom => 10, :left => 15, :right => 15 },
                          :orientation => 'Landscape',
                          :header => { spacing: 10, :html => { :template => 'layouts/pdfheaderpdf.html.erb' } } }
    end
  end

  def entregar_dotacion
    begin
      @ruta = params[:ruta]
      @contratosperfecha = Contratosperfecha.find(params[:id])
      @contratosperfecha.val_dotacion = 'ENTREGADO'
      @contratosperfecha.user_dotacion = is_admin
      @contratosperfecha.fecha_dotacion = Time.now
      @contratosperfecha.save(validate: false)
      Contratosseguimiento.create(contratosperfecha_id: @contratosperfecha.id, contratospersona_id: @contratosperfecha.contratospersona_id, user_id: is_admin, tipo: 'DOTACION', estado: 'ENTREGADO')

      if Contratosperdotacion.where("estado = 'PENDIENTE' and contratospersona_id = #{@contratosperfecha.contratospersona_id}").blank?

        nueva_fecha_prox_entrega = Time.now + @contratosperfecha.contrato.mes_entrega.months

        Contratosperdotacion.create!(contrato_id: @contratosperfecha.contrato_id, contratosperfecha_id: @contratosperfecha.contratosperfecha_id,
                                     contratospersona_id: @contratosperfecha.contratospersona_id,fecha_prox_entrega: nueva_fecha_prox_entrega,
                                     estado: 'PENDIENTE', pantalon: 'SI', camisa: 'SI', zapatos: 'SI')
      end

      flash[:notice] = "Marcado como entregado!!!!!"
    rescue => e
      # Bugsnag.notify(e)
      flash[:error] = "Ha ocurrido un error al entregar dotacion."
    end
  end

  def entregar_carne
    begin
      @ruta = params[:ruta]
      @contratosperfecha = Contratosperfecha.find(params[:id])
      @contratosperfecha.val_carne = 'ENTREGADO'
      @contratosperfecha.user_carnet = is_admin
      @contratosperfecha.fecha_carnet = Time.now
      @contratosperfecha.save(validate: false)
      Contratosseguimiento.create(contratosperfecha_id: @contratosperfecha.id, contratospersona_id: @contratosperfecha.contratospersona_id, user_id: is_admin, tipo: 'CARNET', estado: 'ENTREGADO')
      flash[:notice] = "Marcado como entregado!!!!!"
    rescue => e
      # Bugsnag.notify(e)
      flash[:error] = "Ha ocurrido un error al entregar carne."
    end
  end

  def marcar_eps
    begin
      @p = params[:estado]
      ruta = params[:ruta]
      @contratosperfecha = Contratosperfecha.find(params[:id])
      @contratosperfecha.val_eps = 'AFILIADO'
      @contratosperfecha.user_eps = is_admin
      @contratosperfecha.fecha_eps = Time.now
      @contratosperfecha.save(validate: false)
      Contratosseguimiento.create(contratosperfecha_id: @contratosperfecha.id, contratospersona_id: @contratosperfecha.contratospersona_id, user_id: is_admin, tipo: 'EPS', estado: 'AFILIADO')
      flash[:notice] = "Marcado como Afiliado!!!!!"
    rescue => e
      # Bugsnag.notify(e)
      flash[:error] = "Ha ocurrido un error al marcar eps"
    end
  end

  def marcar_afp
    begin
      @p = params[:estado]
      ruta = params[:ruta]
      @contratosperfecha = Contratosperfecha.find(params[:id])
      @contratosperfecha.val_afp = 'AFILIADO'
      @contratosperfecha.user_afp = is_admin
      @contratosperfecha.fecha_afp = Time.now
      @contratosperfecha.save(validate: false)
      Contratosseguimiento.create(contratosperfecha_id: @contratosperfecha.id, contratospersona_id: @contratosperfecha.contratospersona_id, user_id: is_admin, tipo: 'AFP', estado: 'AFILIADO')
      flash[:notice] = "Marcado como Afiliado!!!!!"
    rescue => e
      # Bugsnag.notify(e)
      flash[:error] = "Ha ocurrido un error al marcar afp"
    end
  end

  def marcar_arl
    begin
      @p = params[:estado]
      ruta = params[:ruta]
      @contratosperfecha = Contratosperfecha.find(params[:id])
      @contratosperfecha.val_arl = 'AFILIADO'
      @contratosperfecha.user_arl = is_admin
      @contratosperfecha.fecha_arl = Time.now
      @contratosperfecha.save(validate: false)
      Contratosseguimiento.create(contratosperfecha_id: @contratosperfecha.id, contratospersona_id: @contratosperfecha.contratospersona_id, user_id: is_admin, tipo: 'ARL', estado: 'AFILIADO')
      flash[:notice] = "Marcado como Afiliado!!!!!"
    rescue => e
      # Bugsnag.notify(e)
      flash[:error] = "Ha ocurrido un error al marcar alr"
    end
  end

  def marcar_ccaf
    begin
      @p = params[:estado]
      ruta = params[:ruta]
      @contratosperfecha = Contratosperfecha.find(params[:id])
      @contratosperfecha.val_ccaf = 'AFILIADO'
      @contratosperfecha.user_ccaf = is_admin
      @contratosperfecha.fecha_ccaf = Time.now
      @contratosperfecha.save(validate: false)
      Contratosseguimiento.create(contratosperfecha_id: @contratosperfecha.id, contratospersona_id: @contratosperfecha.contratospersona_id, user_id: is_admin, tipo: 'CCAF', estado: 'AFILIADO')
      flash[:notice] = "Marcado como Afiliado!!!!!"
    rescue => e
      # Bugsnag.notify(e)
      flash[:error] = "Ha ocurrido un error al marcar ccaf"
    end
  end

  def ws_otp
    begin
      nr1 = params[:nr1]
      nr2 = params[:nr2]
      nr3 = params[:nr3]
      nr4 = params[:nr4]
      nr5 = params[:nr5]
      nr6 = params[:nr6]
      @contratosperfecha = Contratosperfecha.find(params[:id])
      @contratospersona = Contratospersona.find(params[:contratospersona_id])
      code = nr1 + nr2 + nr3 + nr4 + nr5 + nr6
      if code == @contratosperfecha.codigo_otp_env
        codigo = rand(100000..999999).to_s.gsub("0", "#{rand(1..9)}")
        mensaje = "ASEAR: Estimad@ #{@contratospersona.nombres}, se ha generado tu SEGUNDO codigo para la firma del contrato - #{codigo}".html_safe
        Asearsms::SendsmsServices.new.send_sms_otp(@contratosperfecha.id, mensaje, 'otp2')
        Asearmail::SendmailServices.new.sendEmailCodigo(@contratosperfecha.contratospersona.correo, "Codigo para la firma del contrato", "asear_mailer/envio_codigo.html.erb", nil, nil, -1, codigo)
        ActiveRecord::Base.connection.execute("CALL prc_firmacontratos(#{@contratosperfecha.id},'otp2','#{codigo}')")
        #@contratosperfecha.update(codigo_otp_rec: code, codigo_otp2_env: codigo)
        @valida = false
      else
        @valida = true
      end
    rescue => e
      # Bugsnag.notify(e)
      flash[:error] = "Ha ocurrido un error en ws_otp"
    end
  end

  def get_contratosseccion_contratoid
    @valida = false
    if params[:cargo_id] == "Seleccione" or params[:grupo_id] == "Seleccione"
      @valida = false
    else
      @valida = true
      @contratossecciones = Contratosseccion.where("contrato_id = #{params[:contrato_id]} and contratoscargo_id = #{params[:cargo_id]} and contratosgrupo_id = #{params[:grupo_id]}") if params[:contrato_id] and params[:cargo_id] and params[:grupo_id]
    end
    respond_to { |format| format.js }
  end

  def ws_otp2
    begin
      nr7 = params[:nr7]
      nr8 = params[:nr8]
      nr9 = params[:nr9]
      nr10 = params[:nr10]
      nr11 = params[:nr11]
      nr12 = params[:nr12]
      @contratosperfecha = Contratosperfecha.find(params[:id])
      @contratospersona = Contratospersona.find(params[:contratospersona_id])
      code = nr7 + nr8 + nr9 + nr10 + nr11 + nr12
      if code == @contratosperfecha.codigo_otp2_env
        @codigoFirma = SecureRandom.hex
        @contratosperfecha.codigo_otp2_rec = code
        @contratosperfecha.codigo_firma = @codigoFirma.to_s
        @contratosperfecha.fecha_firma = Time.now
        @contratosperfecha.sol_firma_digital = 'OK'
        @contratosperfecha.firma_agent = request.env['HTTP_USER_AGENT'].to_s rescue nil
        @contratosperfecha.firma_ip = request.env['REMOTE_ADDR'].to_s rescue nil
        @contratosperfecha.save(validate: false)
        @valida = false
        Ejecucion.create(user_id: is_admin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO SMS',
                         controlador_metodo: "ContratosperfechasController.firmacontrato(#{@contratosperfecha.id},#{is_admin})", created_at: Time.now)

        mensaje = "ASEAR: Estimad@ #{@contratospersona.nombres}, tu contrato, ha sido firmado correctamente."
        Asearsms::SendsmsServices.new.send_sms_otp(@contratosperfecha.id, mensaje, 'otp2')
        # Carta de Presentacion
        mensaje = "ASEAR: Estimad@ #{@contratospersona.nombres}: Recuerda presentarte a trabajar en el lugar, dia y hora indicada en la carta de presentacion, la cual debes entregar de manera fisica el primer dia. Descargar aqui: https://appasearesp.com/cartapresentacion".html_safe
        Asearsms::SendsmsServices.new.send_sms_firma(@contratosperfecha.id, mensaje)
      else
        @valida = true
      end
    rescue => e
      # Bugsnag.notify(e)
      flash[:error] = "Ha ocurrido un error en ws_otp2"
    end
  end

  def self.firmacontrato(contratosperfechaid, isadmin)
    begin
      @contratosperfecha = Contratosperfecha.find(contratosperfechaid)
      fname = "Contrato_Digital_" + @contratosperfecha.contratospersona.identificacion.to_s
      rutafact = "#{::Rails.root}/public/archivos/pdf/"
      rutanamefile = "#{::Rails.root}/public/archivos/pdf/#{fname}.pdf"

      pdf = ApplicationController.render pdf: "#{fname}", template: "contratosperfechas/contrato", :save_to_file => rutanamefile, :save_only => true,
                                         encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 },
                                         locals: { object: 'FIRMA',
                                                   object1: isadmin,
                                                   object2: @contratosperfecha.id }
      save_path = Rails.root.join(rutafact, "#{fname}.pdf")
      File.open(save_path, 'wb') do |file|
        file << pdf
      end
      file = File.open("#{::Rails.root}/public/archivos/pdf/#{fname}.pdf", 'rb')
      @contratosperimagen = Contratosperimagen.new
      @contratosperimagen.contratospersona_id = @contratosperfecha.contratospersona_id
      @contratosperimagen.contratosperfecha_id = @contratosperfecha.id
      @contratosperimagen.user_id = isadmin
      @contratosperimagen.personasimagen = file
      @contratosperimagen.descripcion = 'CONTRATO FIRMADO DIGITALMENTE'
      @contratosperimagen.estado = 'APROBADO'
      @contratosperimagen.created_at = @contratosperfecha.fecha_firma
      @contratosperimagen.updated_at = @contratosperfecha.fecha_firma
      @contratosperimagen.save(validate: false)
      system("rm -r #{rutanamefile}")
    rescue => e
      # Bugsnag.notify(e)
      logger.error("Errro... #{e.message}")
    end
  end

=begin
  def prueba2
    #@contratos = Objeto.find_by_sql("SELECT  id FROM  contratosperfechas e WHERE  NOT EXISTS (SELECT  NULL FROM  contratosperimagenes d WHERE   d.contratosperfecha_id = e.id) AND codigo_firma IS NOT NULL")
    @contratos = Objeto.find_by_sql("SELECT id FROM  contratosperfechas e WHERE  NOT EXISTS (SELECT  NULL FROM  contratosperimagenes d WHERE  d.contratosperfecha_id = e.id AND d.personasimagen_file_name LIKE '%Contrato_Digital_%') AND e.codigo_firma != ''")
    @contratos.each do |contrato|
      @contratosperfecha = Contratosperfecha.find(contrato.id)
      @contratospersona = @contratosperfecha.contratospersona
      user = User.where("identificacion  = '#{@contratospersona.identificacion}'").first
      fname = "Contrato_Digital_" + @contratosperfecha.contratospersona.identificacion.to_s
      rutafact = "#{::Rails.root}/public/archivos/pdf/"
      rutanamefile = "#{::Rails.root}/public/archivos/pdf/#{fname}.pdf"

      pdf = ApplicationController.render pdf: "#{fname}", template: "contratosperfechas/contrato", :save_to_file => rutanamefile, :save_only => true,
                                         encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 },
                                         locals: { object: 'FIRMA',
                                                   object1: is_admin,
                                                   object2: @contratosperfecha.id }
      save_path = Rails.root.join(rutafact, "#{fname}.pdf")
      File.open(save_path, 'wb') do |file|
        file << pdf
      end
      file = File.open("#{::Rails.root}/public/archivos/pdf/#{fname}.pdf", 'rb')
      @contratosperimagen = Contratosperimagen.new
      @contratosperimagen.contratospersona_id = @contratospersona.id
      @contratosperimagen.contratosperfecha_id = @contratosperfecha.id
      @contratosperimagen.user_id = user.id
      @contratosperimagen.created_at =
        @contratosperimagen.personasimagen = file
      @contratosperimagen.descripcion = 'CONTRATO FIRMADO DIGITALMENTE'
      @contratosperimagen.save
      system("rm -r #{rutanamefile}")
    end
    redirect_to root_path
  end
=end

  def eliminar_contratos
    Contratosperimagen.where("personasimagen_file_name like '%Contrato_Digital%'").delete_all
    redirect_to root_path
  end

  def generar_otp1
    begin
      @ruta = params[:ruta].present? ? params[:ruta] : 'EMPLEADO'
      @contratosperfecha = Contratosperfecha.find(params[:id])
      @contratospersona = Contratospersona.find(params[:contratospersona_id])
      if @contratosperfecha.codigo_firma.blank?
        codigo = rand(100000..999999).to_s.gsub("0", "#{rand(1..9)}")
        mensaje = "ASEAR: Estimad@ #{@contratospersona.nombres}, se ha generado tu PRIMER codigo para la firma del contrato - #{codigo}".html_safe
        Asearsms::SendsmsServices.new.send_sms_otp(@contratosperfecha.id, mensaje, 'otp1')
        Asearmail::SendmailServices.new.sendEmailCodigo(@contratosperfecha.contratospersona.correo, "Primer Codigo para la firma del contrato", "asear_mailer/envio_codigo.html.erb", nil, nil, -1, codigo)
        ActiveRecord::Base.connection.execute("CALL prc_firmacontratos(#{@contratosperfecha.id},'otp1','#{codigo}')")

        #@contratosperfecha.update(codigo_otp_env: codigo, codigo_otp_rec: nil, codigo_otp2_env: nil, codigo_otp2_rec: nil, fecha_firma: nil, status_sms_opt1: nil,
        #                          status_sms: nil, body_sms: nil, status_sms_opt2: nil, body_sms_otp2: nil, codigo_firma: nil)
      end
    rescue => e
      # Bugsnag.notify(e)
      flash[:error] = "Ha ocurrido un error en firmacontrato"
    end
  end

  def generar_otp
    begin
      @ruta = params[:ruta].present? ? params[:ruta] : 'EMPLEADO'
      @contratosperfecha = Contratosperfecha.find(params[:id])
      @contratospersona = Contratospersona.find(params[:contratospersona_id])
      if @contratosperfecha.codigo_firma.to_s == ""
        ActiveRecord::Base.connection.execute("CALL prc_firmacontratos(#{@contratosperfecha.id},'RESET','-1')")
        #@contratosperfecha.update(codigo_otp_env: nil, codigo_otp_rec: nil, codigo_otp2_env: nil, codigo_otp2_rec: nil, fecha_firma: nil, status_sms_opt1: nil,
        #                           status_sms: nil, body_sms: nil, status_sms_opt2: nil, body_sms_otp2: nil, codigo_firma: nil)
      end
    rescue => e
      # Bugsnag.notify(e)
      flash[:error] = "Ha ocurrido un error en generar_otp"
    end
  end

  def crear_aporte
    begin
      masivo = params[:masivo].to_s rescue nil
      isportafolio = is_portafolio
      code = WsAportesController.creacion_cotizante_individual(isportafolio, params[:id])
      flash[:notice] = "Proceso Ejecutado con exito!!!!"
      if masivo.to_s == 'SI'
        redirect_to contratospernominas_path
      else
        @contratosperfecha = Contratosperfecha.find(params[:id])
        redirect_to edit_contratospersona_path(id: @contratosperfecha.contratospersona_id, etapa: 'F')
      end
    rescue => e
      # Bugsnag.notify(e)
      flash[:error] = "Ha ocurrido un error en generar_otp"
    end
  end

  def marcar_firma
    begin
      @contratosperfecha = Contratosperfecha.find(params[:id])
      @contratosperfecha.sol_firma_digital = 'SI'
      @contratosperfecha.sol_firma_fecha = Time.now
      @contratosperfecha.save(validate: false)
      mensaje = "ASEAR: Estimad@ #{@contratosperfecha.contratospersona.nombres rescue nil}: Tu contrato ha sido GENERADO, Ingresa aqui para la firma de tu contrato. Bienvenido. - Url: https://appasearesp.com".html_safe
      Asearsms::SendsmsServices.new.send_sms_firma(@contratosperfecha.id, mensaje)
      respond_to do |format|
        flash[:notice] = "Marcacion asignada con Exito!!!"
        format.js { render inline: "location.reload();" }
      end
    rescue => e
      # Bugsnag.notify(e)
      flash[:error] = "Ha ocurrido un error en marcar_firma"
    end
  end

  def levantar_firma
    begin
      @contratosperfecha = Contratosperfecha.find(params[:id])
      @contratosperfecha.sol_firma_digital = nil
      @contratosperfecha.sol_firma_fecha = nil
      @contratosperfecha.save(validate: false)
      respond_to do |format|
        flash[:notice] = "Marcacion retirada con Exito!!!"
        format.js { render inline: "location.reload();" }
      end
    rescue => e
      # Bugsnag.notify(e)
      flash[:error] = "Ha ocurrido un error en marcar_firma"
    end
  end

  def levantarinactivos_firma
    begin
      Contratosperfecha.where("sol_firma_digital = 'SI' and estado ='INACTIVO'").each do |a|
        a.sol_firma_digital = nil
        a.sol_firma_fecha = nil
        a.save(validate: false)
      end
      respond_to do |format|
        flash[:notice] = "Marcacion retirada con Exito!!!"
        format.js { render inline: "location.reload();" }
      end
    rescue => e
      # Bugsnag.notify(e)
      flash[:error] = "Ha ocurrido un error en levantarinactivos_firma"
    end
  end

  def retirar_aporte
    isportafolio = is_portafolio
    code = WsAportesController.nov_retiro(params[:id], isportafolio)
    flash[:notice] = "Proceso Ejecutado con exito!!!!"
    redirect_to contratospernominas_path
  end

  def index
    @contratosperfechas = Contratosperfecha.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosperfecha.find(params[:active_id]) if params[:active_id].present?
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratosperfecha = Contratosperfecha.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosperfecha.find(params[:active_id]) if params[:active_id].present?
    @contratospersona = @contratosperfecha.contratospersona
    respond_to { |format| format.js }
  end

  def create
    begin
      @contratospersona = Contratospersona.find(params[:contratospersona_id])
      @contratosperfecha = Contratosperfecha.new(contratosperfecha_params)
      @contratosperfecha.contratospersona_id = @contratospersona.id
      @contratosperfecha.user_id = is_admin
      if Contratoscargo.where("id = #{@contratosperfecha.contratoscargo_id} and requiere_dotacion = 'SI'").present?
        @contratosperfecha.dotacion = 'SI'
      end
      respond_to do |format|
        if @contratosperfecha.save
          Ejecucion.create(user_id: is_admin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO SMS',
                           controlador_metodo: "DatasController.ejecutacontrato(#{@contratosperfecha.id})", created_at: Time.now)
          flash[:notice] = "#{t :notice_crea_msj}"
          format.js
        else
          format.js { render 'layouts/errors', locals: { object: @contratosperfecha } }
        end
      end
    rescue => e
      # Bugsnag.notify(e)
      flash[:error] = "Ha ocurrido un error en create"
    end
  end

  def update
    @contratosperfecha = Contratosperfecha.find(params[:id])
    @contratospersona = @contratosperfecha.contratospersona
    respond_to do |format|
      if @contratosperfecha.update(contratosperfecha_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperfecha } }
      end
    end
  end

  def contrato
    @contratosperfecha = Contratosperfecha.find(params[:id]) if params[:id]
    fname = "Contrato_" + @contratosperfecha.contratospersona.identificacion.to_s rescue nil
    respond_to do |format|
      format.pdf { render pdf: "#{fname}", template: "contratosperfechas/contrato", encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 } }
    end
  end

  def prueba
    @contratosperfecha = Contratosperfecha.find(params[:id]) if params[:id]
    fname = "Contrato_" + @contratosperfecha.contratospersona.identificacion.to_s rescue nil
    respond_to do |format|
      format.html
      # format.pdf { render pdf: "#{fname}", template: "contratosperfechas/prueba", encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 } }
    end
  end

  def cartapre
    @contratosperfecha = Contratosperfecha.find(params[:id]) if params[:id]
    fname = "CartaPresentacion_" + @contratosperfecha.contratospersona.identificacion.to_s rescue nil
    respond_to do |format|
      format.pdf { render pdf: "#{fname}", template: "contratosperfechas/cartapre", encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 } }
    end
  end

  def carta_dotacion
    @contratosperfecha = Contratosperfecha.find(params[:id]) if params[:id]
    fname = "Dotacion" + @contratosperfecha.contratospersona.identificacion.to_s rescue nil
    respond_to do |format|
      format.pdf { render pdf: "#{fname}", template: "contratosperfechas/carta_dotacion", encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 } }
    end
  end

  def carta
    @contratosperfecha = Contratosperfecha.find(params[:id]) if params[:id]
    @logo = @contratosperfecha.contrato.empresa.logo.to_s
    fname = "CartaLaboral_" + @contratosperfecha.contratospersona.identificacion.to_s rescue nil
    respond_to do |format|
      format.pdf { render pdf: "#{fname}", template: "contratosperfechas/carta", encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 } }
    end
  end

  def cartam
    @contratosperfechas = Contratosperfecha.where(contratospersona_id: params[:id]) if params[:id]
    @logo = @contratosperfechas[0].contrato.empresa.logo.to_s
    fname = "CartaLaboral_" + @contratosperfechas[0].contratospersona.identificacion.to_s rescue nil
    respond_to do |format|
      format.pdf { render pdf: "#{fname}", template: "contratosperfechas/cartam", encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 } }
    end
  end

  def self.dotacion(nmContratoId, isadmin, vcFch)
    nrocontrato = Contrato.find(nmContratoId).nro_contrato.gsub(" ","_").to_s rescue nil
    fname = "Dotacion_" + nrocontrato.to_s
    rutafact = "#{::Rails.root}/public/download/"
    rutanamefile = "#{::Rails.root}/public/download/#{fname}.pdf"
    system("rm -r #{rutanamefile}")

    pdf = ApplicationController.render pdf: "#{fname}", template: "contratosperfechas/dotacion", :save_to_file => rutanamefile, :save_only => true,
                                       encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 },
                                       locals: { object: nmContratoId, object0: vcFch  }
    save_path = Rails.root.join(rutafact, "#{fname}.pdf")
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
    mensaje = "ASEAR: Proceso de generacion de carta de Dotacion del contrato " + nmContratoId.to_s + ", finalizada con exito."
    Asearsms::SendsmsServices.new.send_sms_users(isadmin, mensaje)
  end

  def self.inducciongeneral(nmContratoId, isadmin, vcFch)
    fname = "Induccion_" + nmContratoId.to_s
    rutafact = "#{::Rails.root}/public/download/"
    rutanamefile = "#{::Rails.root}/public/download/#{fname}.pdf"
    system("rm -r #{rutanamefile}")

    pdf = ApplicationController.render pdf: "#{fname}", template: "contratosperfechas/inducciongeneral", :save_to_file => rutanamefile, :save_only => true,
                                       encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 },
                                       locals: { object: nmContratoId, object0: vcFch }
    save_path = Rails.root.join(rutafact, "#{fname}.pdf")
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
    mensaje = "ASEAR: Proceso de generacion de Induccion del contrato " + nmContratoId.to_s + ", finalizada con exito."
    Asearsms::SendsmsServices.new.send_sms_users(isadmin, mensaje)
  end

  def self.cartam_contrato(nmContratoId, isadmin, vcFch)
    fname = "CartaLaboral_" + nmContratoId.to_s
    rutafact = "#{::Rails.root}/public/download/"
    rutanamefile = "#{::Rails.root}/public/download/#{fname}.pdf"
    system("rm -r #{rutanamefile}")

    pdf = ApplicationController.render pdf: "#{fname}", template: "contratosperfechas/cartam_contrato", :save_to_file => rutanamefile, :save_only => true,
                                       encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 },
                                       locals: { object: nmContratoId, object0: vcFch }
    save_path = Rails.root.join(rutafact, "#{fname}.pdf")
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
    mensaje = "ASEAR: Proceso de generacion de cartas Laborales del contrato " + nmContratoId.to_s + ", finalizada con exito."
    Asearsms::SendsmsServices.new.send_sms_users(isadmin, mensaje)
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosperfecha.destroy
  end

  def habilitafirma
    @contratosperfecha = Contratosperfecha.find(params[:id]) if params[:id]
    Objeto.find_by_sql("SELECT f.id contratosperfecha_id, u.id user_id, i.id contratosperimagen_id
                        FROM   contratosperfechas f, users u, contratosperimagenes i, contratospersonas p
                        WHERE  f.id = #{@contratosperfecha.id}
                        AND    p.id = f.contratospersona_id
                        AND    f.codigo_firma IS NOT NULL
                        AND    f.id = i.contratosperfecha_id
                        AND    i.descripcion LIKE 'CONTRATO FIRMADO DIGITALMENTE%'
                        AND    f.contratospersona_id = u.contratospersona_id").each do |a|
      a = Contratosperimagen.find(a.contratosperimagen_id)
      a.destroy
    end
    ActiveRecord::Base.connection.execute("CALL prc_firmacontratos(#{@contratosperfecha.id},'RESET2','-1')")
    #@contratosperfecha.update(sol_firma_digital: 'SI', sol_firma_fecha: Time.now, codigo_otp_env: nil, codigo_otp_rec: nil, codigo_otp2_env: nil, codigo_otp2_rec: nil, fecha_firma: nil, status_sms_opt1: nil,
    #                          status_sms: nil, body_sms: nil, status_sms_opt2: nil, body_sms_otp2: nil, codigo_firma: nil)
    mensaje = "ASEAR: Estimad@ #{@contratosperfecha.contratospersona.nombres rescue nil}: Debes volver a firmar tu contrato. Ingresa aqui para hacerlo. - Url: https://appasearesp.com".html_safe
    Asearsms::SendsmsServices.new.send_sms_firma(@contratosperfecha.id, mensaje)
    flash['success'] = 'Contrato habilitado para firma nuevamente'
    redirect_to edit_contratospersona_path(id: @contratosperfecha.contratospersona_id, etapa: 'F')
  end

  def refirmar
    @contratosperfecha = Contratosperfecha.find(params[:id]) if params[:id]
    Objeto.find_by_sql("SELECT f.id contratosperfecha_id, u.id user_id, i.id contratosperimagen_id
                    FROM   contratosperfechas f, users u, contratosperimagenes i, contratospersonas p
                    WHERE  f.id = #{@contratosperfecha.id}
                    AND    p.id = f.contratospersona_id
                    AND    f.codigo_firma IS NOT NULL
                    AND    f.id = i.contratosperfecha_id
                    AND    i.descripcion LIKE 'CONTRATO FIRMADO DIGITALMENTE%'
                    AND    f.contratospersona_id = u.contratospersona_id").each do |a|
      a = Contratosperimagen.find(a.contratosperimagen_id)
      a.destroy
      ContratosperfechasController.firmacontrato(a.contratosperfecha_id, a.user_id)
    end
    flash['success'] = 'Contrato refirmado correctamente'
    redirect_to edit_contratospersona_path(id: @contratosperfecha.contratospersona_id, etapa: 'F')
  end

  private

  def set_layout
    if ['prueba'].include?(action_name)
      'blank'
    else
      "application_admin"
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_contratosperfecha
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratosperfecha = Contratosperfecha.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosperfecha_params
    params.require(:contratosperfecha).permit!
  end
end
