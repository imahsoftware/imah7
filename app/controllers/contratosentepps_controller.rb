class ContratosenteppsController < ApplicationController
  before_action :set_contratosentepp, only: [:show, :destroy]

  layout :set_layout

  def index
    @contratosentepps = Contratosentepp.where(user_id: is_admin).order("id desc")
  end

  def show
    respond_to { |format| format.js }
  end

  def periodos_contrato
    @user_id = params[:user_id]
    @ruta = params[:ruta]
    combine = params[:combine] rescue nil
    @empresa = Empresa.find(params[:empresa_id])
    @contratos = Contratosentepp
                   .joins("INNER JOIN contratos c ON contratosentepps.contrato_id = c.id")
                   .joins("INNER JOIN contratos c ON contratosentepps.contrato_id = c.id")
                   .where("c.empresa_id = ?", @empresa.id)
                   .select("DISTINCT contratosentepps.contrato_id, c.nro_contrato, c.objeto, c.fecha_inicio, c.fecha_fin, c.estado")
                   .order("c.nro_contrato")

  end

  def show_contrato
    @ruta = params[:ruta]
    @contrato = Contrato.find(params[:contrato_id])
    start_date = Date.new(2024, 6, 1)
    end_date = Date.today.end_of_month
    @mesactual = Date.today.month
    @meses = (start_date..end_date).map { |date| { mes: date.strftime("%m").to_i, anno: date.year } }.uniq { |month| [month[:mes], month[:anno]] }
    @meses = @meses.sort_by { |month| [-month[:anno], -month[:mes]] }
  end

  def informegeneral_contrato
    @mes = params[:mes].to_s
    @contrato = Contrato.find(params[:contrato_id])
    @empresa = @contrato.empresa
    @portafolio = Portafolio.find(@empresa.portafolio_id)
    @logo_firma = @portafolio.logo_firma
    @logo = @portafolio.logo_empresa_assets
    @nombre_firma = @portafolio.nombre_rep.to_s
    respond_to do |format|
      format.pdf { render pdf: "InformeMensualEpps_#{@mes}", template: "contratosentepps/informemensual_contrato.html.erb", encoding: "UTF-8", page_size: 'Letter',
                          :margin => { top: 50, :bottom => 25, :left => 0, :right => 0 },
                          footer: { :html => { :template => 'contratosentepps/footer_informe_general.html.erb' } },
                          :header => { spacing: 10, :html => { :template => 'contratosentepps/header_informe_general.html.erb' } } }

    end

  end

  def self.informegeneral_contrato_combine(mes, contrato_id, is_admin)
    @mes = mes
    @contrato = Contrato.find(contrato_id)
    @empresa = @contrato.empresa
    @portafolio = Portafolio.find(@empresa.portafolio_id)
    @logo_firma = @portafolio.logo_firma
    @logo = @portafolio.logo_empresa_assets
    @nombre_firma = @portafolio.nombre_rep.to_s

    rutafact = "#{::Rails.root}/public/combinar/"
    fname = "InformeMensualEpps_#{@contrato.id}.pdf"
    rutanamefile = "#{::Rails.root}/public/combinar/#{fname}.pdf"
    pdf = ApplicationController.render pdf: "#{fname}", template: "contratosentepps/informemensual_contrato.html.erb", :save_to_file => rutanamefile, :save_only => true,
                                       encoding: "UTF-8", page_size: 'Letter', :margin => { top: 50, :bottom => 25, :left => 0, :right => 0 },
                                       footer: { :html => { :template => 'contratosentepps/footer_informe_general.html.erb' } },
                                       :header => { spacing: 10, :html => { :template => 'contratosentepps/header_informe_general.html.erb',  locals: { logo: @logo } } },
                                       locals: { contrato: @contrato, mes: @mes, isadmin: is_admin }
    save_path = Rails.root.join(rutafact, "#{fname}")
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
  end

  def control_empresa
    nroreg = 10

    if params[:autobuscar].to_s != ""
      @empresas = Empresa.searchInformeEpps(params[:autobuscar], params[:page], 10)
    else
      @empresas = Empresa.where("id in (select empresa_id from contratos where id in (select contrato_id from contratosentepps))").order("nombre ASC")
    end
  end

  def show_detalle_epps
    @ruta = params[:ruta]
    @fecha = params[:fecha]
    @fechaparams = @fecha.gsub('-', '_')
    @contratosentepps = Contratosentepp.where("estado = 'FINALIZADO' and date_format(created_at, '%Y-%m-%d') = '#{@fecha}' ")
  end

  def show_detalle_usuario
    @ruta = params[:ruta]
    @usuario = User.find(params[:user_id])
    @contratosentepps = Contratosentepp.where("estado = 'FINALIZADO' and user_id = #{@usuario.id}")
  end

  def new
    @active_record = Contratosentepp.find(params[:active_id]) if params[:active_id].present?
    @contratosentepp = Contratosentepp.new
    respond_to { |format| format.js }
  end

  def etapar
    if params[:etapa].present?
      User.where(id: is_admin).update_all(etapa: params[:etapa].to_s, updated_at: Time.now)
    end
    redirect_to contratosentepps_path
  end

  def edit
    @active_record = Contratosentepp.find(params[:active_id]) if params[:active_id].present?
    @contratosentepp = Contratosentepp.find(params[:id])
    respond_to { |format| format.js }
  end

  def complementar
    @etapa = params[:etapa].present? ? params[:etapa] : 'A'
    @contratosentepp = Contratosentepp.find(params[:id])
    respond_to do |format|
      format.html { render :action => "complementar" }
    end
  end

  def otp
    @contratosperfecha = Contratosperfecha.find(params[:contratosperfecha_id])
    @contratosentepp = Contratosentepp.find(params[:id])
    codigo = rand(100000..999999).to_s.gsub("0", "#{rand(1..9)}")
    Contratosenteppsfirma.where("contratosperfecha_id = #{@contratosperfecha.id} and contratosentepp_id = #{@contratosentepp.id}").update(codigo_env: codigo)
    mensaje = "ASEAR: Estimad@ #{@contratosperfecha.contratospersona.nombre_completo}, se ha generado tu codigo para la entrega de la solicitud - #{codigo}".html_safe
    Asearsms::SendsmsServices.new.send_sms_procesos(@contratosperfecha.contratospersona.movil.to_s, mensaje)
    Asearmail::SendmailServices.new.sendEmailCodigo(@contratosperfecha.contratospersona.correo, "Codigo para la firma EPP", "asear_mailer/envio_codigo.html.erb", nil, nil, -1, codigo)
  end

  def captura_otp
    nr1 = params[:nr1]
    nr2 = params[:nr2]
    nr3 = params[:nr3]
    nr4 = params[:nr4]
    nr5 = params[:nr5]
    nr6 = params[:nr6]
    @contratosperfecha = Contratosperfecha.find(params[:contratosperfecha_id])
    @contratosentepp = Contratosentepp.find(params[:id])
    contratosenteppsfirma = Contratosenteppsfirma.where("contratosperfecha_id = #{@contratosperfecha.id} and contratosentepp_id = #{@contratosentepp.id}").first
    code = nr1 + nr2 + nr3 + nr4 + nr5 + nr6
    if code.to_i == contratosenteppsfirma.codigo_env.to_i
      codigoFirma = SecureRandom.hex
      contratosenteppsfirma.codigo_rec = code
      contratosenteppsfirma.fecha_firma = Time.now
      contratosenteppsfirma.codigo_firma = codigoFirma
      contratosenteppsfirma.save(validate: false)

      Ejecucion.create(user_id: is_admin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO CORREO',
                       controlador_metodo: "ContratosenteppsController.informepdf(#{contratosenteppsfirma.id}, #{is_admin})", created_at: Time.now)

      if !Contratosenteppsfirma.where("contratosentepp_id = #{@contratosentepp.id} and codigo_firma is null").present?
        @contratosentepp.estado = 'FINALIZADO'
        @contratosentepp.save(validate: false)
      end

      @valida = true
      respond_to do |format|
        flash[:notice] = "Se firmo con exito!!"
        format.js { render inline: "location.reload();" }
      end
    else
      @valida = false
    end
  end

  def firmados
    @mes = params[:mes].to_s
    @contrato = Contrato.find(params[:contrato_id])
    @contratosenteppsfirmas =  Contratosenteppsfirma.where("DATE_FORMAT(fecha_firma, '%m-%Y') = '#{@mes}' and contratosentepp_id in (select id from contratosentepps where contrato_id = #{@contrato.id})")
    respond_to do |format|
      format.pdf { render pdf: "EntregaEppsFirmados_#{@mes}", template: "contratosentepps/informepdf_contrato.html.erb", encoding: "UTF-8", page_size: 'Letter',
                          :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 }}

    end
  end

  def self.informepdf(contratosenteppsfirmaid, isadmin)
    @contratosenteppsfirma = Contratosenteppsfirma.find(contratosenteppsfirmaid)
    @contratosperfecha = Contratosperfecha.find(@contratosenteppsfirma.contratosperfecha_id)
    @contratosentepp = Contratosentepp.find(@contratosenteppsfirma.contratosentepp_id)

    @logo = @contratosentepp.user.portafolio.logoportafolio.to_s

    fname = "EntregaEpps_#{@contratosentepp.id}_#{Time.now.strftime("%Y%m%d")}"
    rutafact = "#{::Rails.root}/public/archivos/pdf/"
    rutanamefile = "#{::Rails.root}/public/archivos/pdf/#{fname}.pdf"
    system("rm -r #{rutanamefile}") rescue nil

    pdf = ApplicationController.render pdf: "#{fname}", template: "contratosentepps/informepdf.html.erb", :save_to_file => rutanamefile, :save_only => true,
                                       encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 },
                                       locals: { contratosenteppsfirma_id: @contratosenteppsfirma.id }

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
    @contratosperimagen.descripcion = "ENTREGA SOLICITUD EPP"
    @contratosperimagen.estado = 'APROBADO'
    @contratosperimagen.created_at = @contratosenteppsfirma.fecha_firma
    @contratosperimagen.updated_at = @contratosenteppsfirma.fecha_firma
    @contratosperimagen.save(validate: false)
=begin
    @contratosperfechasdoc = Contratosperfechasdoc.new
    @contratosperfechasdoc.contratosperfecha_id = @contratosperfecha.id
    @contratosperfechasdoc.soporte_digital = file
    @contratosperfechasdoc.descripcion = 'ENTREGA SOLICITUD EPP'
    @contratosperfechasdoc.user_id = @contratosentepp.user_id
    @contratosperfechasdoc.tipo = 'EPP'
    @contratosperfechasdoc.save(validate: false)
=end
    system("rm -r #{rutanamefile}") rescue nil
  end

  def create
    @contratosentepp = Contratosentepp.new(contratosentepp_params)
    @contratosentepp.user_id = is_admin
    respond_to do |format|
      if @contratosentepp.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosentepp } }
      end
    end
  end

  def rotulo
    @contratosentepp = Contratosentepp.find(params[:id])
  end

  def update
    validador = params[:validador] rescue nil
    @contratosentepp = Contratosentepp.find(params[:id])
    @contratosentepp.valida_campos(validador)
    @contratosentepp.cedula = params[:contratosentepp][:cedula] rescue nil
    @contratosentepp.nombre = params[:contratosentepp][:nombre] rescue nil
    @contratosentepp.direccion = params[:contratosentepp][:direccion] rescue nil
    @contratosentepp.telefono = params[:contratosentepp][:telefono] rescue nil
    respond_to do |format|
      if @contratosentepp.update(contratosentepp_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @contratosentepp } }
      end
    end
  end

  def ver
    @contratosentepp = Contratosentepp.find(params[:id])
    @contrato = @contratosentepp.contrato
  end

  def estado
    @contratosentepp = Contratosentepp.find(params[:id])
    @contratosentepp.estado = params[:estado]
    @contratosentepp.save(validate: false)
    contratosenteppsdetalles = Contratosenteppsdetalle.select(:contratosperfecha_id, :contratosentepp_id)
                                                      .distinct.where(contratosentepp_id: @contratosentepp.id)
    contratosenteppsdetalles.each do |contratosenteppsdetalle|
      if Contratosenteppsfirma.where(contratosperfecha_id: contratosenteppsdetalle.contratosperfecha_id, contratosentepp_id: contratosenteppsdetalle.contratosentepp_id).present? == false
        Contratosenteppsfirma.create!(contratosperfecha_id: contratosenteppsdetalle.contratosperfecha_id, contratosentepp_id: contratosenteppsdetalle.contratosentepp_id)
      end
    end

    respond_to do |format|
      flash['success'] = 'Registro enviado con exito'
      format.js { render inline: "location.reload();" }
    end
  end

  def destroy
    @contratosentepp.destroy
    respond_to do |format|
      flash['success'] = 'Eliminado correctamente'
      format.js { render inline: "location.reload();" }
    end
  end

  def dash_epps
    @meses = "'01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31'"
    @fechasshow2 = Dashepp.select("mes, anno, CONCAT(anno, '-', mes) AS annomes").distinct(["mes, anno, CONCAT(anno, '-', mes) AS annomes"]).
      order("anno desc, mes desc").
      limit(6)
  end

  private

  def set_layout
    if ['ver', 'rotulo'].include?(action_name)
      'blank'
    elsif ['dash_epps'].include?(action_name)
      "basicoreporte"
    else
      'application_admin'
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_contratosentepp
    @contratosentepp = Contratosentepp.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosentepp_params
    params.require(:contratosentepp).permit!
  end
end
