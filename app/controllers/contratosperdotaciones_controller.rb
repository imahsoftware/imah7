class ContratosperdotacionesController < ApplicationController
  before_action :set_contratosperdotacion, only: [:show, :edit, :update, :destroy]

  layout :set_layout

  def index
    @contratosperdotaciones = Contratosperdotacion.all
  end

  def show
  end

  def new
    @contratosperdotacion = Contratosperdotacion.new
  end

  def edit
  end

  def create
    @contratosperdotacion = Contratosperdotacion.new(contratosperdotacion_params)

    respond_to do |format|
      if @contratosperdotacion.save
        format.html { redirect_to @contratosperdotacion, notice: 'Contratosperdotacion was successfully created.' }
        format.json { render :show, status: :created, location: @contratosperdotacion }
      else
        format.html { render :new }
        format.json { render json: @contratosperdotacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contratosperdotaciones/1
  # PATCH/PUT /contratosperdotaciones/1.json
  def firmar_entrega
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratosperdotaciones = Contratosperdotacion.select("DISTINCT CONCAT(empresas.autobuscar, ' - ', contratos.nro_contrato) AS describe_contrato, contratosperdotaciones.*, (select autobuscar from contratospersonas where id = contratosperdotaciones.contratospersona_id) nombreemp ")
                                                  .joins("INNER JOIN contratos ON contratos.id = contratosperdotaciones.contrato_id")
                                                  .joins("INNER JOIN empresas ON empresas.id = contratos.empresa_id")
                                                  .where("contratosperdotaciones.contratospersona_id = #{@contratospersona.id} and contratosperdotaciones.estado = 'ENTREGADO'")
                                                  .order("nro_contrato ASC")
  end

  def update
    respond_to do |format|
      @validaperdotacion = true

      @validaperdotacion = false

      registronuevo = Contratosperdotacion.create!(contrato_id: @contratosperdotacion.contrato_id, contratosperfecha_id: @contratosperdotacion.contratosperfecha_id,
                                                   contratospersona_id: @contratosperdotacion.contratospersona_id,
                                                   fecha_prox_entrega: Time.now, estado: 'PENDIENTE',
                                                   user_id: is_admin, pantalon: params[:contratosperdotacion][:pantalon].blank? ? 'NO' : params[:contratosperdotacion][:pantalon].to_s,
                                                   camisa: params[:contratosperdotacion][:camisa].blank? ? 'NO' : params[:contratosperdotacion][:camisa].to_s,
                                                   zapatos: params[:contratosperdotacion][:zapatos].blank? ? 'NO' : params[:contratosperdotacion][:zapatos].to_s,
                                                   entrega_anticipada: 'SI', perdotacion_original_id: @contratosperdotacion.id)

      if params[:contratosperdotacion][:zapatos].to_s == 'SI'
        @contratosperdotacion.update(zapatos: 'NO')
      end

      if params[:contratosperdotacion][:camisa].to_s == 'SI'
        @contratosperdotacion.update(camisa: 'NO')
      end

      if params[:contratosperdotacion][:pantalon].to_s == 'SI'
        @contratosperdotacion.update(pantalon: 'NO')
      end

      if Contratosperdotacion.where("perdotacion_original_id = #{@contratosperdotacion.id} and camisa = 'SI'").present? and
        Contratosperdotacion.where("perdotacion_original_id = #{@contratosperdotacion.id} and pantalon = 'SI'").present? and
        Contratosperdotacion.where("perdotacion_original_id = #{@contratosperdotacion.id} and zapatos = 'SI'").present?
        @contratosperdotacion.update(estado: 'FIRMA_ANTICIPADA')
      end

      flash[:notice] = "#{t :notice_actualiza_msj}"
      format.js { render inline: "location.reload();" }
    end
  end

  def entrega_enticipada
    @contratosperdotacion = Contratosperdotacion.find(params[:id])
    @contratosperdotacion.entrega_anticipada = 'SI'
    @contratosperdotacion.user_entrega_anticipada = is_admin
    @contratosperdotacion.save(validate: false)
  end

  def carta_dotacion
    @contratosperdotacion = Contratosperdotacion.find(params[:id])
    @contratosperfecha = @contratosperdotacion.contratosperfecha
    fname = "DotacionEntrega_" + @contratosperdotacion.contratospersona.identificacion.to_s rescue nil
    respond_to do |format|
      format.pdf { render pdf: "#{fname}", template: "contratosperdotaciones/carta_dotacion", encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 } }
    end
  end

  def self.carta_dotacion(nmContratoId, isadmin, vcFch)
    nrocontrato = Contrato.find(nmContratoId).nro_contrato.gsub(" ","_").to_s rescue nil
    fname = "DotacionPeriodica_" + nrocontrato.to_s
    rutafact = "#{::Rails.root}/public/download/"
    rutanamefile = "#{::Rails.root}/public/download/#{fname}.pdf"
    system("rm -r #{rutanamefile}")

    pdf = ApplicationController.render pdf: "#{fname}", template: "contratosperdotaciones/carta_dotacion_contrato", :save_to_file => rutanamefile, :save_only => true,
                                       encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 },
                                       locals: { object: nmContratoId, object0: vcFch  }
    save_path = Rails.root.join(rutafact, "#{fname}.pdf")
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
    mensaje = "ASEAR: Proceso de generacion de carta de Dotacion Periodica del contrato " + nmContratoId.to_s + ", finalizada con exito."
    Asearsms::SendsmsServices.new.send_sms_users(isadmin, mensaje)
  end

  def self.carta_dotacione(nmContratoId, isadmin, vcFch)
    nrocontrato = Contrato.find(nmContratoId).nro_contrato.gsub(" ","_").to_s rescue nil
    fname = "DotacionPeriodicaE_" + nrocontrato.to_s
    rutafact = "#{::Rails.root}/public/download/"
    rutanamefile = "#{::Rails.root}/public/download/#{fname}.pdf"
    system("rm -r #{rutanamefile}")

    pdf = ApplicationController.render pdf: "#{fname}", template: "contratosperdotaciones/carta_dotacion_contratoe", :save_to_file => rutanamefile, :save_only => true,
                                       encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 },
                                       locals: { object: nmContratoId, object0: vcFch  }
    save_path = Rails.root.join(rutafact, "#{fname}.pdf")
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
    mensaje = "ASEAR: Proceso de generacion de carta de Dotacion Periodica del contrato " + nmContratoId.to_s + ", finalizada con exito."
    Asearsms::SendsmsServices.new.send_sms_users(isadmin, mensaje)
  end

  #ContratosperdotacionesController.carta_dotacionesp
  def self.carta_dotacionesp
    Objeto.find_by_sql("SELECT DISTINCT DATE_FORMAT(s.updated_at,'%Y-%m') fch, s.contrato_id, REPLACE(CONCAT((SELECT nombre FROM empresas WHERE id = c.empresa_id),'_',c.nro_contrato),' ','_') nombree
                        FROM contratosperdotaciones s, contratos c
                        WHERE DATE_FORMAT(s.updated_at,'%Y-%m') IN ('2023-08','2023-12','2024-04','2024-05','2024-06','2024-07','2024-08')
                        AND   s.estado = 'FIRMADO'
                        AND   s.contrato_id = c.id
                        GROUP BY DATE_FORMAT(s.updated_at,'%Y-%m'), s.contrato_id
                        ORDER BY 1").each do |a|
      nmContratoId = a.contrato_id
      vcFch = a.fch
      fname = "DotacionEntrega_" + a.nombree.to_s
      rutafact = "#{::Rails.root}/public/archivos/pdf/dotacion/#{vcFch}"
      rutanamefile = "#{::Rails.root}/public/archivos/pdf/dotacion/#{vcFch}/#{fname}.pdf"
      system("rm -r #{rutanamefile}")

      pdf = ApplicationController.render pdf: "#{fname}", template: "contratosperdotaciones/carta_dotacion_contratoesp", :save_to_file => rutanamefile, :save_only => true,
                                         encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 },
                                         locals: { object: nmContratoId, object0: vcFch  }
      save_path = Rails.root.join(rutafact, "#{fname}.pdf")
      File.open(save_path, 'wb') do |file|
        file << pdf
      end
    end
  end

  def carta_dotacion_todos
    @contrato = Contrato.find(params[:contrato_id])
    @contratosperdotaciones = Contratosperdotacion.where("contrato_id = #{@contrato.id} and estado = 'FIRMADO'")
    fname = "DotacionEntregaMasiva_" + @contrato.id rescue nil
    respond_to do |format|
      format.pdf { render pdf: "#{fname}", template: "contratosperdotaciones/carta_dotacion_todos", encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 } }
    end
  end

  def entregar_todo
    contrato = params[:contrato_id]
    periodo = params[:periodo].gsub('_','-')

    Contratosperdotacion.where("contrato_id = #{contrato} and fecha_prox_entrega = '#{periodo}' and estado = 'PENDIENTE' and perdotacion_original_id is null").each do |c|
      nueva_fecha_prox_entrega = c.fecha_prox_entrega + c.contrato.mes_entrega_periodica.months
      c.estado = 'ENTREGADO'
      c.fecha_entrega = Time.now
      c.user_id = is_admin
      c.codigo_entrega = SecureRandom.hex
      c.save(validate: false)

      Contratosperdotacion.create!(
        contrato_id: c.contrato_id,
        contratosperfecha_id: c.contratosperfecha_id,
        contratospersona_id: c.contratospersona_id,
        fecha_prox_entrega: nueva_fecha_prox_entrega,
        estado: 'PENDIENTE',
        pantalon: 'SI',
        camisa: 'SI',
        zapatos: 'SI'
      )
    end
    respond_to do |format|
      flash[:notice] = "Marcacion asignada con Exito!!!"
      format.js { render inline: "location.reload();" }
    end
  end

  def marcar
    ruta = params[:ruta] rescue nil
    @contratosperdotacion = Contratosperdotacion.find(params[:id])
    if ruta.to_s == 'RECOGIDA'
      ActiveRecord::Base.connection.execute("update contratosperdotaciones set recogida = 'SI' where id = #{@contratosperdotacion.id}")
    elsif ruta.to_s == 'DESRECOGIDA'
      ActiveRecord::Base.connection.execute("update contratosperdotaciones set recogida = null where id = #{@contratosperdotacion.id}")
    else
      @contratosperdotacion.estado = 'ENTREGADO'
      if @contratosperdotacion.entrega_anticipada == 'SI'
        @contratosperdotacion.user_entrega_anticipada = is_admin
      end
      @contratosperdotacion.fecha_entrega = Time.now
      @contratosperdotacion.user_id = is_admin
      @contratosperdotacion.codigo_entrega = SecureRandom.hex
      @contratosperdotacion.save(validate: false)

      if ruta == 'PRINCIPAL'
        # Se suma 8 meses a la fecha_prox_entrega actual
        nueva_fecha_prox_entrega = @contratosperdotacion.fecha_prox_entrega + @contratosperdotacion.contrato.mes_entrega_periodica.months

        Contratosperdotacion.create!(
          contrato_id: @contratosperdotacion.contrato_id,
          contratosperfecha_id: @contratosperdotacion.contratosperfecha_id,
          contratospersona_id: @contratosperdotacion.contratospersona_id,
          fecha_prox_entrega: nueva_fecha_prox_entrega,
          estado: 'PENDIENTE',
          pantalon: 'SI',
          camisa: 'SI',
          zapatos: 'SI'
        )

      elsif ruta == 'PARCIAL' and Contratosperdotacion.where("perdotacion_original_id = #{@contratosperdotacion.perdotacion_original_id} and camisa = 'SI' and estado = 'ENTREGADO'").present? and
        Contratosperdotacion.where("perdotacion_original_id = #{@contratosperdotacion.perdotacion_original_id} and pantalon = 'SI' and estado = 'ENTREGADO'").present? and
        Contratosperdotacion.where("perdotacion_original_id = #{@contratosperdotacion.perdotacion_original_id} and zapatos = 'SI' and estado = 'ENTREGADO'").present?

        # Se suma 4 meses a la fecha_prox_entrega periodica
        nueva_fecha_prox_entrega = @contratosperdotacion.fecha_prox_entrega + @contratosperdotacion.contrato.mes_entrega_periodica.months

        Contratosperdotacion.create!(
          contrato_id: @contratosperdotacion.contrato_id,
          contratosperfecha_id: @contratosperdotacion.contratosperfecha_id,
          contratospersona_id: @contratosperdotacion.contratospersona_id,
          fecha_prox_entrega: nueva_fecha_prox_entrega,
          estado: 'PENDIENTE',
          pantalon: 'SI',
          camisa: 'SI',
          zapatos: 'SI'
        )
      end
    end
    respond_to do |format|
      format.js { render inline: "location.reload();" }
    end
  end

  def otros
    @contratosperdotacion = Contratosperdotacion.find(params[:id])
    @contrato = Contrato.find(params[:contrato_id])
  end

  def otp
    @ruta = params[:ruta] rescue nil
    @contratosperdotacion = Contratosperdotacion.find(params[:id])
    codigo = rand(100000..999999).to_s.gsub("0", "#{rand(1..9)}")
    @contratosperdotacion.update(codigo_env: codigo)
    #mensaje = "ASEAR: Estimad@ #{@contratosperdotacion.contratospersona.nombre_completo.to_s}, se ha generado tu codigo para la firma de la entrega de dotacion - #{codigo}".to_s
    mensaje = "ASEAR: Estimad@ #{@contratosperdotacion.contratospersona.nombres.to_s}, se ha generado tu codigo para la firma de la entrega de dotacion - #{codigo}".to_s
    logger.error("Mensaje..." + mensaje.to_s)
    logger.error("Movil..." + @contratosperdotacion.contratospersona.movil.to_s)
    user = User.find_by_contratospersona_id(@contratosperdotacion.contratospersona_id) rescue nil
    Asearsms::SendsmsServices.new.send_sms_procesos(@contratosperdotacion.contratospersona.movil.to_s, mensaje)
    Asearmail::SendmailServices.new.sendEmailCodigo(@contratosperdotacion.contratospersona.correo.to_s, "Codigo para la firma de Dotacion", "asear_mailer/envio_codigo.html.erb", nil, nil, user.id,codigo)
    #Asearsms::SendsmsServices.new.send_sms_procesos('3164637945', mensaje)
    #Asearsms::SendsmsServices.new.send_sms_procesos('3116256637', 'Prueba de envio de SMS de')
  end

  def captura_otp
    @ruta = params[:ruta] rescue nil
    nr1 = params[:nr1]
    nr2 = params[:nr2]
    nr3 = params[:nr3]
    nr4 = params[:nr4]
    nr5 = params[:nr5]
    nr6 = params[:nr6]
    @contratosperdotacion = Contratosperdotacion.find(params[:id])
    code = nr1 + nr2 + nr3 + nr4 + nr5 + nr6
    if code.to_i == @contratosperdotacion.codigo_env.to_i
      codigoFirma = SecureRandom.hex
      @contratosperdotacion.update(codigo_rec: code, codigo_fecha: Time.now, codigo_firma: codigoFirma, estado: 'FIRMADO')
      @valida = true
      Ejecucion.create(user_id: is_admin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO SMS',
                       controlador_metodo: "ContratosperdotacionesController.firmardocumento(#{@contratosperdotacion.id})", created_at: Time.now)
      respond_to do |format|
        flash[:notice] = "Se firmo con exito!!"
        if @ruta == 'EMPLEADO'
          format.js { render js: "window.location.href = '#{root_path}'" }
        else
          format.js { render inline: "location.reload();" }
        end
      end
    else
      @valida = false
    end
  end

  def self.firmardocumento (idDotacion)
    @contratosperdotacion = Contratosperdotacion.find(idDotacion) #update(codigo_rec: code, codigo_fecha: Time.now, codigo_firma: codigoFirma, estado: 'FIRMADO')
    user = User.find_by(contratospersona_id: @contratosperdotacion.contratospersona_id)

    fname = "Entrega_#{@contratosperdotacion.codigo_fecha.strftime('%Y%m%d%X')}"
    rutafact = "#{::Rails.root}/public/archivos/pdf/"
    rutanamefile = "#{::Rails.root}/public/archivos/pdf/#{fname}.pdf"
    system("rm -r #{rutanamefile}") rescue nil

    pdf = ApplicationController.render pdf: "#{fname}", template: "contratosperdotaciones/carta_dotacion", :save_to_file => rutanamefile, :save_only => true,
                                       encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 },
                                       locals: { object1: @contratosperdotacion.id },
                                       :footer => { :html => { :template => 'layouts/encabezados/pdffooterdescargos.html.erb' } }

    save_path = Rails.root.join(rutafact, "#{fname}.pdf")
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
    file = File.open("#{::Rails.root}/public/archivos/pdf/#{fname}.pdf", 'rb')

    @contratosperimagen = Contratosperimagen.new
    @contratosperimagen.contratospersona_id = @contratosperdotacion.contratospersona_id
    @contratosperimagen.contratosperfecha_id = @contratosperdotacion.contratosperfecha_id
    @contratosperimagen.user_id = user.id
    @contratosperimagen.personasimagen = file
    @contratosperimagen.descripcion = "CERTIFICADO ENTREGA DOTACION"
    @contratosperimagen.estado = 'APROBADO'
    @contratosperimagen.created_at = @contratosperdotacion.codigo_fecha
    @contratosperimagen.updated_at = @contratosperdotacion.codigo_fecha
    @contratosperimagen.save(validate: false)
    system("rm -r #{rutanamefile}") rescue nil
  end

  def searchdotacion_todo
    if params[:autobuscar].present?
      @contratosprefechasdotacion_todo = Contratosperdotacion.select("DISTINCT CONCAT(empresas.autobuscar, ' - ', contratos.nro_contrato) AS describe_contrato, contratosperdotaciones.*, (select autobuscar from contratospersonas where id = contratosperdotaciones.contratospersona_id) nombreemp ")
                                                             .joins("INNER JOIN contratos ON contratos.id = contratosperdotaciones.contrato_id")
                                                             .joins("INNER JOIN empresas ON empresas.id = contratos.empresa_id")
                                                             .where("contratosperdotaciones.estado in ('PENDIENTE', 'ENTREGADO') and contratosperdotaciones.contratospersona_id in (select id from contratospersonas where autobuscar like '%#{params[:autobuscar]}%')")
                                                             .order("nro_contrato ASC")

    end
  end

  def entrega_anticipada
    @titulo = params[:titulo] rescue nil
    @ruta = params[:ruta] rescue nil
    @contratosperdotacion = Contratosperdotacion.find(params[:id])
    @contrato = Contrato.find(params[:contrato_id])
  end

  # DELETE /contratosperdotaciones/1
  # DELETE /contratosperdotaciones/1.json
  def destroy
    @contratosperdotacion.destroy
    respond_to do |format|
      format.html { redirect_to contratosperdotaciones_url, notice: 'Contratosperdotacion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_layout
    if ['firmar_entrega'].include?(action_name)
      'inscripcion_layoutmetro'
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_contratosperdotacion
    @contratosperdotacion = Contratosperdotacion.find(params[:id])
  end

  # Only allow a list of trusted parameters  through.
  def contratosperdotacion_params
    params.require(:contratosperdotacion).permit!
  end
end
