class ContratosperinventariosController < ApplicationController
  before_action :set_contratosperinventario, only: [:show, :destroy]

  def index
    @contratosperinventarios = Contratosperinventario.all
  end

  def show
    respond_to { |format| format.js }
  end

  def cerrar_acta
    @contratosperinventario = Contratosperinventario.find(params[:id])
    Contratosperinvacta.where("contratosperinventario_id = #{@contratosperinventario.id} and estado = 'PENDIENTE'").update(estado: 'FINALIZADO', user_id: is_admin, fecha_cierre: Time.now)
    redirect_to contratospersonas_path
  end

  def acta
    @consecutivo = params[:consecutivo]
    @contratosperinvacta = Contratosperinvacta.find(params[:contratosperinvacta_id])
    @contratosperinventario = @contratosperinvacta.contratosperinventario
    respond_to do |format|
      format.pdf { render pdf: "acta", template: "contratosperinventarios/acta.html.erb", encoding: "UTF-8", page_size: 'Letter' }
    end
  end

  def complemento
    @etapa = params[:etapa].present? ? params[:etapa] : 'A'
    @contratosperinventario = Contratosperinventario.find(params[:id])
  end

  def devolucion
    @etapa = params[:etapa].presence || 'A'
    @contratosperinventario = Contratosperinventario.find(params[:id])

    # Verificar si no existe un registro Contratosperinvacta en estado PENDIENTE para este Contratosperinventario
    if !Contratosperinvacta.where(contratosperinventario_id: @contratosperinventario.id, estado: 'PENDIENTE').present? and Contratosperinvdetalle.where("contratosperinventario_id = #{@contratosperinventario.id} and consecutivo_acta is null").present?
      @consecutivo = is_consecutivoservicio
      contratosperinvacta = Contratosperinvacta.new(
        consecutivo_acta: @consecutivo,
        contratosperinventario_id: @contratosperinventario.id,
        estado: 'PENDIENTE'
      )
      contratosperinvacta.save
    else
      # Si ya existe un registro Contratosperinvacta en estado PENDIENTE, obtener su consecutivo_acta
      @consecutivo = Contratosperinvacta.find_by(contratosperinventario_id: @contratosperinventario.id, estado: 'PENDIENTE')&.consecutivo_acta
    end
  end

  def visualizar
    @contratosperinventario = Contratosperinventario.find(params[:id])
    @contratospersona = @contratosperinventario.contratospersona
    @contratosperfecha = @contratosperinventario.contratosperfecha
    @contratosperinvdetalles = @contratosperinventario.contratosperinvdetalles
    respond_to do |format|
      format.pdf { render pdf: "Inventario_#{@contratosperinventario.id}", template: "contratosperinventarios/visualizar", encoding: "UTF-8", page_size: 'Letter' }
    end
  end

  def otp
    @contratosperinventario = Contratosperinventario.find(params[:id])
    @nombre = "Solicitud FIRMA: " + @contratosperinventario.contratospersona.nombres rescue nil
    codigo = rand(100000..999999).to_s.gsub("0", "#{rand(1..9)}")
    @contratosperinventario.update(codigo_otp: codigo)
    mensaje = "ASEAR: Estimad@ #{@contratosperinventario.contratospersona.nombres}, se ha generado tu codigo para la firma del inventario - #{codigo}".html_safe
    Asearsms::SendsmsServices.new.send_sms_procesos(@contratosperinventario.contratospersona.movil, mensaje)
    Asearmail::SendmailServices.new.sendEmailCodigo(@contratosperinventario.contratospersona.correo, "Codigo para la firma Inventario", "asear_mailer/envio_codigo.html.erb", nil, nil, -1,codigo)
  end

  def captura_web
    @contratosperinvdetalle = Contratosperinvdetalle.find(params[:contratosperdetallesdoc][:contratosperinvdetalle_id])
    data = params[:image][:image_data]
    image_data = Base64.decode64(data)
    new_file = File.new("public/webcam/captura_web_#{@contratosperinvdetalle.id}.png", 'wb')
    new_file.write(image_data)
    file = File.open(new_file, 'rb')
    @contratosperdetallesdoc = Contratosperdetallesdoc.new
    @contratosperdetallesdoc.contratosperinvdetalle_id = @contratosperinvdetalle.id
    @contratosperdetallesdoc.user_id = is_admin
    @contratosperdetallesdoc.invdetalle_doc = file
    @contratosperdetallesdoc.save
    respond_to do |format|
      flash[:notice] = "#{t :notice_crea_msj}"
      format.js { render inline: "location.reload();" }
    end
  end

  def captura_otp
    nr1 = params[:nr1]
    nr2 = params[:nr2]
    nr3 = params[:nr3]
    nr4 = params[:nr4]
    nr5 = params[:nr5]
    nr6 = params[:nr6]
    @contratosperinventario = Contratosperinventario.find(params[:id])
    code = nr1 + nr2 + nr3 + nr4 + nr5 + nr6
    if code.to_i == @contratosperinventario.codigo_otp.to_i
      isadmin = is_admin
      codigoFirma = SecureRandom.hex

      @contratosperinventario.update(respuesta_otp: code, fecha_firma: Time.now, codigo_firma: codigoFirma)
      if @contratosperinventario.codigo_crea_firma.present? and @contratosperinventario.contratosperinvatenciones.where("codigo_firma is not null").present?
        @contratosperinventario.update(estado: 'FIRMADO')

        fname = "Inventario_#{@contratosperinventario.contratospersona.identificacion.to_s}_#{Time.now.strftime("%d%m%Y_%X")}"

        rutafact = "#{::Rails.root}/public/archivos/pdf/"
        rutanamefile = "#{::Rails.root}/public/archivos/pdf/#{fname}.pdf"

        @contratospersona = @contratosperinventario.contratospersona

        pdf = ApplicationController.render pdf: "#{fname}", template: "contratospersonas/inventario_items_ind.html.erb", :save_to_file => rutanamefile, :save_only => true,
                                           encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 },
                                           locals: { contratosperinventario_id: @contratosperinventario.id,
                                                     contratospersona_id: @contratospersona.id }
        save_path = Rails.root.join(rutafact, "#{fname}.pdf")
        File.open(save_path, 'wb') do |file|
          file << pdf
        end
        file = File.open("#{::Rails.root}/public/archivos/pdf/#{fname}.pdf", 'rb')
        @contratosperimagen = Contratosperimagen.new
        @contratosperimagen.contratospersona_id = @contratosperinventario.contratospersona_id
        @contratosperimagen.contratosperfecha_id = @contratosperinventario.contratosperfecha_id
        @contratosperimagen.user_id = isadmin
        @contratosperimagen.personasimagen = file
        @contratosperimagen.descripcion = 'ENTREGA INVENATRIO'
        @contratosperimagen.estado = 'APROBADO'
        @contratosperimagen.created_at = @contratosperinventario.fecha_firma
        @contratosperimagen.updated_at = @contratosperinventario.fecha_firma
        @contratosperimagen.save(validate: false)
        system("rm -r #{rutanamefile}")

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

  def otp3
    @contratosperinventario = Contratosperinventario.find(params[:id])
    @nombre = "Solicitud FIRMA: " + @contratosperinventario.user.nombre rescue nil
    codigo = rand(100000..999999).to_s.gsub("0", "#{rand(1..9)}")
    @contratosperinventario.update(codigo_crea_otp: codigo)
    mensaje = "ASEAR: Estimad@ #{@contratosperinventario.user.nombre}, se ha generado tu codigo para la firma del inventario - #{codigo}".html_safe
    Asearsms::SendsmsServices.new.send_sms_procesos(@contratosperinventario.user.celular, mensaje)
    Asearmail::SendmailServices.new.sendEmailCodigo(@contratosperinventario.user.email.downcase, "Codigo para la firma", "asear_mailer/envio_codigo.html.erb", nil, nil, @contratosperinventario.user_id, codigo)
  end

  def captura_otp3
    nr1 = params[:nr1]
    nr2 = params[:nr2]
    nr3 = params[:nr3]
    nr4 = params[:nr4]
    nr5 = params[:nr5]
    nr6 = params[:nr6]
    @contratosperinventario = Contratosperinventario.find(params[:id])
    code = nr1 + nr2 + nr3 + nr4 + nr5 + nr6
    if code.to_i == @contratosperinventario.codigo_crea_otp.to_i
      isadmin = is_admin
      codigoFirma = SecureRandom.hex
      @contratosperinventario.update(respuesta_crea_otp: code, fecha_crea_firma: Time.now, codigo_crea_firma: codigoFirma)
      if @contratosperinventario.codigo_crea_firma.present? and @contratosperinventario.contratosperinvatenciones.where("codigo_firma is not null").present?
        @contratosperinventario.update(estado: 'FIRMADO')

        fname = "Inventario_#{@contratosperinventario.contratospersona.identificacion.to_s}_#{Time.now.strftime("%d%m%Y_%X")}"

        rutafact = "#{::Rails.root}/public/archivos/pdf/"
        rutanamefile = "#{::Rails.root}/public/archivos/pdf/#{fname}.pdf"

        @contratosperinventario = Contratosperinventario.find(params[:id])
        @contratospersona = @contratosperinventario.contratospersona


        pdf = ApplicationController.render pdf: "#{fname}", template: "contratospersonas/inventario_items_ind.html.erb", :save_to_file => rutanamefile, :save_only => true,
                                           encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 },
                                           locals: { contratosperinventario_id: @contratosperinventario.id,
                                                     contratospersona_id: @contratospersona.id }
        save_path = Rails.root.join(rutafact, "#{fname}.pdf")
        File.open(save_path, 'wb') do |file|
          file << pdf
        end
        file = File.open("#{::Rails.root}/public/archivos/pdf/#{fname}.pdf", 'rb')
        @contratosperimagen = Contratosperimagen.new
        @contratosperimagen.contratospersona_id = @contratosperinventario.contratospersona_id
        @contratosperimagen.contratosperfecha_id = @contratosperinventario.contratosperfecha_id
        @contratosperimagen.user_id = isadmin
        @contratosperimagen.personasimagen = file
        @contratosperimagen.descripcion = 'ENTREGA INVENATRIO'
        @contratosperimagen.estado = 'APROBADO'
        @contratosperimagen.created_at = @contratosperinventario.fecha_firma
        @contratosperimagen.updated_at = @contratosperinventario.fecha_firma
        @contratosperimagen.save(validate: false)
        system("rm -r #{rutanamefile}")
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

  def new
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratosperfecha = Contratosperfecha.find(params[:contratosperfecha_id])
    @contratosperinventario = Contratosperinventario.create(contratospersona_id: @contratospersona.id, contratosperfecha_id: @contratosperfecha.id, user_id: is_admin, estado: 'PENDIENTE')
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosperinventario.find(params[:active_id]) if params[:active_id].present?
    @contratosperinventario = Contratosperinventario.find(params[:id])
    @contratospersona = @contratosperinventario.contratospersona
    respond_to { |format| format.js }
  end

  def create
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratosperinventario = Contratosperinventario.new(contratosperinventario_params)
    @contratosperinventario.contratospersona_id = @contratospersona.id
    @contratosperinventario.user_id = is_admin
    respond_to do |format|
      if @contratosperinventario.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperinventario } }
      end
    end
  end

  def update
    @contratosperinventario = Contratosperinventario.find(params[:id])
    @contratosperinventario.user_act = is_admin
    @contratospersona = @contratosperinventario.contratospersona
    respond_to do |format|
      if @contratosperinventario.update(contratosperinventario_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperinventario } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosperinventario.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contratosperinventario
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratosperinventario = Contratosperinventario.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosperinventario_params
    params.require(:contratosperinventario).permit!
  end
end
