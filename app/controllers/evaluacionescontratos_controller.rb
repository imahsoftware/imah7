class EvaluacionescontratosController < ApplicationController
  before_action :set_evaluacionescontratos, only: %i[ show edit update destroy new create ]
  before_action :set_active, only: %i[ edit new ]

  def index
    @evaluacion = Evaluacion.find(current_evaluacion)
  end

  def cerrar_capacitacion2
    @evaluacion = Evaluacion.find(params[:evaluacion_id])
    @user_responsable = params[:user_responsable]

    respond_to do |format|
      flash[:notice] = "Capacitacion Calculada con Exito!!!"
      format.js { render inline: "location.reload();" }
    end
  end

  def cerrar_capacitacion
    @evaluacion = Evaluacion.find(params[:evaluacion_id])
    @user_responsable = params[:user_responsable]
    @contratosperfecha = Contratosperfecha.find(params[:contratosperfecha_id])
    @evaluacionescontrato = Evaluacionescontrato.where("evaluacion_id = #{@evaluacion.id} and user_responsable = #{@user_responsable}").first
    codigo = rand(100000..999999).to_s.gsub("0", "#{rand(1..9)}")
    @evaluacionescontrato.update(codigo_env: codigo)
    mensaje = "ASEAR: Estimad@ #{@evaluacionescontrato.user.nombre}, se ha generado tu codigo para la firma de la evaluación - #{codigo}".html_safe
    Asearsms::SendsmsServices.new.send_sms_procesos(@evaluacionescontrato.user.celular, mensaje)
    #Asearsms::SendsmsServices.new.send_sms_procesos('3016795087', mensaje)
  end

  def captura_otp
    nr1 = params[:nr1]
    nr2 = params[:nr2]
    nr3 = params[:nr3]
    nr4 = params[:nr4]
    nr5 = params[:nr5]
    nr6 = params[:nr6]
    @contratosperfecha = Contratosperfecha.find(params[:contratosperfecha_id])
    @evaluacionescontrato = Evaluacionescontrato.find(params[:evaluacionescontrato_id])
    @evaluacion = Evaluacion.find(params[:evaluacion_id])
    @user_responsable = params[:user_responsable]
    code = nr1 + nr2 + nr3 + nr4 + nr5 + nr6
    if code.to_i == @evaluacionescontrato.codigo_env.to_i
      isadmin = is_admin
      codigoFirma = SecureRandom.hex
      @evaluacionescontrato.update(codigo_rec: code, codigo_fecha: Time.now, codigo_firma: codigoFirma)
      calculo = 0
      cant = 0
      total = 0
      Evaluacionesejecucion.where("evaluacion_id =  #{@evaluacion.id} AND evaluacionescontrato_id IN (SELECT id FROM evaluacionescontratos WHERE user_responsable = #{@user_responsable})").each do |evaluacionesejecucion|
        calculo += evaluacionesejecucion.estado.to_f
        cant += 1
      end

      total = calculo.to_f / cant.to_f rescue 0
      @evaluacionescontrato.estado = total
      @evaluacionescontrato.save(validate: false)
      @valida = true

      Ejecucion.create(user_id: is_admin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'GENERAR PDF',
                       controlador_metodo: "EvaluacionescontratosController.informepdf(#{@evaluacionescontrato.id}, #{@evaluacion.id}, #{@contratosperfecha.id}, #{@user_responsable}, #{is_admin})", created_at: Time.now)

      respond_to do |format|
        flash[:notice] = "Se firmo con exito!!"
        format.js { render inline: "location.reload();" }
      end
    else
      @valida = false
    end
  end


  def otppp
    @evaluacionescontrato = Evaluacionescontrato.find(params[:id])
    contratosperfecha = Contratosperfecha.find(@evaluacionescontrato.contratosperfecha_id)
    codigo = rand(100000..999999).to_s.gsub("0", "#{rand(1..9)}")
    @evaluacionescontrato.update(codigo_env_empleado: codigo)
    mensaje = "ASEAR: Estimad@ #{contratosperfecha.contratospersona.nombres}, se ha generado tu codigo para la firma de la Terminacion por periodo de prueba - #{codigo}".html_safe
    Asearsms::SendsmsServices.new.send_sms_procesos('3164637945', mensaje)
    Asearmail::SendmailServices.new.sendEmailCodigo('imahsoftware@gmail.com', "Codigo para la firma de la Terminacion por periodo de prueba", "asear_mailer/envio_codigo.html.erb", nil, nil, -1,codigo)
    #Asearsms::SendsmsServices.new.send_sms_procesos(contratosperfecha.contratospersona.movil, mensaje)
    #Asearmail::SendmailServices.new.sendEmailCodigo(contratosperfecha.contratospersona.correo, "Codigo para la firma de la Terminacion por periodo de prueba", "asear_mailer/envio_codigo.html.erb", nil, nil, -1,codigo)
  end

  def captura_otppp
    nr1 = params[:nr1]
    nr2 = params[:nr2]
    nr3 = params[:nr3]
    nr4 = params[:nr4]
    nr5 = params[:nr5]
    nr6 = params[:nr6]
    @evaluacionescontrato = Evaluacionescontrato.find(params[:id])
    code = nr1 + nr2 + nr3 + nr4 + nr5 + nr6
    if code.to_i == @evaluacionescontrato.codigo_env_empleado.to_i
      isadmin = is_admin
      codigoFirma = SecureRandom.hex
      @evaluacionescontrato.update(codigo_rec_empleado: code, codigo_fecha_empleado: Time.now, codigo_firma_empleado: codigoFirma,
                                   estado_juridico: 'ATENDIDO', user_juridico: isadmin, fecha_juridico: Time.now, fecha_desvinculacion: Time.now)
      #para el log de mensajes
      @evaluacionescontrato = Evaluacionescontrato.find(params[:id])
      contratosperfecha = Contratosperfecha.find(@evaluacionescontrato.contratosperfecha_id)
      user = User.find(isadmin)
      mensaje = "ASEAR: Estimad@ #{contratosperfecha.contratospersona.nombres rescue nil}, te notificamos la terminacion de tu contrato por periodo de prueba a partir del #{Time.now.strftime("%d-%m-%Y").to_s}".html_safe
      #Asearsms::SendsmsServices.new.send_sms_procesos(contratosperfecha.contratospersona.movil, mensaje)
      Asearsms::SendsmsServices.new.send_sms_procesos(user.celular, mensaje)

      # Firma de Documento y montaje de terminacion
      Ejecucion.create(user_id: isadmin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO SMS',
                       controlador_metodo: "EvaluacionescontratosController.firmarterminacion(#{@evaluacionescontrato.id},#{isadmin})", created_at: Time.now)
      @valida = true
      respond_to do |format|
        flash[:notice] = "Se firmo con exito!!"
        format.js { render inline: "location.reload();" }
      end
    else
      @valida = false
    end
  end

  def estado_juridico
    estado = params[:estado]
    isadmin = is_admin
    Evaluacionescontrato.find(params[:evaluacionescontrato_id]).update(estado_juridico: estado, user_juridico: isadmin, fecha_juridico: Time.now)
    respond_to do |format|
      flash[:notice] = "Se firmo con exito!!"
      format.js { render inline: "location.reload();" }
    end
  end

  def self.firmarterminacion(idProceso,isadmin)
    @evaluacionescontrato = Evaluacionescontrato.find(idProceso)
    contratosperfecha = Contratosperfecha.find(@evaluacionescontrato.contratosperfecha_id)
    fname = "Terminacion_periodoprueba_#{@evaluacionescontrato.id}_#{Time.now.strftime("%d%m%Y_%X")}"
    rutafact = "#{::Rails.root}/public/archivos/pdf/"
    rutanamefile = "#{::Rails.root}/public/archivos/pdf/#{fname}.pdf"
    system("rm -r #{rutanamefile}") rescue nil

    pdf = ApplicationController.render pdf: "#{fname}", template: "evaluacionescontratos/terminacion", :save_to_file => rutanamefile, :save_only => true,
                                       encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 },
                                       locals: { object1: @evaluacionescontrato.id }

    save_path = Rails.root.join(rutafact, "#{fname}.pdf")
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
    file = File.open("#{::Rails.root}/public/archivos/pdf/#{fname}.pdf", 'rb')
    #Creamos el Retiro
    @solicitudesretiro = Solicitudesretiro.new
    @solicitudesretiro.contrato_id = contratosperfecha.contrato_id
    @solicitudesretiro.contratosgrupo_id = contratosperfecha.contratosgrupo_id
    @solicitudesretiro.contratospersona_id = contratosperfecha.contratospersona_id
    @solicitudesretiro.contratosperfecha_id = contratosperfecha.id
    @solicitudesretiro.fecha = @evaluacionescontrato.fecha_desvinculacion
    @solicitudesretiro.justificacion = 'TERMINACION DE CONTRATO POR PERIODO DE PRUEBA - PROCESO JURIDICO'
    @solicitudesretiro.user_id = isadmin
    @solicitudesretiro.documento_retiro = file
    @solicitudesretiro.save(validate: false)
    system("rm -r #{rutanamefile}") rescue nil
    file.close
    # Para notificar al Abogado
    user = User.find(isadmin)
    mensaje = "ASEAR: Estimad@ Abogado(a).. #{user.nombre rescue nil}, ya se proceso la terminacion por periodo de prueba que acabas de hacer.... ".html_safe
    Asearsms::SendsmsServices.new.send_sms_procesos(user.celular, mensaje)
  end

  def self.informepdf(evaluacionescontrato_id, evaluacion_id, contratosperfecha_id, user_responsable, isadmin)
    @evaluacionescontrato = Evaluacionescontrato.find(evaluacionescontrato_id)
    @evaluacion = Evaluacion.find(evaluacion_id)
    @contratosperfecha = Contratosperfecha.find(contratosperfecha_id)
    @user_responsable = user_responsable

    fname = "EvaluacionPeriodoPrueba_#{@evaluacionescontrato.id.to_s}_#{Time.now.strftime("%d%m%Y_%X")}"

    rutafact = "#{::Rails.root}/public/archivos/pdf/"
    rutanamefile = "#{::Rails.root}/public/archivos/pdf/#{fname}.pdf"

    @contratospersona = @contratosperfecha.contratospersona

    pdf = ApplicationController.render pdf: "#{fname}", template: "evaluacionescontratos/evaluacion_pdf", :save_to_file => rutanamefile, :save_only => true,
                                       encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 5, :right => 5 },
                                       locals: { evaluacionescontrato_id: @evaluacionescontrato.id,
                                                 evaluacion_id: @evaluacion.id,
                                                 contratosperfecha_id: @contratosperfecha.id,
                                                 user_responsable: @user_responsable,
                                                 isadmin: isadmin}
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
    @contratosperimagen.descripcion = 'EVALUACION PERIODO DE PRUEBA'
    @contratosperimagen.estado = 'APROBADO'
    @contratosperimagen.created_at = @evaluacionescontrato.codigo_fecha
    @contratosperimagen.updated_at = @evaluacionescontrato.codigo_fecha
    @contratosperimagen.save(validate: false)
    system("rm -r #{rutanamefile}")
  end

  def evaluacion_pdf
    @evaluacion = Evaluacion.find(params[:evaluacion_id])
    @evaluacionescontrato = Evaluacionescontrato.find(params[:usuario])
    @contratosperfecha = Contratosperfecha.find(params[:contratosperfecha_id])
    @is_admin = is_admin
    fname = "EvaluacionPeriodoPrueba_" + @evaluacionescontrato.id.to_s rescue nil
    respond_to do |format|
      format.pdf { render pdf: "#{fname}", template: "evaluacionescontratos/evaluacion_pdf", encoding: "UTF-8", page_size: 'Letter', :margin => { top: 10, :bottom => 20, :left => 5, :right => 5 } }
    end
  end

  def show_detalle_resultado
    @ruta = params[:ruta]
    @evaluacionescontrato = Evaluacionescontrato.find(params[:id])
    if @evaluacionescontrato.evaluacion.tipo == 'EVALUACION DESEMPENO'
      @resultados = Objeto.find_by_sql("SELECT
                                        u.nombre,
                                        ed.clase,
                                        COUNT(ev.id) AS cnt_items,
                                        COUNT(ee.id) AS cnt_evaluada,
                                        (COUNT(ee.id) * 100 / COUNT(ev.id)) AS resultado
                                    FROM evaluacionescontratos ec
                                    LEFT JOIN evaluacionesejecuciones ev ON ev.evaluacionescontrato_id = ec.id
                                    LEFT JOIN evaluacionesdetalles ed ON ed.evaluacion_id = ec.evaluacion_id AND ed.id = ev.evaluacionesdetalle_id
                                    LEFT JOIN users u ON u.id = ec.user_responsable
                                    LEFT JOIN evaluacionesejecuciones ee ON ee.evaluacionescontrato_id = ec.id AND ee.evaluacionesdetalle_id = ed.id AND IFNULL(ee.estado, '0') IN ('1', '1.0')
                                    WHERE ec.evaluacion_id = #{@evaluacionescontrato.evaluacion_id}
                                    AND ec.user_responsable = #{@evaluacionescontrato.user_responsable}
                                    GROUP BY u.nombre,ed.clase, ec.user_responsable
                                    ORDER BY 1, 2 DESC;")
    else
      @resultados = Objeto.find_by_sql("SELECT
                                        u.nombre,
                                        ed.clase,
                                        COUNT(ev.id) AS cnt_items,
                                        COUNT(ee.id) AS cnt_evaluada,
                                        (COUNT(ee.id) * 100 / COUNT(ev.id)) AS resultado
                                    FROM evaluacionescontratos ec
                                    LEFT JOIN evaluacionesejecuciones ev ON ev.evaluacionescontrato_id = ec.id
                                    LEFT JOIN evaluacionesdetalles ed ON ed.evaluacion_id = ec.evaluacion_id AND ed.id = ev.evaluacionesdetalle_id
                                    LEFT JOIN users u ON u.id = ec.user_responsable
                                    LEFT JOIN evaluacionesejecuciones ee ON ee.evaluacionescontrato_id = ec.id AND ee.evaluacionesdetalle_id = ed.id AND IFNULL(ee.estado, '0') IN ('1', '2','3','4')
                                    WHERE ec.evaluacion_id = #{@evaluacionescontrato.evaluacion_id}
                                    AND ec.user_responsable = #{@evaluacionescontrato.user_responsable}
                                    GROUP BY u.nombre,ed.clase, ec.user_responsable
                                    ORDER BY 1, 2 DESC;")
    end
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @evaluacionescontrato = Evaluacionescontrato.new
    respond_to { |format| format.js }
  end

  def edit
    @evaluacion = @evaluacionescontrato.evaluacion
    respond_to { |format| format.js }
  end

  def create
    @evaluacionescontrato = Evaluacionescontrato.new(evaluacionescontrato_params)
    @evaluacionescontrato.evaluacion_id = @evaluacion.id
    @evaluacionescontrato.user_id = is_admin
    respond_to do |format|
      if @evaluacionescontrato.save
        if @evaluacion.tipo == 'EVALUACION PERIODO PRUEBA'
          ActiveRecord::Base.connection.execute("
                INSERT INTO evaluacionesejecuciones (evaluacionescontrato_id,evaluacion_id,evaluacionesdetalle_id,created_at,updated_at, user_responsable)
                SELECT a.id, a.evaluacion_id, d.id, NOW(),NOW(), #{@evaluacionescontrato.user_responsable}
                FROM   evaluacionescontratos a, evaluacionesdetalles d
                WHERE  a.evaluacion_id = #{@evaluacion.id}
                AND    a.evaluacion_id = d.evaluacion_id
                AND    (a.id, a.evaluacion_id) NOT IN (SELECT DISTINCT evaluacionescontrato_id,evaluacion_id FROM evaluacionesejecuciones
                               WHERE evaluacionescontrato_id IS NOT NULL AND evaluacion_id IS NOT NULL)
                ORDER  BY a.id, d.id")
          ActiveRecord::Base.connection.execute("
                UPDATE evaluacionescontratos SET contratosperfecha_id = (SELECT p.id
                                                                         FROM contratosperfechas p, users u
                                                                         WHERE u.id = evaluacionescontratos.user_responsable
                                                                         AND   u.contratospersona_id = p.contratospersona_id
                                                                         AND   p.estado = 'ACTIVO'
                                                                         AND   (p.fecha_fin IS NULL OR p.fecha_fin >= CURDATE()) LIMIT 1)
                WHERE  evaluacion_id = #{@evaluacion.id} and contratosperfecha_id is null")
          flash[:notice] = "Se creó con éxito!!!"
          format.js { render js: "window.location.href = '#{proceso_evaluacionesejecuciones_path(user_responsable: @evaluacionescontrato.user_responsable,
                                                                                                 evaluacion_id: @evaluacion.id)}'" }
        else
          flash[:notice] = "Se creó con éxito!!!"
          format.js
        end
      else
        render 'layouts/errors', locals: { object: @evaluacionescontrato }
        format.js
      end
    end

  end

  def update
    @evaluacion = @evaluacionescontrato.evaluacion
    respond_to do |format|
      if @evaluacionescontrato.update(evaluacionescontrato_params)
        flash[:notice] = "Se actualizo con Exito!!!"
        format.js { render inline: "location.reload();" }
      else
        render 'layouts/errors', locals: { object: @evaluacionescontrato }
        format.js
      end
    end
  end

  def destroy
    @evaluacionescontrato.destroy
    flash['success'] = "Eliminado con Exito!!!"
  end

  def cancelar; end

  private

  def set_evaluacionescontratos
    @evaluacion = Evaluacion.find(params[:evaluacion_id])
    @evaluacionescontrato = Evaluacionescontrato.find(params[:id]) if params[:id]
  end

  def set_active
    @active_record = Evaluacionescontrato.find(params[:active_id]) if params[:active_id].present?
  end

  # Only allow a list of trusted parameters through.
  def evaluacionescontrato_params
    params.require(:evaluacionescontrato).permit!
  end
end
