class VisitasController < ApplicationController
  before_action :set_visita, only: [:show, :edit, :update, :destroy]

  layout :set_layout

  require 'gruff'

  def antes
    @image = Visitasdoc.new
    @visita = Visita.find(params[:id])
  end

  def antes_trasera
    @image = Visitasdoc.new
    @visita = Visita.find(params[:id])
  end

  def captura_org
    @visita = Visita.find(params[:visita_id])
    if @visita.visitasdocs.where("tipo = 'ANTES'").present?
      @visita.visitasdocs.where("tipo = 'ANTES'").delete_all
    end
    data = params[:image][:image_data]
    image_data = Base64.decode64(data)
    new_file = File.new("public/webcam/inicio_#{@visita.id}.png", 'wb')
    new_file.write(image_data)
    file = File.open(new_file, 'rb')
    @visitasdoc = Visitasdoc.new
    @visitasdoc.visita_id = @visita.id
    @visitasdoc.user_id = is_admin
    @visitasdoc.tipo = "ANTES"
    @visitasdoc.docvisita = file
    @visitasdoc.save(validate: false)
  end

  def captura
    @visita = Visita.find(params[:visita_id])
    @visita.visitasdocs.where(tipo: 'ANTES').delete_all

    data = params[:image][:image_data]
    image_data = Base64.decode64(data)
    new_file = File.new("public/webcam/inicio_#{@visita.id}.png", 'wb')
    new_file.write(image_data)
    file = File.open(new_file, 'rb')

    @visitasdoc = Visitasdoc.new(
      visita_id: @visita.id,
      user_id: current_user.id, # Asegúrate de usar el método correcto para obtener el ID del usuario actual
      tipo: "ANTES",
      docvisita: file
    )

    if @visitasdoc.save(validate: false)
      antes_exists = @visita.visitasdocs.exists?(tipo: 'ANTES')
      render json: { success: true, antesExists: antes_exists }
    else
      render json: { success: false, message: "Error al guardar la imagen." }, status: :unprocessable_entity
    end
  end

  def despues
    @image = Visitasdoc.new
    @visita = Visita.find(params[:id])
  end

  def captura_despues
    @visita = Visita.find(params[:visita_id])
    if @visita.visitasdocs.where("tipo = 'DESPUES'").present?
      @visita.visitasdocs.where("tipo = 'DESPUES'").delete_all
    end
    data = params[:image][:image_data]
    image_data = Base64.decode64(data)
    new_file = File.new("public/webcam/finalizacion_#{@visita.id}.png", 'wb')
    new_file.write(image_data)
    file = File.open(new_file, 'rb')

    @visitasdoc = Visitasdoc.new(
      visita_id: @visita.id,
      user_id: current_user.id, # Asegúrate de usar el método correcto para obtener el ID del usuario actual
      tipo: "DESPUES",
      docvisita: file
    )

    # ActiveRecord::Base.connection.execute("UPDATE visitas SET tiempo_visita_hora = TIMEDIFF(finalizacion,created_at)")
    ActiveRecord::Base.connection.execute("UPDATE visitas SET tiempo_visita = tiempo_visita_hora")

    if @visitasdoc.save(validate: false)
      antes_exists = @visita.visitasdocs.exists?(tipo: 'DESPUES')
      render json: { success: true, antesExists: antes_exists }
    else
      render json: { success: false, message: "Error al guardar la imagen." }, status: :unprocessable_entity
    end
  end

  def formato
    @visita = Visita.find(params[:id])
    # fname = "Vista_" + @visita.id.to_s
    # respond_to do |format|
    #  format.pdf { render pdf: "#{fname}", template: "visitas/formato.html.erb", encoding: "UTF-8", page_size: 'Letter' } #,disposition: 'attachment'}
    # end
  end

  def cerrar
    @visita = Visita.find(params[:id])
    @visita.finalizacion = Time.now
    @visita.fin_latitude = params[:visita][:latitude].to_s rescue nil
    @visita.fin_longitude = params[:visita][:longitude].to_s rescue nil
    @visita.fin_direccion = params[:visita][:direccion].to_s rescue nil
    @visita.save(validate: false)
    ActiveRecord::Base.connection.execute("UPDATE visitas SET tiempo_visita_hora = TIMEDIFF(finalizacion,created_at)")
    ActiveRecord::Base.connection.execute("UPDATE visitas SET tiempo_visita = tiempo_visita_hora")
  end

  def complementar
    @etapa = params[:etapa].present? ? params[:etapa] : 'A'
    @visita = Visita.find(params[:id])
    respond_to do |format|
      format.html { render :action => "complementar" }
    end
  end

  def etapars
    if params[:subetapa].to_s != ""
      User.where(id: is_admin).update_all(subetapa: params[:subetapa].to_s, updated_at: Time.now)
    end
    redirect_to visitas_path
  end

  def primer_registro

  end

  def index
    @usr = current_user
    if @usr.id != 15910 and @usr.id != 4561
      dato = Objeto.find_by_sql("SELECT DISTINCT 'X' existe FROM viw_consolidabloqueo WHERE user_id = #{@user.id}")[0] rescue nil
    end
    if dato.present?
      flash[:warning] = 'Hola!!! Para donde vas si no has terminado los temas pendientes'
      redirect_to root_path
    else
      contratospersonaId = -1
      if @usr.contratospersona_id.present?
        contratospersonaId = @usr.contratospersona_id
      end
      @procesos = Contratosperproceso.where("firma_usuario is null and contratospersona_id = #{contratospersonaId}") rescue nil
      @testigos1 = Contratosperproceso.where("firma_testigo1 is null and user_testigo1 = #{@usr.id}") rescue nil
      @testigos2 = Contratosperproceso.where("firma_testigo2 is null and user_testigo2 = #{@usr.id}") rescue nil
      if @procesos.present? or @testigos1.present? or @testigos2.present?

        redirect_to controlfirmas_path

      else

        if @usr.subetapa.to_s == 'PROCESO'
          @tipo = params[:ubicacion][:tipo].to_s rescue nil
          @clase = params[:ubicacion][:clase].to_s rescue nil
          @contratoid = params[:ubicacion][:contratoid].to_s rescue nil
          if @tipo.to_s != "" or @clase.to_s != "" or @contratoid.to_s != "" or params[:user_id].to_s != "" or params[:fchinicial].to_s != "" or params[:fchfinal].to_s != ""
            msj = "No hay resultados de la consulta"
          end
          if @tipo.to_s == "EXCEL"
            nroreg = 100000
          else
            nroreg = 10
          end
          @visitas = Visita.select("id,user_id,descripcion,latitude,longitude,direccion,contrato_id,finalizacion,fin_latitude,fin_longitude,
                                    fin_direccion,tiempo_visita,map_image,created_at,updated_at,(select nombre from users where id = visitas.user_id) usernombre,
                                    (select autobuscar from empresas where id = (select empresa_id from contratos where id = visitas.contrato_id)) identnombre,
                                    (select nro_contrato from contratos where id = visitas.contrato_id) nro_contrato, teletrabajo,
                                    (SELECT c.perfil FROM users u, contratospersonas p, contratosperfechas f, contratoscargos c
                                     WHERE u.id = visitas.user_id AND u.contratospersona_id = p.id AND p.id = f.contratospersona_id
                                     AND f.contratoscargo_id = c.id AND f.estado= 'ACTIVO' LIMIT 1) cargo")
                           .search(@clase, is_admin, params[:user_id], @contratoid, params[:fchinicial], params[:fchfinal], params[:page], params[:format]).paginate(:page => params[:page], :per_page => nroreg)
          if @visitas.count.to_i == 0
            flash[:warning] = "No hay resultados de la consulta!!!"
          else
            if @tipo.to_s == "EXCEL"
              fNameRoot = "#{::Rails.root}/public/archivos/download/Georeferenciacion_#{Time.now.strftime("%Y%m%d_%X")}.xlsx"
              directory_path = "#{::Rails.root}/public/archivos/download/Georeferenciacion*"
              system("rm -r #{directory_path}")
              ex = Axlsx::Package.new
              wd = ex.workbook
              wd.styles do |style|
                title = wd.styles.add_style(b: true, bg_color: "FF045FB4", fg_color: 'F5F6CE', sz: 11, font_name: "Calibri", :alignment => { :horizontal => :center, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
                header = wd.styles.add_style(b: true, bg_color: "FF7DB4F4", fg_color: 'F5F6CE', sz: 11, font_name: "Calibri", :alignment => { :horizontal => :center, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
                header1 = wd.styles.add_style(b: true, bg_color: "FFE87F07", fg_color: 'F5F6CE', sz: 11, font_name: "Calibri", :alignment => { :horizontal => :center, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
                header2 = wd.styles.add_style(b: true, bg_color: "FF5EFF33", fg_color: 'F5F6CE', sz: 11, font_name: "Calibri", :alignment => { :horizontal => :center, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
                header3 = wd.styles.add_style(b: true, bg_color: "FF417932", fg_color: 'F5F6CE', sz: 11, font_name: "Calibri", :alignment => { :horizontal => :center, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
                header4 = wd.styles.add_style(b: true, bg_color: "FFE16E28", fg_color: 'F5F6CE', sz: 11, font_name: "Calibri", :alignment => { :horizontal => :center, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
                datosiz = wd.styles.add_style(sz: 11, font_name: "Calibri", :alignment => { :horizontal => :left, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
                datoscent = wd.styles.add_style(sz: 11, font_name: "Calibri", :alignment => { :horizontal => :center, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
                datosder = wd.styles.add_style(sz: 11, font_name: "Calibri", :alignment => { :horizontal => :right, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
                fecha = wd.styles.add_style(sz: 11, font_name: "Calibri", :format_code => 'dd-mm-yyyy', :alignment => { :horizontal => :center, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
                datosnumeros = wd.styles.add_style(:format_code => '#,###,###.#0', sz: 11, font_name: "Calibri", :alignment => { :horizontal => :right, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)
                fecha_min = wd.styles.add_style(sz: 11, font_name: "Calibri", :format_code => 'dd-mm-yyyy HH:MM:SS', :alignment => { :horizontal => :right, :vertical => :center }, :border => Axlsx::STYLE_THIN_BORDER)

                wd.add_worksheet(:name => "Detalle Visita") do |sheet|
                  sheet.add_row ["Fecha Inicio","Hora Inicio", "Usuario", "Empresa - Contrato", "Objetivo de la visita", "Direccion Inicio",
                                       "Fecha Finalizacion",  "Hora Finalizacion", "Direccion Finalizacion", "Tiempo", "Clase de Visita","Cargo"],
                                :style => [title, title, title, title, title, title, header1, header1, header1, header1, header1, title]
                  for p in @visitas
                    estilos = [fecha, datoscent, datoscent, datosiz, datosiz, datosiz, fecha, datoscent, datosiz, datoscent, datoscent, datosiz]
                    tamano = [18, 18, 30, 30, 50, 120, 18, 18, 120, 15, 15, 30]
                    sheet.add_row [p.created_at.strftime("%d/%m/%Y"), p.created_at.strftime("%H:%M:%S").to_s, p.user.nombre, p.contrato.nombrecontrato,
                                         p.descripcion, p.direccion, p.finalizacion.strftime("%d/%m/%Y"), p.finalizacion.strftime("%H:%M:%S").to_s,
                                         p.fin_direccion, p.tiempo_visita, p.teletrabajo, p.cargo], :style => estilos, :widths => tamano
                  end
=begin
                  sheet.add_row ["Fecha Inicio", "Usuario", "Empresa - Contrato", "Objetivo de la visita", "Direccion Inicio", "Fecha Finalizacion", "Direccion Finalizacion", "Tiempo", "Clase de Visita"],
                                :style => [title, title, title, title, title, header1, header1, header1, title]
                  for p in @visitas
                    estilos = [fecha_min, datoscent, datosiz, datosiz, datosiz, fecha_min, datosiz, datoscent, datoscent]
                    tamano = [18, 30, 30, 50, 120, 18, 120, 15, 15]
                    sheet.add_row [p.created_at, p.user.nombre, p.contrato.nombrecontrato, p.descripcion, p.direccion, p.finalizacion, p.fin_direccion, p.tiempo_visita, p.teletrabajo], :style => estilos, :widths => tamano
                  end
=end
                end
                ex.serialize(fNameRoot)
                send_file fNameRoot, x_sendfile: true
              end
            elsif @tipo.to_s == "PDF"

              fname = "Vistas"
              render pdf: "#{fname}.pdf", template: "visitas/visitas_pdf.html.erb",
                     #:save_to_file => "#{::Rails.root}/public/portafolios/#{isportafolio}/facturas/" + acta + '.pdf',
                     #:save_only => true,
                     disposition: 'attachment',
                     encoding: "UTF-8", page_size: 'Letter'

            else
              respond_to do |format|
                format.html # index.html.erb
                format.xml { render :xml => @visitas }
              end
            end
          end

        elsif @usr.subetapa.to_s == 'CONSOLIDADO'
          ActiveRecord::Base.connection.execute("CALL prc_visitasconsol") # El problema se presentaba en el prc
          @visitas = Visita.select("visitas.user_id,(select nombre from users where id = visitas.user_id) nombreuser,
                                    (select tiempo from info_visitasconsol where user_id = visitas.user_id and periodo = '2024-02') dato_202402,
                                    (select tiempo from info_visitasconsol where user_id = visitas.user_id and periodo = '2024-03') dato_202403,
                                    (select distinct 'X' from userspermisos where user_id = visitas.user_id and objeto_id = 144) existepermiso,
                                    (select distinct 'X' from userspermisos where user_id = visitas.user_id and objeto_id = 150) existetele,
                                    (select distinct 'X' from userspermisos where user_id = visitas.user_id and objeto_id = 151) existerutina")
                           .group("user_id")
                           .where("tiempo_visita_hora is not null and user_id in (SELECT distinct user_id from visitas where DATE_FORMAT(created_at, '%Y') = DATE_FORMAT(now(), '%Y'))") # and user_id in (SELECT user_id FROM view_supervisores)")
                           .distinct("user_id")
                           .order("2")
          @users = User.select("nombre nombreuser, celular,
                               (select distinct 'SI' from visitas where user_id = users.id
                                and DATE_FORMAT(created_at, '%Y-%m-%d') = DATE_FORMAT(now(), '%Y-%m-%d')) visitaeneldia, portafolio_id")
                       .where("id in (SELECT distinct user_id from visitas where DATE_FORMAT(created_at, '%Y-%m-%d') = DATE_FORMAT(now(), '%Y-%m-%d'))")
                       .order("3,1")
        elsif @usr.subetapa.to_s == 'CONSOLIDADOS'
          ActiveRecord::Base.connection.execute("CALL prc_visitasconsol") # El problema se presentaba en el prc
          @visitas = Visita.select("visitas.user_id,(select nombre from users where id = visitas.user_id) nombreuser,
                                    (select tiempo from info_visitasconsol where user_id = visitas.user_id and periodo = '2024-02') dato_202402,
                                    (select tiempo from info_visitasconsol where user_id = visitas.user_id and periodo = '2024-03') dato_202403,
                                    (select distinct 'X' from userspermisos where user_id = visitas.user_id and objeto_id = 144) existepermiso,
                                    (select distinct 'X' from userspermisos where user_id = visitas.user_id and objeto_id = 150) existetele,
                                    (select distinct 'X' from userspermisos where user_id = visitas.user_id and objeto_id = 151) existerutina")
                           .group("user_id")
                           .where("tiempo_visita_hora is not null and user_id in (SELECT user_id FROM view_supernumerarios)")
                           .distinct("user_id")
                           .order("2")
          @users = User.select("nombre nombreuser, celular,
                               (select distinct 'SI' from visitas where user_id = users.id
                                and DATE_FORMAT(created_at, '%Y-%m-%d') = DATE_FORMAT(now(), '%Y-%m-%d')) visitaeneldia")
                       .where("id in (SELECT user_id FROM view_supernumerarios)")
                       .order("3,1")

        elsif ['PROCESO', 'CONSOLIDADO', 'CONSOLIDADOS'].exclude?(@usr.subetapa.to_s)
          @visitas = Visita.select("visitas.id,visitas.user_id,visitas.descripcion,visitas.latitude,visitas.longitude,visitas.direccion,visitas.created_at,visitas.updated_at,
                                    visitas.contrato_id,visitas.finalizacion,visitas.fin_latitude,visitas.fin_longitude,visitas.fin_direccion,visitas.tiempo_visita,visitas.map_image,
                                    (select nombre from users where id = visitas.user_id) nombreuser,
                                    (select tipoconsulta from users where id = visitas.user_id) tipoconsultauser,
                                    (select autobuscar from empresas where id = (select empresa_id from contratos where id = visitas.contrato_id)) identnombre,
                                    (select nro_contrato from contratos where id = visitas.contrato_id) nro_contrato
                                    ")
                           .where("date(created_at) = '#{@usr.subetapa.to_s}'")
                           .order("created_at desc")
          respond_to do |format|
            format.html # index.html.erb
            format.xml { render :xml => @visitas }
          end
        end
      end
    end
  end

  def informe_general
    @etapa = params[:etapa].present? ? params[:etapa] : 'A'
    @usr = current_user
    @isadmin = @usr.id
    is_auth_c_exception_visita = is_auth_c('exception_visita')
=begin
SE COMENTA PORQUE FABI DIJO QUE SOLO DEJARAMOS EL DE LA EMPRESA CON CONTRATO
    if @etapa == 'A'
      @visitas = Visita.select("visitas.user_id,(select nombre from users where id = visitas.user_id) nombreuser,
                                (select tiempo from info_visitasconsol where user_id = visitas.user_id and periodo = '2024-02') dato_202402,
                                (select tiempo from info_visitasconsol where user_id = visitas.user_id and periodo = '2024-03') dato_202403,
                                (select distinct 'X' from userspermisos where user_id = visitas.user_id and objeto_id = 144) existepermiso,
                                (select distinct 'X' from userspermisos where user_id = visitas.user_id and objeto_id = 150) existetele,
                                (select distinct 'X' from userspermisos where user_id = visitas.user_id and objeto_id = 151) existerutina")
                       .group("user_id")
                       .where("tiempo_visita_hora is not null")
                       .distinct("user_id")
                       .order("2")
=end
    if @etapa == 'A'
      nroreg = 10
      if params[:autobuscar].to_s != ""
        @empresas = Empresa.searchInforme(params[:autobuscar], params[:page], 10)
      else
        @empresas = Empresa.all.order("nombre ASC")
      end

    elsif @etapa == 'C'
      start_date = Date.new(2024, 5, 1)
      end_date = Date.today.end_of_month
      @mesactual = Date.today.month
      @meses = (start_date..end_date).map { |date| { mes: date.strftime("%m").to_i, anno: date.year } }.uniq { |month| [month[:mes], month[:anno]] }
      @periodos = @meses.sort_by { |month| [-month[:anno], -month[:mes]] }
    end
  end

  def periodos_anno
    @ruta = params[:ruta]
    @anno = params[:anno]
    @mesDato = params[:mes].to_s.rjust(2, '0')

    @mes = "#{@mesDato}-#{@anno}"

    @empresas = Contratosperuser
                  .joins(contratospersona: { contrato: :empresa })
                  .select("DISTINCT TRIM(CONCAT(empresas.nombre, ' - ', contratos.nro_contrato)) AS nombre_empresa, empresas.id AS empresa_id")
                  .order("nombre_empresa ASC")
  end

  def periodos_contrato
    @user_id = params[:user_id]
    @ruta = params[:ruta]
    @empresa = Empresa.find(params[:empresa_id])
    @contratos = Contrato.where(empresa_id: @empresa.id).order("fecha_inicio desc")
  end

  def show_contrato
    @ruta = params[:ruta]
    @contrato = Contrato.find(params[:contrato_id])
    start_date = Date.new(2024, 5, 1)
    end_date = Date.today.end_of_month
    @mesactual = Date.today.month
    @meses = (start_date..end_date).map { |date| { mes: date.strftime("%m").to_i, anno: date.year } }.uniq { |month| [month[:mes], month[:anno]] }
    @meses = @meses.sort_by { |month| [-month[:anno], -month[:mes]] }
  end

  def periodos
    @user_id = params[:user_id]
    @ruta = params[:ruta]
    @nombreuser = params[:nombreuser].gsub(' ', '_')
    start_date = Date.new(2024, 5, 1)
    end_date = Date.today.end_of_month
    @mesactual = Date.today.month
    @meses = (start_date..end_date).map { |date| { mes: date.strftime("%m").to_i, anno: date.year } }.uniq { |month| [month[:mes], month[:anno]] }
    @meses = @meses.sort_by { |month| [-month[:anno], -month[:mes]] }
  end

  def excepcion
    @user = User.find(params[:user_id])
    vcClase = params[:clase].to_s
    if vcClase == 'A'
      if Userspermiso.where("user_id = #{@user.id} and objeto_id = 144").present?
        Userspermiso.where(objeto_id: 144, user_id: @user.id).destroy_all
      else
        Userspermiso.create(user_id: @user.id, objeto_id: 144, actualiza: 'S', elimina: 'S', crea: 'S')
      end
    elsif vcClase == 'T'
      if Userspermiso.where("user_id = #{@user.id} and objeto_id = 150").present?
        Userspermiso.where(objeto_id: 150, user_id: @user.id).destroy_all
      else
        Userspermiso.create(user_id: @user.id, objeto_id: 150, actualiza: 'S', elimina: 'S', crea: 'S')
      end
    elsif vcClase == 'R'
      if Userspermiso.where("user_id = #{@user.id} and objeto_id = 151").present?
        Userspermiso.where(objeto_id: 151, user_id: @user.id).destroy_all
      else
        Userspermiso.create(user_id: @user.id, objeto_id: 151, actualiza: 'S', elimina: 'S', crea: 'S')
      end
    end
  end

  def informegeneral_contrato
    combine = params[:combine] rescue nil
    @mes = params[:mes].to_s
    @contrato = Contrato.find(params[:contrato_id])
    @empresa = @contrato.empresa
    @portafolio = Portafolio.find(@empresa.portafolio_id)
    @logo_firma = @portafolio.logo_firma
    @logo = @portafolio.logo_empresa_assets
    @nombre_firma = @portafolio.nombre_rep.to_s
    @grupoid = params[:contratosgrupo_id] rescue nil
    if @grupoid.present?
      @supervisores = Contratosperuser.select("distinct user_id, (select nombre from users where id = contratosperusers.user_id) nombreuser")
                                      .where("contratospersona_id in (select contratospersona_id from contratosperfechas where contrato_id = #{@contrato.id} and contratosgrupo_id = #{@grupoid})")
                                      .order("2 asc")

      @contratosperusers = Contratosperuser.where("contratospersona_id in (select contratospersona_id from contratosperfechas where contrato_id = #{@contrato.id} and contratosgrupo_id = #{@grupoid})") rescue nil

      @capacitacionesfotos = Capacitacion.where("id in (select capacitacion_id from contratoscapapersonas where DATE_FORMAT(fecha_finalizacion, '%m-%Y') = '#{@mes}' and contrato_id = #{@contrato.id}
                                                        and contratospersona_id in (select contratospersona_id from contratosperfechas where contrato_id = #{@contrato.id} and contratosgrupo_id = #{@grupoid}))")

    else

      @supervisores = Contratosperuser.select("distinct user_id, (select nombre from users where id = contratosperusers.user_id) nombreuser")
                                      .where("contratospersona_id in (select contratospersona_id from contratosperfechas where contrato_id = #{@contrato.id})")
                                      .order("2 asc")

      @contratosperusers = Contratosperuser.where("contratospersona_id in (select contratospersona_id from contratosperfechas where contrato_id = #{@contrato.id})") rescue nil

      @capacitacionesfotos = Capacitacion.where("id in (select capacitacion_id from contratoscapapersonas where DATE_FORMAT(fecha_finalizacion, '%m-%Y') = '#{@mes}' and contrato_id = #{@contrato.id})")
    end
    @capacitacionesfotos.each do |capacitacion|
      if @grupoid.present?
        contratoscapapersonasprocesos = Contratoscapapersona.where("estado_evaluacion = 'INICIAR CAPACITACION' and capacitacion_id = #{capacitacion.id} and contrato_id = #{@contrato.id}
                                                                  and contratospersona_id in (select contratospersona_id from contratosperfechas where contrato_id = #{@contrato.id} and contratosgrupo_id = #{@grupoid})")
        contratoscapapersonasfinalizados = Contratoscapapersona.where("estado_evaluacion = 'FINALIZADO' and  capacitacion_id = #{capacitacion.id} and contrato_id = #{@contrato.id}
                                                                      and contratospersona_id in (select contratospersona_id from contratosperfechas where contrato_id = #{@contrato.id} and contratosgrupo_id = #{@grupoid})")
        contratosperfechas = Contratosperfecha.where("estado ='ACTIVO' and contrato_id = #{@contrato.id} and contratosgrupo_id = #{@grupoid} and id not in (select contratosperfecha_id from contratoscapapersonas where capacitacion_id = #{capacitacion.id})")
      else
        contratoscapapersonasprocesos = Contratoscapapersona.where("estado_evaluacion = 'INICIAR CAPACITACION' and capacitacion_id = #{capacitacion.id} and contrato_id = #{@contrato.id}")
        contratoscapapersonasfinalizados = Contratoscapapersona.where("estado_evaluacion = 'FINALIZADO' and  capacitacion_id = #{capacitacion.id} and contrato_id = #{@contrato.id}")
        contratosperfechas = Contratosperfecha.where("estado ='ACTIVO' and contrato_id = #{@contrato.id} and id not in (select contratosperfecha_id from contratoscapapersonas where capacitacion_id = #{capacitacion.id})")
      end
      @valorpend = contratosperfechas.count rescue 0
      @valorpro = contratoscapapersonasprocesos.count rescue 0
      @valorf = contratoscapapersonasfinalizados.count rescue 0

      g = Gruff::Pie.new
      g.title = "Resultado"
      g.theme = {
        :colors => %w(red orange green),
        :marker_color => 'blue',
        :background_colors => %w(white white)
      }

      # Añadir datos con leyendas personalizadas
      g.data "PENDIENTES: #{@valorpend.to_i}", @valorpend.to_i
      g.data "EN PROCESO: #{@valorpro.to_i}", @valorpro.to_i
      g.data "FINALIZADO: #{@valorf.to_i}", @valorf.to_i

      # Guardar el gráfico en un archivo temporal
      temp_file = Tempfile.new(["capacitacion_#{capacitacion.id}", '.png'])
      g.write(temp_file.path)

      # Buscar y eliminar el registro de la tabla Graph
      Graph.where(tabla: 'INFORME_GENERAL', id_registro: capacitacion.id).destroy_all

      # Crear un nuevo objeto Graph y adjuntar la imagen
      @graph = Graph.new
      @graph.tabla = 'INFORME_GENERAL'
      @graph.id_registro = capacitacion.id
      @graph.graphimage = temp_file
      @graph.save

      # Eliminar el archivo temporal
      temp_file.close
      temp_file.unlink
    end

    respond_to do |format|
      format.pdf { render pdf: "InformeMensual_#{@mes}", template: "visitas/informemensual_contrato.html.erb", encoding: "UTF-8", page_size: 'Letter',
                          :margin => { top: 50, :bottom => 25, :left => 0, :right => 0 },
                          footer: { :html => { :template => 'visitas/footer_informe_general.html.erb' } },
                          :header => { spacing: 10, :html => { :template => 'visitas/header_informe_general.html.erb' } } }
    end
  end

  def self.informegeneral_contrato_combine(mes, contrato_id, isadmin)
    @mes = mes
    @contrato = Contrato.find(contrato_id)
    @empresa = @contrato.empresa
    @portafolio = Portafolio.find(@empresa.portafolio_id)
    @logo = @portafolio.logo_empresa_assets

    rutafact = "#{::Rails.root}/public/combinar/"
    fname = "InformeMensualContrato_#{@contrato.id}.pdf"
    rutanamefile = "#{::Rails.root}/public/combinar/#{fname}.pdf"
    pdf = ApplicationController.render pdf: "#{fname}", template: "visitas/informemensual_contrato.html.erb", :save_to_file => rutanamefile, :save_only => true,
                                       encoding: "UTF-8", page_size: 'Letter', margin: { top: 50, bottom: 25, left: 0, right: 0 },
                                       footer: { html: { template: 'visitas/footer_informe_general.html.erb',  locals: { portafolio: @portafolio, contrato: @contrato, mes: @mes, isadmin: isadmin, empresa: @empresa } } },
                                       header: { spacing: 10, html: { template: 'visitas/header_informe_general.html.erb',  locals: { logo: @logo, portafolio: @portafolio, contrato: @contrato, mes: @mes, isadmin: isadmin, empresa: @empresa } } },
                                       locals: { contrato: @contrato, mes: @mes, isadmin: isadmin, empresa: @empresa }
    save_path = Rails.root.join(rutafact, "#{fname}")
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
  end

  def informegeneral
    @user = User.find(params[:user_id])
    @mes = params[:mes].to_s

    @contratosperfecha = Contratosperfecha.where("estado = 'ACTIVO' and (fecha_fin is null or fecha_fin > now()) and contratospersona_id = (select id from contratospersonas where identificacion = '#{@user.identificacion}')").first rescue nil
    if @contratosperfecha.present?
      @contratospersona = @contratosperfecha.contratospersona
    else
      @contratospersona = Contratospersona.find_by_identificacion(@user.identificacion)
      @contratosperfecha = Contratosperfecha.where("contratospersona_id = #{@contratospersona.id}").last rescue nil
    end

    @visitas = Visita.select(:id, :user_id, :descripcion, :created_at, :finalizacion, :latitude, :longitude, :direccion, :contrato_id).where("DATE_FORMAT(finalizacion, '%m-%Y') = '#{@mes}' AND user_id = #{@user.id}").order("id asc")
    @visitasCount = Visita.where("DATE_FORMAT(finalizacion, '%m-%Y') = '#{@mes}' AND user_id = #{@user.id}") rescue 0
    @contratosvigentes = Contratosperfecha.where("DATE_FORMAT(fecha_inicio, '%m-%Y') = '#{@mes}' and contratospersona_id in (select contratospersona_id from contratosperusers where user_id = #{@user.id})")
    @contratosterminados = Contratosperfecha.where("DATE_FORMAT(fecha_fin, '%m-%Y') = '#{@mes}' and contratospersona_id in (select contratospersona_id from contratosperusers where user_id = #{@user.id})")
    @contratoscapacitaciones = Contratoscapapersona.where("DATE_FORMAT(fecha_finalizacion, '%m-%Y') = '#{@mes}' and contratoscapacitacion_id IN (SELECT id FROM contratoscapacitaciones WHERE user_supervisor = #{@user.id})")
    @evaluaciones = Evaluacionescontrato.where("user_id = #{@user.id} and DATE_FORMAT(created_at, '%m-%Y') = '#{@mes}' and evaluacion_id in (select id from evaluaciones where tipo = 'EVALUACION DESEMPENO')")

    @retiros = Solicitudesretiro.joins(:contrato, :contratospersona, :contratosgrupo)
                                .select("contratospersonas.autobuscar, (select autobuscar from empresas where id = contratos.empresa_id) identnombre,
                                                       contratos.nro_contrato, contratos.id idcontrato,
                                                       contratosgrupos.descripcion, contratosgrupos.termino,
                                                       (select nombre from users where id = solicitudesretiros.user_id) usernombre,
                                                       (select nombre from users where id = solicitudesretiros.user_aprobacion) useraprobanombre,
                                                       (case when solicitudesretiros.user_aprobacion is null then 'PENDIENTE'
                                                            when (solicitudesretiros.consecutivo is not null and solicitudesretiros.estado_final is null) then 'APROBADAS PARA PAGO'
                                                            when (solicitudesretiros.consecutivo is not null and solicitudesretiros.estado_final is not null) then 'PAGADAS'
                                                            when (solicitudesretiros.user_aprobacion is not null and solicitudesretiros.user_liquidacion is null and solicitudesretiros.consecutivo is null) then 'EN PROCESO'
                                                            end) estadoliquidacion,
                                                       solicitudesretiros.*")
                                .where("solicitudesretiros.user_id = #{@user.id} and DATE_FORMAT(fecha, '%m-%Y') = '#{@mes}'")
                                .order("contratospersonas.identificacion asc")

    @procesos = Contratosperproceso.where("user_id = #{@user.id} and DATE_FORMAT(created_at, '%m-%Y') = '#{@mes}'")
    respond_to do |format|
      format.pdf { render pdf: "InformeMensual_#{@mes}",
                          template: "visitas/informemensual.html.erb",
                          encoding: "UTF-8", page_size: 'Letter', :margin => { top: 10, :bottom => 10, :left => 10, :right => 10 } }
    end
  end

  require 'selenium-webdriver'

  def self.actualizar_todos
    Visita.select(:id).all.each do |visita|
      VisitasController.captura_imagen(visita.id)
    end
  end

  def self.captura_imagen(idVisita)
    @visita = Visita.find(idVisita)
    latitude = @visita.latitude
    longitude = @visita.longitude
    map_url = "https://www.openstreetmap.org/?mlat=#{latitude}&mlon=#{longitude}#map=15/#{latitude}/#{longitude}"

    screenshot_path = capture_map_screenshot(map_url, idVisita)

    save_screenshot_to_model(screenshot_path, idVisita)
  end

  require 'selenium-webdriver'

  def self.capture_map_screenshot(map_url, idVisita)
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless') # Ejecutar en modo sin cabeza (sin abrir una ventana)
    options.add_argument('--disable-gpu') # Deshabilitar GPU para mejorar la estabilidad en sistemas Unix
    options.add_argument('--disable-notifications') # Deshabilitar notificaciones
    options.add_argument('--disable-infobars') # Deshabilitar la barra de información
    options.add_argument('--disable-dev-shm-usage') # Solucionar problemas con /dev/shm

    driver = Selenium::WebDriver.for :chrome, options: options
    driver.navigate.to map_url

    # Espera a que el mapa se cargue completamente (puedes ajustar este tiempo según sea necesario)
    wait = Selenium::WebDriver::Wait.new(timeout: 10)
    wait.until { driver.execute_script("return document.readyState") == "complete" }

    # Elimina completamente el elemento con la clase 'welcome'
    driver.execute_script("var element = document.querySelector('.welcome.p-3'); if (element) element.parentNode.removeChild(element);")

    # Elimina completamente el elemento con el id 'sidebar'
    driver.execute_script("var element = document.getElementById('sidebar'); if (element) element.parentNode.removeChild(element);")

    # Elimina completamente el elemento con la clase 'd-flex closed'
    driver.execute_script("var element = document.querySelector('header.d-flex.closed'); if (element) element.parentNode.removeChild(element);")

    # Quita la clase 'map-layout' del elemento 'body'
    driver.execute_script("document.body.classList.remove('map-layout');")

    # Deshabilita la capa de atribución de OpenStreetMap
    driver.execute_script("document.querySelector('.leaflet-control-attribution').style.display = 'none';")

    sleep 2

    # Captura de pantalla del mapa
    screenshot_path = Rails.root.join('public', "visita_#{idVisita}.png")
    driver.save_screenshot(screenshot_path.to_s)

    driver.quit

    screenshot_path
  end

  def self.save_screenshot_to_model(screenshot_path, idVisita)
    visita = Visita.find(idVisita)
    visita.doc_georeferenciacion = File.open(screenshot_path, 'rb')
    visita.save(validate: false)
  end

  def vistaexcel
  end

  def consolidado
    @visita = Visita.find(params[:id])
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Visita.find(params[:active_id]) if params[:active_id].present?
    @visita = Visita.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Visita.find(params[:active_id]) if params[:active_id].present?
    @visita = Visita.find(params[:id])
    respond_to { |format| format.js }

  end

  def create
    @validacion = false
    @visita = Visita.new(visita_params)
    @visita.user_id = is_admin
    if @visita.latitude.blank? && @visita.longitude.blank?
      @validacion = true
    end
    respond_to do |format|
      if @visita.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @visita } }
      end
    end
  end

  def update
    @visita.finalizacion = Time.now
    respond_to do |format|
      if @visita.update(visita_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @visita } }
      end
    end
  end

  def destroy
    @visita.destroy
    flash['success'] = "Eliminado con exito"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_visita
    @visita = Visita.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def visita_params
    params.require(:visita).permit!
  end

  def set_layout
    if ['index', 'new'].include?(action_name) and
      Objeto.find_by_sql("SELECT user_id FROM view_supervisores WHERE user_id = #{current_user.id}").present? and
      Visita.where(user_id: current_user.id).where('DATE(created_at) = ?', Date.today).blank? and
      is_auth_c('excluir_primera_visita') == false
      "inscripcion_layoutmetro"
    elsif ['index', 'new', 'complementar', 'antes_trasera', 'antes', 'despues'].include?(action_name) and ['PERSONA', 'METRO'].include?(User.find(is_admin).tipoconsulta.to_s)
      'application'
    elsif ['index', 'new'].include?(action_name) and ['PERSONA', 'METRO'].exclude?(User.find(is_admin).tipoconsulta.to_s)
      'application_admin'
    elsif ['formato'].include?(action_name)
      "basicoreporte"
    elsif ['primer_registro'].include?(action_name)
      "inscripcion_layoutmetro"
    elsif ['edit'].include?(action_name)
      'application_users'
    else
      'application_admin'
    end
  end
end
