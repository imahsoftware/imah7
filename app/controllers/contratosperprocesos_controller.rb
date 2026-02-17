class ContratosperprocesosController < ApplicationController
  before_action :set_contratosperproceso, only: [:show, :destroy]

  def showinfo
    @ruta = params[:ruta]
    @clase = params[:clase]
    @periodo = params[:periodo].to_s
    @estado = params[:estado].to_s
    @contratosperprocesos = Contratosperproceso.find_by_sql("
                            select contratos.nro_contrato, (select autobuscar from empresas where id = contratos.empresa_id) identnombre,
                                  contratosgrupos.descripcion, contratosgrupos.termino, contratoscargos.perfil, contratoscargos.salario salariocargo,
                                  (select descripcion from contratossecciones where id = contratosperfechas.contratosseccion_id) seccionnombre,
                                  (select autobuscar from municipios where id = (select municipio_id from contratossecciones where id = contratosperfechas.contratosseccion_id)) autobuscar_municipios,
                                  (select autobuscar from contratospersonas where id = contratosperfechas.contratospersona_id) nombrepersona,
                                  (select nombre from users where id = contratosperprocesos.user_id) userpronombre,
                                  (select concat('Fecha Citación: ',fecha,'<br/>Lugar: ',lugar,'<br/>Abogado(a): ',(select nombre from users where id = contratosperprocitaciones.user_id)) from contratosperprocitaciones where contratosperproceso_id = contratosperprocesos.id and estado = 'PENDIENTE' limit 1) citacion_detalle,
                                   contratosperprocesos.*
                           from contratosperprocesos, contratosperfechas, contratos, contratosgrupos, contratoscargos
                           where date_format(contratosperprocesos.created_at,'%Y-%m') = '#{@periodo}'
                           and contratosperprocesos.estado = '#{@estado}' and contratosperprocesos.clase = '#{@clase}'
                           and contratosperprocesos.contratosperfecha_id = contratosperfechas.id
                           and contratosperfechas.contrato_id = contratos.id
                           and contratosperfechas.contratoscargo_id = contratoscargos.id
                           and contratosperfechas.contratosgrupo_id = contratosgrupos.id
                           order by contratosperprocesos.id desc")
  end

  def se_niega
    @contratosperproceso = Contratosperproceso.find(params[:id])
    @contratosperproceso.niega = 'SI'
    @contratosperproceso.fecha_niega = Time.now
    @contratosperproceso.save(validate: false)
  end

  def codigo_otp
    @contratosperproceso = Contratosperproceso.find(params[:contratosperproceso_id])
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    codigo = rand(100000..999999).to_s.gsub("0", "#{rand(1..9)}")
    @contratosperproceso.codigo_envio_supervisor = codigo
    @contratosperproceso.save(validate: false)
    mensaje = "ASEAR: Estimad@ #{@contratosperproceso.user.nombre}, se ha generado tu codigo para firma del proceso - #{codigo}, recuerda que para continuar debes de firmar el proceso ".html_safe
    Asearsms::SendsmsServices.new.send_sms_procesos(@contratosperproceso.user.celular, mensaje)
    Asearmail::SendmailServices.new.sendEmailCodigo(@contratosperproceso.user.email, "Codigo para la firma del proceso", "asear_mailer/envio_codigo.html.erb", nil, nil, @contratosperproceso.user.id,codigo)
  end

  def show_firma
    @ruta = params[:ruta]
    @contratosperproceso = Contratosperproceso.find(params[:id])
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
  end

  def ws_otp
    nr1 = params[:nr1]
    nr2 = params[:nr2]
    nr3 = params[:nr3]
    nr4 = params[:nr4]
    nr5 = params[:nr5]
    nr6 = params[:nr6]
    @contratosperproceso = Contratosperproceso.find(params[:contratosperproceso_id])
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    code = nr1 + nr2 + nr3 + nr4 + nr5 + nr6
    if code == @contratosperproceso.codigo_envio_supervisor
      @contratosperproceso.codigo_recibido_supervisor = code
      @contratosperproceso.fecha_firma_supervisor =Time.now
      @contratosperproceso.codigo_firma_supervisor = SecureRandom.hex
      @contratosperproceso.save(validate: false)

      mensaje = "ASEAR: Estimad@ #{@contratosperproceso.contratospersona.nombres rescue nil}, se ha iniciado un proceso a nombre tuyo, recuerda que debes de iniciar sesión para firmar tu asistencia".html_safe
      Asearsms::SendsmsServices.new.send_sms_procesos(@contratosperproceso.contratospersona.movil, mensaje) rescue nil

      if @contratosperproceso.user_testigo1.present?
        mensaje = "ASEAR: Estimad@ #{User.find(@contratosperproceso.user_testigo1).nombre}, se ha iniciado un proceso con el empleado #{@contratospersona.nombres.capitalize rescue nil}, recuerda que debes de iniciar sesión para firmar tu asistencia".html_safe
        Asearsms::SendsmsServices.new.send_sms_procesos(User.find(@contratosperproceso.user_testigo1).celular, mensaje)
      end
      if @contratosperproceso.user_testigo2.present?
        mensaje = "ASEAR: Estimad@ #{User.find(@contratosperproceso.user_testigo2).nombre}, se ha iniciado un proceso con el empleado #{@contratospersona.nombres.capitalize rescue nil}, recuerda que debes de iniciar sesión para firmar tu asistencia".html_safe
        Asearsms::SendsmsServices.new.send_sms_procesos(User.find(@contratosperproceso.user_testigo2).celular, mensaje)
      end
      @valida = false
    else
      @valida = true
    end
  end

  def get_contratosperprocitaciones_estado
    @tipo = params[:contratosperprocitacion_estado]
    respond_to { |format| format.js }
  end

  def ver_bitacora
    @contratosperproceso = Contratosperproceso.find(params[:id])
  end

  def index
    @contratosperprocesos = Contratosperproceso.all
  end

  def show
    respond_to { |format| format.js }
  end

  def general
    @contratosperproceso = Contratosperproceso.find(params[:id])
    portafolio = Portafolio.find(@contratosperproceso.contratosperfecha.contrato.empresa.portafolio_id)
    @porta = portafolio
    fname = "AsearProceso_" + @contratosperproceso.clase.capitalize.gsub(' ', '_').to_s rescue nil
    respond_to do |format|
      format.pdf { render pdf: "#{fname}", template: "contratosperprocesos/general", encoding: "UTF-8", page_size: 'Letter',
                          :margin => { :bottom => 20, :left => 15, :right => 15, :top => 15 },
                          :footer => { :html => { :template => 'layouts/encabezados/pdffooterprocesos.html.erb' } } }
    end
  end

  def self.generalpdf(idProceso)
    @contratosperproceso = Contratosperproceso.find(idProceso)
    @contratospersona = Contratospersona.find(@contratosperproceso.contratospersona_id)
    @contratospersona = Contratospersona.find(@contratosperproceso.contratospersona_id)
    fname = "AsearProceso_" + idProceso.to_s + "_" + @contratosperproceso.clase.capitalize.gsub(' ', '_').to_s + "_" + @contratospersona.identificacion.to_s
    rutafact = "#{::Rails.root}/public/archivos/pdf/"
    rutanamefile = "#{::Rails.root}/public/archivos/pdf/#{fname}.pdf"
    system("rm -r #{rutanamefile}") rescue nil

    pdf = ApplicationController.render pdf: "#{fname}", template: "contratosperprocesos/general_pdf", encoding: "UTF-8", page_size: 'Letter',
                                       :margin => { :bottom => 20, :left => 15, :right => 15, :top => 15 },
                                       :footer => { :html => { :template => 'layouts/encabezados/pdffooterprocesos.html.erb' } },
                                        locals: { object: @contratosperproceso.id }
    save_path = Rails.root.join(rutafact, "#{fname}.pdf")
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
    file = File.open("#{::Rails.root}/public/archivos/pdf/#{fname}.pdf", 'rb')
    @contratosperprodoc = Contratosperprodoc.new
    @contratosperprodoc.contratosperproceso_id = @contratosperproceso.id
    @contratosperprodoc.contratospersona_id = @contratosperproceso.contratospersona_id
    @contratosperprodoc.docproceso = file
    @contratosperprodoc.tipo = 'PROCESO ' + @contratosperproceso.clase.to_s
    @contratosperprodoc.user_id = 1
    @contratosperprodoc.proceso = 'PROCESO'
    @contratosperprodoc.save(validate: false)
    system("rm -r #{rutanamefile}") rescue nil
  end

  def firma
    @contratosperproceso = Contratosperproceso.find(params[:id])
    if @contratosperproceso.user_testigo1.present? and @contratosperproceso.user_testigo2.blank?
      @div = "4"
    elsif @contratosperproceso.user_testigo1.present? and @contratosperproceso.user_testigo2.present?
      @div = "3"
    elsif @contratosperproceso.user_testigo2.present? and @contratosperproceso.user_testigo1.blank?
      @div = "4"
    else
      @div = "6"
    end
  end

  def firma_individual
    @tipo = params[:tipo]
    @contratosperproceso = Contratosperproceso.find(params[:id])
  end

  def firmar_usuario
    @tipo = params[:tipo] rescue nil
    @contratosperproceso = Contratosperproceso.find(params[:id])
  end

  def update_firma
    @valida = false
    @contratosperproceso = Contratosperproceso.find(params[:contratosperproceso_id])
    @contratosperproceso.firma_abogado = params[:contratosperproceso][:firma_abogado]
    @contratosperproceso.save(validate: false)
    if @contratosperproceso.firma_abogado.present?
      @valida = true

      data = @contratosperproceso.firma_abogado
      ruta = "#{::Rails.root}/public/archivos/pdf/abogado_#{@contratosperproceso.id}.png"
      data_uri_prefix = "data:image/png;base64,"
      image_data = data.sub(/^#{Regexp.escape(data_uri_prefix)}/, '')
      data = Base64.decode64(image_data)
      new_file = File.new(ruta, 'wb')
      new_file.write(data)
      file = File.open(new_file, 'rb')
      @contratosperproceso.firma_abogado_doc = file
      @contratosperproceso.save(validate: false)
      system("rm -r #{ruta}") rescue nil

    end
    if @contratosperproceso.user_testigo1.present? and @contratosperproceso.user_testigo2.blank?
      @div = "4"
    elsif @contratosperproceso.user_testigo1.present? and @contratosperproceso.user_testigo2.present?
      @div = "3"
    elsif @contratosperproceso.user_testigo2.present? and @contratosperproceso.user_testigo1.blank?
      @div = "4"
    else
      @div = "6"
    end
  end

  def update_firma_usuario
    @valida4 = false
    @contratosperproceso = Contratosperproceso.find(params[:contratosperproceso_id])
    @contratosperproceso.firma_usuario = params[:contratosperproceso][:firma_usuario]
    @contratosperproceso.save(validate: false)
    if @contratosperproceso.firma_usuario.present?
      @valida4 = true
      data = @contratosperproceso.firma_usuario
      ruta = "#{::Rails.root}/public/archivos/pdf/usuario_#{@contratosperproceso.id}.png"
      data_uri_prefix = "data:image/png;base64,"
      image_data = data.sub(/^#{Regexp.escape(data_uri_prefix)}/, '')
      data = Base64.decode64(image_data)
      new_file = File.new(ruta, 'wb')
      new_file.write(data)
      file = File.open(new_file, 'rb')
      @contratosperproceso.firma_usuario_doc = file
      @contratosperproceso.save(validate: false)
      system("rm -r #{ruta}") rescue nil
    end
  end

  def update_firma_testigo1
    @valida2 = false
    @contratosperproceso = Contratosperproceso.find(params[:contratosperproceso_id])
    @contratosperproceso.firma_testigo1 = params[:contratosperproceso][:firma_testigo1]
    @contratosperproceso.save(validate: false)
    if @contratosperproceso.firma_testigo1.present?
      @valida2 = true
      data = @contratosperproceso.firma_testigo1
      ruta = "#{::Rails.root}/public/archivos/pdf/testigo1_#{@contratosperproceso.id}.png"
      data_uri_prefix = "data:image/png;base64,"
      image_data = data.sub(/^#{Regexp.escape(data_uri_prefix)}/, '')
      data = Base64.decode64(image_data)
      new_file = File.new(ruta, 'wb')
      new_file.write(data)
      file = File.open(new_file, 'rb')
      @contratosperproceso.firma_testigo1_doc = file
      @contratosperproceso.save(validate: false)
      system("rm -r #{ruta}") rescue nil
    end
  end

  def regresar
    @contratosperproceso = Contratosperproceso.find(params[:id])
  end

  def update_firma_testigo2
    @valida3 = false
    @contratosperproceso = Contratosperproceso.find(params[:contratosperproceso_id])
    @contratosperproceso.firma_testigo2 = params[:contratosperproceso][:firma_testigo2]
    @contratosperproceso.save(validate: false)
    if @contratosperproceso.firma_testigo2.present?
      @valida3 = true
      data = @contratosperproceso.firma_testigo2
      ruta = "#{::Rails.root}/public/archivos/pdf/testigo2_#{@contratosperproceso.id}.png"
      data_uri_prefix = "data:image/png;base64,"
      image_data = data.sub(/^#{Regexp.escape(data_uri_prefix)}/, '')
      data = Base64.decode64(image_data)
      new_file = File.new(ruta, 'wb')
      new_file.write(data)
      file = File.open(new_file, 'rb')
      @contratosperproceso.firma_testigo2_doc = file
      @contratosperproceso.save(validate: false)
      system("rm -r #{ruta}") rescue nil
    end
  end

  def procesos_pdf
    @proceso = params[:proceso] rescue nil
    @contratosperproceso = Contratosperproceso.find(params[:contratosperproceso_id])
    if @proceso == 'CITACION' or @proceso == 'CITACION_NO_ATENDIDA'
      @contratosperprocitacion = Contratosperprocitacion.find(params[:id])
    elsif @proceso == 'SANCION' or @proceso == 'TERMINACION'
      @contratosperprosancion = Contratosperprosancion.find(params[:id])
    end
    fname = "Asear_" + @proceso.capitalize.gsub(' ', '_').to_s rescue nil
    respond_to do |format|
      format.pdf { render pdf: "#{fname}", template: "contratosperprocesos/procesos_pdf", encoding: "UTF-8", page_size: 'Letter',
                          :margin => { :bottom => 20, :left => 15, :right => 15, :top => 15 },
                          :footer => { :html => { :template => 'layouts/encabezados/pdffooterdescargos.html.erb' } } }
    end
  end

  def new
    @active_record = Contratosperproceso.find(params[:active_id]) if params[:active_id].present?
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratosperproceso = Contratosperproceso.new
    respond_to { |format| format.js }
  end

  def new2
    @contratosperprodoc = Contratosperprodoc.new
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratosperproceso = Contratosperproceso.find(params[:id])
  end

  def edit
    @active_record = Contratosperproceso.find(params[:active_id]) if params[:active_id].present?
    @contratosperproceso = Contratosperproceso.find(params[:id])
    @contratospersona = @contratosperproceso.contratospersona
    respond_to { |format| format.js }
  end

  def editproceso
    @subetapa = params[:etapa].present? ? params[:etapa] : '1'
    @contratosperproceso = Contratosperproceso.find(params[:id])
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    respond_to do |format|
      format.html { render :action => "contratosperproceso_form" }
    end
  end

  def create
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratosperproceso = Contratosperproceso.new(contratosperproceso_params)
    @contratosperproceso.contratospersona_id = @contratospersona.id
    @contratosperproceso.user_id = is_admin
    @contratosperproceso.contratosperfecha_id = @contratospersona.idperfecha
    respond_to do |format|
      if @contratosperproceso.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperproceso } }
      end
    end
  end

  def update
    @contratosperproceso = Contratosperproceso.find(params[:id])
    @contratospersona = @contratosperproceso.contratospersona
    @contratosperproceso.user_actualiza = is_admin
    respond_to do |format|
      if @contratosperproceso.update(contratosperproceso_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperproceso } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosperproceso.destroy
  end

  def etapars
    if params[:subetapa].to_s != ""
      User.where(id: is_admin).update_all(subetapa: params[:subetapa].to_s, updated_at: Time.now)
    end
    redirect_to menus_path(clase: params[:clase], etapa_proceso: params[:clase].gsub(' ', '_'))
  end

  def cambio
    contratosperproceso = Contratosperproceso.find(params[:id].to_i)
    if params[:estado].to_s != ""
      if params[:estado].to_s == 'EN PROCESO'
        Ejecucion.create(user_id: is_admin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO SMS',
                         controlador_metodo: "ContratosperprocesosController.generalpdf(#{contratosperproceso.id})", created_at: Time.now)
      end
      Contratosperproceso.where(id: params[:id].to_i).update_all(estado: params[:estado].to_s, updated_at: Time.now)
    end
    flash['success'] = 'Actualizacion de Estado realizada con Exito'
    redirect_to editproceso_contratosperprocesos_path(id: contratosperproceso.id, contratospersona_id: contratosperproceso.contratospersona_id, etapa: '1')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contratosperproceso
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratosperproceso = Contratosperproceso.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosperproceso_params
    params.require(:contratosperproceso).permit!
  end
end
