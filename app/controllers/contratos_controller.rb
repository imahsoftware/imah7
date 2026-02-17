class ContratosController < ApplicationController
  before_action :set_contrato, only: [:show, :edit, :update, :destroy]

  layout :set_layout
  before_action :checkaccess, except: ['capacitacion', 'capacitacionesusuario','ws_otp','show_detalle','marcar_capacitacion','marcar_noaplica','iniciar_capacitacion']

  def checkaccess
    return is_permit('empresas')
  end

  def capacitacion
    @capacitaciones = Contratoscapacitacion.where("user_supervisor = #{is_admin} and  capacitacion_id IN (SELECT id FROM capacitaciones WHERE fecha_limite >= CURDATE())")
  end

  def download
    contratoId = params[:contrato_id]
    @contratosperfechas = Contratosperfecha.select("distinct contrato_id, date_format(fecha_inicio,'%Y-%m') fchincio")
                                           .where("contrato_id = #{contratoId}").order("date_format(fecha_inicio,'%Y-%m') asc")
  end

  def marcar_todo
    vcInterno = params[:interno].to_s rescue nil
    if vcInterno.to_s == 'SI'
      @contratoscapacitacion = Contratoscapacitacion.find(params[:contratoscapacitacion_id])
      ActiveRecord::Base.connection.execute("update contratoscapacitaciones set interno = 'SI' where id = #{@contratoscapacitacion.id}")
    elsif vcInterno.to_s == 'NO'
      @contratoscapacitacion = Contratoscapacitacion.find(params[:contratoscapacitacion_id])
      ActiveRecord::Base.connection.execute("update contratoscapacitaciones set interno = 'NO' where id = #{@contratoscapacitacion.id}")
    elsif vcInterno.to_s == 'NN'
      nmContratosCargoId = params[:contratoscargoid].to_s rescue nil
      @contratoscapacitacion = Contratoscapacitacion.find(params[:contratoscapacitacion_id])
      ActiveRecord::Base.connection.execute("CALL prc_incluircapa_cargo(#{@contratoscapacitacion.id},#{nmContratosCargoId},'INCLUIR')")
      flash[:notice] = "Incluidas con exito, solo el cargo.....!!!"
    elsif vcInterno.to_s == 'RR'
      nmContratosCargoId = params[:contratoscargoid].to_s rescue nil
      @contratoscapacitacion = Contratoscapacitacion.find(params[:contratoscapacitacion_id])
      ActiveRecord::Base.connection.execute("CALL prc_incluircapa_cargo(#{@contratoscapacitacion.id},#{nmContratosCargoId},'ELIMINAR')")
      flash[:notice] = "Eliminadas con exito, solo el cargo.....!!!"
    else
      @contratoscapacitacion = Contratoscapacitacion.find(params[:contratoscapacitacion_id])
      @contratosperfechas = Contratosperfecha.where("contrato_id = #{@contratoscapacitacion.contrato_id}
                                                 and id not in (select distinct contratosperfecha_id from contratoscapapersonas where contratoscapacitacion_id = #{@contratoscapacitacion.id})")
      @contratosperfechas.each do |contratosperfecha|
        Contratoscapapersona.create!(contrato_id: contratosperfecha.contrato_id, capacitacion_id: @contratoscapacitacion.capacitacion_id, contratoscapacitacion_id: @contratoscapacitacion.id, contratospersona_id: contratosperfecha.contratospersona_id, contratosperfecha_id: contratosperfecha.id, ruta: 'A')
      end
      flash[:notice] = "Se marco todos con exito!!!"
    end
    respond_to do |format|
      format.js { render inline: "location.reload();" }
    end
  end

  def show_detalle
    @etapa = params[:etapa].present? ? params[:etapa] : 'A' rescue nil
    @contratoscapacitacion = Contratoscapacitacion.find(params[:contratoscapacitacion_id])
    if @contratoscapacitacion.interno.to_s == 'SI'
      @contratosperfechas = Contratosperfecha.where("estado ='INTERNO'")
    else
      @contratosperfechas = Contratosperfecha.where("estado ='ACTIVO' and fecha_inicio <= '#{@contratoscapacitacion.capacitacion.fecha_limite.to_date}' and (fecha_fin is null or fecha_fin > now())
                                                     and contrato_id = #{@contratoscapacitacion.contrato_id}
                                                     and id not in (select contratosperfecha_id from contratoscapapersonas where capacitacion_id = #{@contratoscapacitacion.capacitacion_id})").order("id asc")
    end
    @contratoscapapersonasprocesos = Contratoscapapersona.where("estado_evaluacion = 'INICIAR CAPACITACION' and contratoscapacitacion_id = #{@contratoscapacitacion.id}")
    @contratoscapapersonasfinalizados = Contratoscapapersona.where("estado_evaluacion = 'FINALIZADO' and  contratoscapacitacion_id = #{@contratoscapacitacion.id}")
    @contratoscapapersonasnoaplica = Contratoscapapersona.where("estado_evaluacion = 'NO APLICA' and  contratoscapacitacion_id = #{@contratoscapacitacion.id}")

    @valorpend = @contratosperfechas.count rescue 0
    @valornoaplica = @contratoscapapersonasnoaplica.count rescue 0
    @valorpro = @contratoscapapersonasprocesos.count rescue 0
    @valorf = @contratoscapapersonasfinalizados.count rescue 0
    @contratoscaparesultados = Contratoscaparesultado.new
  end

  def capacitacionesusuario
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratoscapapersonas = Contratoscapapersona.where("contratospersona_id = #{@contratospersona.id} and estado_evaluacion = 'INICIAR CAPACITACION'")
  end

  def iniciar_capacitacion
    @contratoscapacitacion = Contratoscapacitacion.find(params[:contratoscapacitacion_id])
    @contratosperfechas = Contratoscapapersona.where("contrato_id = #{@contratoscapacitacion.contrato_id} and contratoscapacitacion_id = #{@contratoscapacitacion.id} and estado_evaluacion = 'PENDIENTE'")
    @contratosperfechas.update_all(estado_evaluacion: 'INICIAR CAPACITACION')
    @contratoscapacitacion.update(estado: 'INICIAR CAPACITACION', fecha_inicio_capacitacion: Time.now)
    ActiveRecord::Base.connection.execute("CALL prc_capacitaciones_contratos(#{@contratoscapacitacion.capacitacion_id},-1,'INICIARCAPA')")
    respond_to do |format|
      flash[:notice] = "La capcitacion ha iniciado correctamente!!!"
      format.js { render inline: "location.reload();" }
    end
  end

  def marcar_capacitacion
    @contratosperfecha = Contratosperfecha.find(params[:contratosperfecha_id])
    @contratoscapacitacion = Contratoscapacitacion.find(params[:contratoscapacitacion_id])
    @contrato = Contrato.find(params[:contrato_id])
    contratoscapa = Contratoscapapersona.create!(contrato_id: @contrato.id, capacitacion_id: @contratoscapacitacion.capacitacion_id, contratoscapacitacion_id: @contratoscapacitacion.id,
                                                 contratospersona_id: @contratosperfecha.contratospersona_id, contratosperfecha_id: @contratosperfecha.id, ruta: 'A').id
    #Capacitacionevaluacion.where(capacitacion_id: @contratoscapacitacion.capacitacion_id, estado: 'ACTIVO').order("id asc").each do |eva|
    #  Contratoscaparesultado.create!(capacitacionevaluacion_id: eva.id, capacitacion_id: @contratoscapacitacion.capacitacion_id, contrato_id: @contrato.id,
    #                                  contratoscapapersona_id: contratoscapa, contratosperfecha_id: @contratosperfecha.id, ruta: 'A')
    #end
  end


  def marcar_noaplica
    vcMotivo = params[:motivo].to_s
    if vcMotivo == 'NN'
      @contratosperfechas = Contratoscapapersona.where("id = #{params[:contratoscapapersona_id]}")
      @contratosperfechas.update_all(estado_evaluacion: 'PENDIENTE')
    else
      @contratosperfecha = Contratosperfecha.find(params[:contratosperfecha_id])
      @contratoscapacitacion = Contratoscapacitacion.find(params[:contratoscapacitacion_id])
      @contrato = Contrato.find(params[:contrato_id])
      contratoscapa = Contratoscapapersona.create!(contrato_id: @contrato.id, capacitacion_id: @contratoscapacitacion.capacitacion_id, contratoscapacitacion_id: @contratoscapacitacion.id,
                                                   contratospersona_id: @contratosperfecha.contratospersona_id, contratosperfecha_id: @contratosperfecha.id, ruta: 'A',
                                                   estado_evaluacion: 'NO APLICA', motivo: vcMotivo).id
    end
    respond_to do |format|
      format.js { render inline: "location.reload();" }
    end
  end

  def new
    @contrato = Contrato.new
    @contrato.etapa = 'A'
    @contrato.empresa_id = params[:empresa_id]
    render "contrato_form"
  end

  def edit
    @cadper = []
    obj = Users
    Userspermiso.joins(:objeto).where(["userspermisos.user_id = #{is_admin} and objetos.descripcion like 'contratosopc%%'"]).select("replace(objetos.descripcion,'contratosopc','') descr").each do |a|
      @cadper << a.descr
    end
    if @etapa.to_s == 'F'
      if @insumoId.to_s != ""
        @insumos = @contrato.contratosinsumos
                            .select(["contratosinsumos.*, (select distinct 'X' from contratossoldetalles where contratosinsumo_id = contratosinsumos.id) existedet,
                                          (select distinct 'X' from contratosinsimagenes where contratosinsumo_id = contratosinsumos.id) existeimg,
                                          (select presentacion from insumos where id = contratosinsumos.insumocce) presentacion"])
                            .where(["insumo_id = #{@insumoId}"]).order("contratosinsumos.id asc").paginate(:page => params[:insumo], :per_page => 10)
      else
        @insumos = @contrato.contratosinsumos
                            .select(["contratosinsumos.*, (select distinct 'X' from contratossoldetalles where contratosinsumo_id = contratosinsumos.id) existedet,
                                           (select distinct 'X' from contratosinsimagenes where contratosinsumo_id = contratosinsumos.id) existeimg,
                                           (select presentacion from insumos where id = contratosinsumos.insumocce) presentacion"])
                            .order("contratosinsumos.id asc").paginate(:page => params[:insumo], :per_page => 10)
      end
      @contrato.contratosautoinsumos.order("created_at desc")
    elsif @etapa.to_s == 'H'
      @contratosedes = @contrato.contratossedes.order("updated_at desc").paginate(:page => params[:contratosedes], :per_page => 10)
    elsif @etapa.to_s == 'AC'
      @contratosactividades = @contrato.contratosactividades.order("updated_at desc").paginate(:page => params[:contratosactividades], :per_page => 10)
    elsif @etapa.to_s == 'PR'
      if @subetapa == '10'
        @idportafolio = @contrato.empresa.portafolio_id
        @contratosprefacturas = @contrato.contratosprefacturas
                                         .select("contratosprefacturas.*, (select distinct 'X' from contratospagos where contratosprefactura_id = contratosprefacturas.id) existepag")
                                         .order("id desc")
      end
    elsif @etapa.to_s == 'M'
      if @insumoId.to_s != ""
        @maquinarias = @contrato.contratosmaquinarias.where(["cantidad_mensual > 0 and insumo_id = #{@insumoId}"]).order("id asc")
      else
        @maquinarias = @contrato.contratosmaquinarias.where(["cantidad_mensual > 0"]).paginate(:page => params[:insumo], :per_page => 10).order("id asc")
      end
    elsif @etapa.to_s == 'S'
      @contratossolicitudes = @contrato.contratossolicitudes.order("created_at desc")
    elsif @etapa.to_s == 'P1'
      if @subetapa == '1'
        @contratospersonassin = @contrato.contratospersonas.where("contratospersonas.id not in (select distinct contratospersona_id from contratosperexamenes)
                                                                 and contratospersonas.id not in (select distinct contratospersona_id from contratosperestados)").order("created_at desc")
        if @contratospersonassin.count.to_i == 0
          @contratospersonas = @contrato.contratospersonas.where("contratospersonas.id not in (select distinct contratospersona_id from contratosperestados)").order("created_at desc")
        else
          @contratospersonas = @contrato.contratospersonas.where("contratospersonas.id in (select distinct contratospersona_id from contratosperexamenes)
                                                                 and contratospersonas.id not in (select distinct contratospersona_id from contratosperestados)").order("created_at desc")
        end
      elsif @subetapa == '2'
        @contratosperexamenesp = Contratosperexamen.where("estado = 'PENDIENTE' and contratospersona_id in (select id from contratospersonas where contrato_id = #{@contrato.id})").order("created_at desc")
      elsif @subetapa == '3'
        @contratosperexamenesr = Contratosperexamen.where("estado != 'PENDIENTE' and contratospersona_id in (select id from contratospersonas where contrato_id = #{@contrato.id})").order("created_at desc")
        @contratosperexamenesra = Contratosperexamen.where("estado = 'APROBADO' and contratospersona_id in (select id from contratospersonas where contrato_id = #{@contrato.id} and tienecontrato is null)").order("created_at desc")
        @contratosperexamenesrr = Contratosperexamen.where("estado = 'RECHAZADO' and contratospersona_id in (select id from contratospersonas where contrato_id = #{@contrato.id})").order("created_at desc")
      elsif @subetapa == '4'
        @contratospersonascon = Contratospersona.where("contrato_id = #{@contrato.id} and tienecontrato = 'SI'").order("updated_at asc")
      elsif @subetapa == '5'
        @contratospersonasdot = Contratospersona.where("contrato_id = #{@contrato.id} and tienecontrato = 'SI' and dotacion = 'SI'").order("updated_at asc")
      elsif @subetapa == '6'
        @contratospersonascar = Contratospersona.where("contrato_id = #{@contrato.id} and tienecontrato = 'SI' and dotacion = 'SI' and carnet = 'SI'").order("updated_at asc")
      elsif @subetapa == '7'
        @contratosperestados = Contratosperestado.where("contratospersona_id in (select id from contratospersonas where contrato_id = #{@contrato.id})").order("created_at desc")
      end
      # Para los contadores de la parte superior del menu
      @contratospersonas_c = @contrato.contratospersonas.where("contratospersonas.id not in (select distinct contratospersona_id from contratosperestados)").count.to_i rescue 0
      @contratosperexamenesp_c = Contratosperexamen.where("estado = 'PENDIENTE' and contratospersona_id in (select id from contratospersonas where contrato_id = #{@contrato.id})").count.to_i rescue 0
      @contratosperexamenesr_c = Contratosperexamen.where("estado = 'APROBADO' and contratospersona_id in (select id from contratospersonas where contrato_id = #{@contrato.id} and tienecontrato is null)").count.to_i rescue 0
      @contratospersonascon_c = Contratospersona.where("contrato_id = #{@contrato.id} and tienecontrato = 'SI'").count.to_i rescue 0
      @contratospersonasdot_c = Contratospersona.where("contrato_id = #{@contrato.id} and tienecontrato = 'SI' and dotacion = 'SI'").count.to_i rescue 0
      @contratospersonascar_c = Contratospersona.where("contrato_id = #{@contrato.id} and tienecontrato = 'SI' and dotacion = 'SI' and carnet = 'SI'").count.to_i rescue 0
      @contratosperestados_c = Contratosperestado.where("contratospersona_id in (select id from contratospersonas where contrato_id = #{@contrato.id})").count.to_i rescue 0
    end
    respond_to do |format|
      format.html { render :action => "contrato_form" }
    end
  end

  def create
    @contrato = Contrato.new(contrato_params)
    @contrato.etapa = 'A'
    @contrato.user_id = is_admin
    respond_to do |format|
      if @contrato.save
        ActiveRecord::Base.connection.execute("CALL prc_contrato()")
        format.html { redirect_to edit_contrato_path(etapa: "A", id: @contrato.id), notice: "El registro ha sido registrado con Exito." }
        format.json { render :show, status: :created, location: @contrato }
      else
        format.html { render :action => "contrato_form" }
        format.json { render json: @contrato.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @contrato.user_act = is_admin
    if @contrato.update(contrato_params)
      flash['danger'] = "Usuario actualizado"
      ActiveRecord::Base.connection.execute("CALL prc_calculomodificacion(#{@contrato.id})")
      redirect_to edit_contrato_path(id: @contrato.id, etapa: 'A')
    else
      render "contrato_form"
    end
  end

  def destroy
    idEmpresa = @contrato.empresa_id
    @contrato.destroy
    flash[:notice] = "El registro ha sido borrado con Exito."
    redirect_to edit_empresa_path(id: idEmpresa, etapa: 'A')
  end

  def abrircargue
    @archivo = Archivo.new
    @archivo.datoid = params[:id]
    @archivo.clase = params[:clase].to_s
    # respond_to { |format| format.js }
  end
  
  def depurarsedes
    @contrato = Contrato.find(params[:id])
    if Contratossolicitud.where(contrato_id: @contrato.id).exists? == false
      Contratossede.where(contrato_id: @contrato.id).delete_all
      flash['danger'] = "Depuracion realizada"
    end
    redirect_to edit_contrato_path(id: @contrato.id, etapa: 'H')
  end

  def validacion
    @contratoid = params[:id]
  end

  def cargar
    archivo = params[:file]
    contratoid = params[:contratoid]
    if archivo
      name = archivo.original_filename
      directory = "public/archivos/"
      path = File.join(directory, name)
      extensionarchivo = name.slice(name.rindex("."), name.length).downcase
      if extensionarchivo == ".xlsx" or extensionarchivo == ".xls" or extensionarchivo == ".xlsb"
        File.open(path, "wb") { |f| f.write(archivo.read) }
        spreadsheet = Roo::Spreadsheet.open(path, extension: extensionarchivo)
        spreadsheet.sheets.each do |sheet|
          # ----------
          # ----------
          # ----------

          if ['Solicitud de Cotización General', 'Detalle Bienes de Aseo y Caf', 'Detalle Especificaciones', 'Resumen - CSV', 'Cotizacion Bienes de Aseo y Ca', 'Cotizacion'].include?(sheet)
            if sheet.to_s == 'Detalle Especificaciones'
              puts "======================================================================"
              puts 'Inicio... ' + sheet.to_s
              puts "======================================================================"
              hoja = spreadsheet.sheet(sheet)
              cant = 0
              i = 0
              migrep = []
              while cant <= 40
                if hoja.row(2)[i].to_s != ""
                  namsede = hoja.row(2)[i].to_s
                  namsede = namsede.gsub("Especificaciones del servicio - ", "")
                  nombresede = hoja.row(7)[i + 2].upcase.to_s + ' - ' + namsede.upcase.to_s
                  if Contratossede.where(contrato_id: contratoid, nombre: nombresede).exists? == false
                    contratossede = Contratossede.new(contrato_id: contratoid, nombre: nombresede,
                                                      direccion: hoja.row(8)[i + 2].upcase.to_s,
                                                      telefono: hoja.row(8)[i + 7].to_s,
                                                      departamento: hoja.row(9)[i + 2].to_s,
                                                      municipio: hoja.row(9)[i + 6].to_s)
                    migrep << contratossede
                  end
                end
                if i == 0
                  i = i + 10
                else
                  i = i + 9
                end
                cant = cant + 1
              end
              imported_obj = Contratossede.import migrep, recursive: true, validate: false
              puts "======================================================================"
              puts 'Finalizo... ' + sheet.to_s
              puts "======================================================================"
            end

            # ----------
            # ----------
            # ----------

            if sheet.to_s == 'Solicitud de Cotización General1'
              puts "======================================================================"
              puts 'Inicio... ' + sheet.to_s
              puts "======================================================================"
              hoja = spreadsheet.sheet(sheet)
              cant = 0
              i = 0
              fila = 17
              while cant <= 5
                # puts "Fila " + fila.to_s + " --  Columnna " +  i.to_s
                if ['Tiempo completo', 'Medio Tiempo', 'Personal por Turnos', 'Disminución del personal'].include?(hoja.row(fila)[i].to_s)
                  disponibilidad = hoja.row(fila)[i].upcase.to_s
                  finaliza = 0
                  fila = fila + 1
                  while finaliza == 0
                    if ['1. Si requiere agregue o elimine filas de Personal TC', '1. Si requiere agregue o elimine filas de Personal MT', '1. Si requiere agregue o elimine filas de Personal Turno', 'Total N° de operarios requeridos:'].include?(hoja.row(fila)[0].to_s)
                      finaliza = 1
                      fila = fila + 1
                      i = 0
                    else
                      if hoja.row(fila)[0].to_s != ""
                        if Contratoscargo.where(contrato_id: contratoid, disponibilidad: disponibilidad).exists? == false
                          i = 0
                          a = 9
                          Contratoscargo.create(contrato_id: contratoid,
                                                disponibilidad: disponibilidad,
                                                perfil: hoja.row(fila)[0].to_s,
                                                cantidad: hoja.row(fila)[i + 2].to_s,
                                                dias_trabajo: hoja.row(fila)[i + 3].to_s,
                                                horario: hoja.row(fila)[i + 4].to_s,
                                                observaciones: hoja.row(fila)[i + 5].to_s,
                                                sede1: hoja.row(fila)[a].to_s,
                                                sede2: hoja.row(fila)[a + 1].to_s,
                                                sede3: hoja.row(fila)[a + 2].to_s,
                                                sede4: hoja.row(fila)[a + 3].to_s,
                                                sede5: hoja.row(fila)[a + 4].to_s,
                                                sede6: hoja.row(fila)[a + 5].to_s,
                                                sede7: hoja.row(fila)[a + 6].to_s,
                                                sede8: hoja.row(fila)[a + 7].to_s,
                                                sede9: hoja.row(fila)[a + 8].to_s,
                                                sede10: hoja.row(fila)[a + 9].to_s,
                                                sede11: hoja.row(fila)[a + 10].to_s,
                                                sede12: hoja.row(fila)[a + 11].to_s,
                                                sede13: hoja.row(fila)[a + 12].to_s,
                                                sede14: hoja.row(fila)[a + 13].to_s,
                                                sede15: hoja.row(fila)[a + 14].to_s,
                                                sede16: hoja.row(fila)[a + 15].to_s,
                                                sede17: hoja.row(fila)[a + 16].to_s,
                                                sede18: hoja.row(fila)[a + 17].to_s,
                                                sede19: hoja.row(fila)[a + 18].to_s,
                                                sede20: hoja.row(fila)[a + 19].to_s,
                                                sede21: hoja.row(fila)[a + 20].to_s,
                                                sede22: hoja.row(fila)[a + 21].to_s,
                                                sede23: hoja.row(fila)[a + 22].to_s,
                                                sede24: hoja.row(fila)[a + 23].to_s,
                                                sede25: hoja.row(fila)[a + 24].to_s,
                                                sede26: hoja.row(fila)[a + 25].to_s,
                                                sede27: hoja.row(fila)[a + 26].to_s,
                                                sede28: hoja.row(fila)[a + 27].to_s,
                                                sede29: hoja.row(fila)[a + 28].to_s,
                                                sede30: hoja.row(fila)[a + 29].to_s,
                                                sede31: hoja.row(fila)[a + 30].to_s,
                                                sede32: hoja.row(fila)[a + 31].to_s,
                                                sede33: hoja.row(fila)[a + 32].to_s,
                                                sede34: hoja.row(fila)[a + 33].to_s,
                                                sede35: hoja.row(fila)[a + 34].to_s,
                                                sede36: hoja.row(fila)[a + 35].to_s,
                                                sede37: hoja.row(fila)[a + 36].to_s,
                                                sede38: hoja.row(fila)[a + 37].to_s,
                                                sede39: hoja.row(fila)[a + 38].to_s,
                                                sede40: hoja.row(fila)[a + 39].to_s)
                        else
                          puts "Ya creado..."
                        end
                      end
                      fila = fila + 1
                    end
                  end
                  cant = cant + 1
                end
                fila = fila + 1
                i = 0
                cant = cant + 1
              end
              puts "======================================================================"
              puts 'Finalizo... ' + sheet.to_s
              puts "======================================================================"
            end

            # ----------
            # ----------
            # ----------

            if sheet.to_s == 'Cotizacion Bienes de Aseo y Ca'
              puts "======================================================================"
              puts 'Inicio... ' + sheet.to_s
              puts "======================================================================"
              hoja = spreadsheet.sheet(sheet)
              cant = 0
              i = 0
              fila = 13
              finaliza = 0
              migrep = []
              while finaliza == 0
                if hoja.row(fila)[0].to_s != "" and hoja.row(fila)[0].to_i > 0 and hoja.row(fila)[4].to_f > 0 # 20200912 Esta ultima es para solo agregar los que tienen cantidades
                  if Insumo.exists?(id: hoja.row(fila)[i]) == true
                    if Contratosinsumo.exists?(contrato_id: contratoid, insumo_id: hoja.row(fila)[0].to_i) == false
                      i = 0
                      a = 10
                      contratosinsumo = Contratosinsumo.new(contrato_id: contratoid,
                                                            insumo_id: hoja.row(fila)[0].to_i,
                                                            cantidad_mensual: hoja.row(fila)[4].to_s,
                                                            precio_unitario: hoja.row(fila)[5].to_f,
                                                            descuento: hoja.row(fila)[6].to_f * 100,
                                                            precio_condescuento: hoja.row(fila)[7].to_f,
                                                            total: hoja.row(fila)[8].to_f,
                                                            cantsede_1: hoja.row(fila)[a].to_f,
                                                            cantsede_2: hoja.row(fila)[a + 1].to_f,
                                                            cantsede_3: hoja.row(fila)[a + 2].to_f,
                                                            cantsede_4: hoja.row(fila)[a + 3].to_f,
                                                            cantsede_5: hoja.row(fila)[a + 4].to_f,
                                                            cantsede_6: hoja.row(fila)[a + 5].to_f,
                                                            cantsede_7: hoja.row(fila)[a + 6].to_f,
                                                            cantsede_8: hoja.row(fila)[a + 7].to_f,
                                                            cantsede_9: hoja.row(fila)[a + 8].to_f,
                                                            cantsede_10: hoja.row(fila)[a + 9].to_f,
                                                            cantsede_11: hoja.row(fila)[a + 10].to_f,
                                                            cantsede_12: hoja.row(fila)[a + 11].to_f,
                                                            cantsede_13: hoja.row(fila)[a + 12].to_f,
                                                            cantsede_14: hoja.row(fila)[a + 13].to_f,
                                                            cantsede_15: hoja.row(fila)[a + 14].to_f,
                                                            cantsede_16: hoja.row(fila)[a + 15].to_f,
                                                            cantsede_17: hoja.row(fila)[a + 16].to_f,
                                                            cantsede_18: hoja.row(fila)[a + 17].to_f,
                                                            cantsede_19: hoja.row(fila)[a + 18].to_f,
                                                            cantsede_20: hoja.row(fila)[a + 19].to_f,
                                                            cantsede_21: hoja.row(fila)[a + 20].to_f,
                                                            cantsede_22: hoja.row(fila)[a + 21].to_f,
                                                            cantsede_23: hoja.row(fila)[a + 22].to_f,
                                                            cantsede_24: hoja.row(fila)[a + 23].to_f,
                                                            cantsede_25: hoja.row(fila)[a + 24].to_f,
                                                            cantsede_26: hoja.row(fila)[a + 25].to_f,
                                                            cantsede_27: hoja.row(fila)[a + 26].to_f,
                                                            cantsede_28: hoja.row(fila)[a + 27].to_f,
                                                            cantsede_29: hoja.row(fila)[a + 28].to_f,
                                                            cantsede_30: hoja.row(fila)[a + 29].to_f,
                                                            cantsede_31: hoja.row(fila)[a + 30].to_f,
                                                            cantsede_32: hoja.row(fila)[a + 31].to_f,
                                                            cantsede_33: hoja.row(fila)[a + 32].to_f,
                                                            cantsede_34: hoja.row(fila)[a + 33].to_f,
                                                            cantsede_35: hoja.row(fila)[a + 34].to_f,
                                                            cantsede_36: hoja.row(fila)[a + 35].to_f,
                                                            cantsede_37: hoja.row(fila)[a + 36].to_f,
                                                            cantsede_38: hoja.row(fila)[a + 37].to_f,
                                                            cantsede_39: hoja.row(fila)[a + 38].to_f,
                                                            cantsede_40: hoja.row(fila)[a + 39].to_f)
                      migrep << contratosinsumo
                    end
                  end
                end
                fila = fila + 1
                # puts 'Vamos...... ' + hoja.row(fila)[0].to_s
                if hoja.row(fila)[0].to_s == 'TOTAL Mensual Bienes de Aseo y Cafetería '
                  imported_obj = Contratosinsumo.import migrep, recursive: true, validate: false
                  finaliza = 1
                end
              end
              # 2020-09-12 Cuanto termina recarga el resto de elementos con el valor inicial
              #
              puts "======================================================================"
              puts 'Finalizo... ' + sheet.to_s
              puts "======================================================================"
            end

            if sheet.to_s == 'Cotizacion'
              puts "======================================================================"
              puts 'Inicio... ' + sheet.to_s
              puts "======================================================================"
              hoja = spreadsheet.sheet(sheet)
              fila = 8
              finaliza = 0
              i = 0
              migrep = []
              while finaliza == 0
                if hoja.row(fila)[5].to_s != ""
                  contratoscargo = Contratoscargo.new(contrato_id: contratoid,
                                                      disponibilidad: hoja.row(fila)[5].to_s,
                                                      perfil: hoja.row(fila)[2].to_s,
                                                      cantidad: hoja.row(fila)[6].to_s,
                                                      salario: hoja.row(fila)[11].to_s,
                                                      dias_trabajo: hoja.row(fila)[8].to_s + ' MESES')
                  migrep << contratoscargo
                  fila = fila + 1
                else
                  finaliza = 1
                end
              end
              imported_obj = Contratoscargo.import migrep, recursive: true, validate: false
              puts "======================================================================"
              puts 'Finalizo... ' + sheet.to_s
              puts "======================================================================"
            end

          end
        end
      end
      flash[:notice] = 'Archivo cargado con exito....'
      redirect_to validacion_contratos_path(id: contratoid)
    else
      flash[:alert] = 'Error: Archivo Invalido'
      # respond_to { |format| format.js }
      redirect_to root_path
    end
  end

  def cargar_pruebafinal
    archivo = params[:file]
    contratoid = params[:contratoid]
    if archivo
      name = archivo.original_filename
      directory = "public/archivos/"
      path = File.join(directory, name)
      extensionarchivo = name.slice(name.rindex("."), name.length).downcase
      if extensionarchivo == ".xlsx" or extensionarchivo == ".xls"
        File.open(path, "wb") { |f| f.write(archivo.read) }
        spreadsheet = Roo::Spreadsheet.open(path, extension: extensionarchivo)
        spreadsheet.sheets.each do |sheet|
          puts 'Hojas... ' + sheet.to_s
        end

        spreadsheet.sheets.each do |sheet|

          # ----------
          # ----------
          # ----------

          if ['Solicitud de Cotización General', 'Detalle Bienes de Aseo y Caf', 'Detalle Especificaciones', 'Resumen - CSV', 'Cotizacion Bienes de Aseo y Ca', 'Cotizacion'].include?(sheet)
            if sheet.to_s == 'Detalle Especificaciones'
              puts "======================================================================"
              puts 'Inicio... ' + sheet.to_s
              puts "======================================================================"
              hoja = spreadsheet.sheet(sheet)
              cant = 0
              i = 0
              while cant <= 20
                if hoja.row(2)[i].to_s != ""
                  puts "--------------------------------------------------------"
                  puts hoja.row(2)[i].to_s
                  puts "--------------------------------------------------------"
                  namsede = hoja.row(2)[i].to_s
                  namsede = namsede.gsub("Especificaciones del servicio - ", "")
                  nombresede = hoja.row(7)[i + 2].upcase.to_s + ' - ' + namsede.upcase.to_s
                  if Contratossede.where(contrato_id: contratoid, nombre: nombresede).exists? == false
                    Contratossede.create(contrato_id: contratoid, nombre: nombresede,
                                         direccion: hoja.row(8)[i + 2].upcase.to_s,
                                         telefono: hoja.row(8)[i + 7].to_s,
                                         departamento: hoja.row(9)[i + 2].to_s,
                                         municipio: hoja.row(9)[i + 6].to_s)
                    puts hoja.row(7)[i + 2].to_s
                    puts hoja.row(8)[i + 2].to_s
                    puts hoja.row(8)[i + 7].to_s
                    puts hoja.row(9)[i + 2].to_s
                    puts hoja.row(9)[i + 6].to_s
                    puts "Creados...."
                  else
                    puts "Ya esta creado...."
                  end
                end
                if i == 0
                  i = i + 10
                else
                  i = i + 9
                end
                cant = cant + 1
              end
              puts "======================================================================"
              puts 'Finalizo... ' + sheet.to_s
              puts "======================================================================"
            end

            # ----------
            # ----------
            # ----------

            if sheet.to_s == 'Solicitud de Cotización General'
              puts "======================================================================"
              puts 'Inicio... ' + sheet.to_s
              puts "======================================================================"
              hoja = spreadsheet.sheet(sheet)
              cant = 0
              i = 0
              fila = 17
              while cant <= 5
                # puts "Fila " + fila.to_s + " --  Columnna " +  i.to_s
                if ['Tiempo completo', 'Medio Tiempo', 'Personal por Turnos', 'Disminución del personal'].include?(hoja.row(fila)[i].to_s)
                  puts 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
                  puts "Solicitud inicio... fila " + fila.to_s + ' -- ' + hoja.row(fila)[i].to_s
                  puts 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
                  disponibilidad = hoja.row(fila)[i].upcase.to_s
                  puts disponibilidad
                  finaliza = 0
                  fila = fila + 1
                  while finaliza == 0
                    if ['1. Si requiere agregue o elimine filas de Personal TC', '1. Si requiere agregue o elimine filas de Personal MT', '1. Si requiere agregue o elimine filas de Personal Turno', 'Total N° de operarios requeridos:'].include?(hoja.row(fila)[0].to_s)
                      finaliza = 1
                      fila = fila + 1
                      i = 0
                    else
                      puts "---------> Cargo....." + hoja.row(fila)[0].to_s
                      if hoja.row(fila)[0].to_s != ""
                        if Contratoscargo.where(contrato_id: contratoid, disponibilidad: disponibilidad).exists? == false
                          puts "---------> Datos personal <---------"
                          i = 0
                          puts hoja.row(fila)[i].to_s
                          puts hoja.row(fila)[i + 2].to_s
                          puts hoja.row(fila)[i + 3].to_s
                          puts hoja.row(fila)[i + 4].to_s
                          puts hoja.row(fila)[i + 5].to_s
                          a = 9
                          Contratoscargo.create(contrato_id: contratoid,
                                                disponibilidad: disponibilidad,
                                                perfil: hoja.row(fila)[0].to_s,
                                                cantidad: hoja.row(fila)[i + 2].to_s,
                                                dias_trabajo: hoja.row(fila)[i + 3].to_s,
                                                horario: hoja.row(fila)[i + 4].to_s,
                                                observaciones: hoja.row(fila)[i + 5].to_s,
                                                sede1: hoja.row(fila)[a].to_s,
                                                sede2: hoja.row(fila)[a + 1].to_s,
                                                sede3: hoja.row(fila)[a + 2].to_s,
                                                sede4: hoja.row(fila)[a + 3].to_s,
                                                sede5: hoja.row(fila)[a + 4].to_s,
                                                sede6: hoja.row(fila)[a + 5].to_s,
                                                sede7: hoja.row(fila)[a + 6].to_s,
                                                sede8: hoja.row(fila)[a + 7].to_s,
                                                sede9: hoja.row(fila)[a + 8].to_s,
                                                sede10: hoja.row(fila)[a + 9].to_s,
                                                sede11: hoja.row(fila)[a + 10].to_s,
                                                sede12: hoja.row(fila)[a + 11].to_s,
                                                sede13: hoja.row(fila)[a + 12].to_s,
                                                sede14: hoja.row(fila)[a + 13].to_s,
                                                sede15: hoja.row(fila)[a + 14].to_s,
                                                sede16: hoja.row(fila)[a + 15].to_s,
                                                sede17: hoja.row(fila)[a + 16].to_s,
                                                sede18: hoja.row(fila)[a + 17].to_s,
                                                sede19: hoja.row(fila)[a + 18].to_s,
                                                sede20: hoja.row(fila)[a + 19].to_s,
                                                sede21: hoja.row(fila)[a + 20].to_s,
                                                sede22: hoja.row(fila)[a + 21].to_s,
                                                sede23: hoja.row(fila)[a + 22].to_s,
                                                sede24: hoja.row(fila)[a + 23].to_s,
                                                sede25: hoja.row(fila)[a + 24].to_s,
                                                sede26: hoja.row(fila)[a + 25].to_s,
                                                sede27: hoja.row(fila)[a + 26].to_s,
                                                sede28: hoja.row(fila)[a + 27].to_s,
                                                sede29: hoja.row(fila)[a + 28].to_s,
                                                sede30: hoja.row(fila)[a + 29].to_s,
                                                sede31: hoja.row(fila)[a + 30].to_s,
                                                sede32: hoja.row(fila)[a + 31].to_s,
                                                sede33: hoja.row(fila)[a + 32].to_s,
                                                sede34: hoja.row(fila)[a + 33].to_s,
                                                sede35: hoja.row(fila)[a + 34].to_s,
                                                sede36: hoja.row(fila)[a + 35].to_s,
                                                sede37: hoja.row(fila)[a + 36].to_s,
                                                sede38: hoja.row(fila)[a + 37].to_s,
                                                sede39: hoja.row(fila)[a + 38].to_s,
                                                sede40: hoja.row(fila)[a + 39].to_s)
                          # i = 9
                          # while i <= 34
                          #  puts "---------> SEDE #{i-8}<----- " + hoja.row(fila)[i].to_s
                          #  i = i + 1
                          # end
                          puts "-------------"
                        else
                          puts "Ya creado..."
                        end
                      end
                      fila = fila + 1
                    end
                  end
                  cant = cant + 1
                end
                fila = fila + 1
                i = 0
                cant = cant + 1
                # puts 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
                # puts "Solicitud fin... " + hoja.row(fila)[i].to_s
                # puts 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
              end
              puts "======================================================================"
              puts 'Finalizo... ' + sheet.to_s
              puts "======================================================================"
            end

            # ----------
            # ----------
            # ----------

            if sheet.to_s == 'Cotizacion Bienes de Aseo y Ca'
              puts "======================================================================"
              puts 'Inicio... ' + sheet.to_s
              puts "======================================================================"
              hoja = spreadsheet.sheet(sheet)
              cant = 0
              i = 0
              fila = 13
              finaliza = 0
              while finaliza == 0
                if hoja.row(fila)[0].to_s != "" and hoja.row(fila)[0].to_i > 0
                  if Insumo.exists?(id: hoja.row(fila)[i]) == true
                    if Contratosinsumo.exists?(contrato_id: contratoid, insumo_id: hoja.row(fila)[0].to_i) == false
                      puts "---------> Datos insumo <---------" + hoja.row(fila)[i].to_s
                      i = 0
                      # puts hoja.row(fila)[i].to_s
                      # puts hoja.row(fila)[i+1].to_s
                      # puts hoja.row(fila)[i+2].to_s
                      # puts 'a..'+hoja.row(fila)[i+3].to_s
                      # puts 'b..'+hoja.row(fila)[i+4].to_s
                      # puts 'c..'+hoja.row(fila)[i+5].to_s
                      # puts 'd..'+hoja.row(fila)[i+6].to_s
                      # puts 'e..'+hoja.row(fila)[i+7].to_s
                      # puts 'e..'+hoja.row(fila)[i+8].to_s
                      if hoja.row(fila)[5].to_f > 0
                        preciounitario = hoja.row(fila)[5].to_f
                      else
                        preciounitario = Insumo.find(hoja.row(fila)[0].to_i).valor1.to_f
                      end
                      a = 10
                      Contratosinsumo.create(contrato_id: contratoid,
                                             insumo_id: hoja.row(fila)[0].to_i,
                                             cantidad_mensual: hoja.row(fila)[4].to_s,
                                             precio_unitario: preciounitario,
                                             descuento: hoja.row(fila)[6].to_f * 100,
                                             precio_condescuento: hoja.row(fila)[7].to_f,
                                             total: hoja.row(fila)[8].to_f,

                                             cantsede_1: hoja.row(fila)[a].to_f,
                                             cantsede_2: hoja.row(fila)[a + 1].to_f,
                                             cantsede_3: hoja.row(fila)[a + 2].to_f,
                                             cantsede_4: hoja.row(fila)[a + 3].to_f,
                                             cantsede_5: hoja.row(fila)[a + 4].to_f,
                                             cantsede_6: hoja.row(fila)[a + 5].to_f,
                                             cantsede_7: hoja.row(fila)[a + 6].to_f,
                                             cantsede_8: hoja.row(fila)[a + 7].to_f,
                                             cantsede_9: hoja.row(fila)[a + 8].to_f,
                                             cantsede_10: hoja.row(fila)[a + 9].to_f,
                                             cantsede_11: hoja.row(fila)[a + 10].to_f,
                                             cantsede_12: hoja.row(fila)[a + 11].to_f,
                                             cantsede_13: hoja.row(fila)[a + 12].to_f,
                                             cantsede_14: hoja.row(fila)[a + 13].to_f,
                                             cantsede_15: hoja.row(fila)[a + 14].to_f,
                                             cantsede_16: hoja.row(fila)[a + 15].to_f,
                                             cantsede_17: hoja.row(fila)[a + 16].to_f,
                                             cantsede_18: hoja.row(fila)[a + 17].to_f,
                                             cantsede_19: hoja.row(fila)[a + 18].to_f,
                                             cantsede_20: hoja.row(fila)[a + 19].to_f,
                                             cantsede_21: hoja.row(fila)[a + 20].to_f,
                                             cantsede_22: hoja.row(fila)[a + 21].to_f,
                                             cantsede_23: hoja.row(fila)[a + 22].to_f,
                                             cantsede_24: hoja.row(fila)[a + 23].to_f,
                                             cantsede_25: hoja.row(fila)[a + 24].to_f,
                                             cantsede_26: hoja.row(fila)[a + 25].to_f,
                                             cantsede_27: hoja.row(fila)[a + 26].to_f,
                                             cantsede_28: hoja.row(fila)[a + 27].to_f,
                                             cantsede_29: hoja.row(fila)[a + 28].to_f,
                                             cantsede_30: hoja.row(fila)[a + 29].to_f,
                                             cantsede_31: hoja.row(fila)[a + 30].to_f,
                                             cantsede_32: hoja.row(fila)[a + 31].to_f,
                                             cantsede_33: hoja.row(fila)[a + 32].to_f,
                                             cantsede_34: hoja.row(fila)[a + 33].to_f,
                                             cantsede_35: hoja.row(fila)[a + 34].to_f,
                                             cantsede_36: hoja.row(fila)[a + 35].to_f,
                                             cantsede_37: hoja.row(fila)[a + 36].to_f,
                                             cantsede_38: hoja.row(fila)[a + 37].to_f,
                                             cantsede_39: hoja.row(fila)[a + 38].to_f,
                                             cantsede_40: hoja.row(fila)[a + 39].to_f)
                    end
                  end
                end
                fila = fila + 1
                if hoja.row(fila)[0].to_s == 'TOTAL Mensual Bienes de Aseo y Cafetería'
                  finaliza = 1
                end
              end
              puts "======================================================================"
              puts 'Finalizo... ' + sheet.to_s
              puts "======================================================================"
            end

            if sheet.to_s == 'Cotizacion'
              puts "======================================================================"
              puts 'Inicio... ' + sheet.to_s
              puts "======================================================================"
              hoja = spreadsheet.sheet(sheet)

              puts " inicioooo"
              # puts hoja

              puts hoja.row(1)[1].to_s rescue nil
              fila = 8
              finaliza = 0
              # while finaliza == 0
              # if  hoja.row(fila)[1].to_s != ""
              i = 0
              puts hoja.row(fila)[i].to_s rescue nil
              puts hoja.row(fila)[i + 1].to_s rescue nil
              puts hoja.row(fila)[i + 2].to_s rescue nil
              puts hoja.row(fila)[i + 3].to_s rescue nil
              puts hoja.row(fila)[i + 4].to_s rescue nil
              puts hoja.row(fila)[i + 5].to_s rescue nil
              puts hoja.row(fila)[i + 6].to_s rescue nil
              puts hoja.row(fila)[i + 7].to_s rescue nil
              puts hoja.row(fila)[i + 8].to_s rescue nil
              puts hoja.row(fila)[i + 9].to_s rescue nil
              puts hoja.row(fila)[i + 10].to_s rescue nil
              puts hoja.row(fila)[i + 11].to_s rescue nil
              puts hoja.row(fila)[i + 12].to_s rescue nil
              puts hoja.row(fila)[i + 13].to_s rescue nil
              puts hoja.row(fila)[i + 14].to_s rescue nil
              # else 307-70-32 018000122532
              finaliza = 1
              # end
              # end
              puts "======================================================================"
              puts 'Finalizo... ' + sheet.to_s
              puts "======================================================================"
            end

          end
        end

=begin
          identifi = spreadsheet.row(7)[3].to_s.gsub('.0','')
          id = Persona.where(["identificacion = '#{identifi.to_s}'"]).first.id rescue nil
          if id
            v = Personassegsocial.new
            v.fecha = spreadsheet.row(3)[4].to_s.gsub('.0','') + '-' + spreadsheet.row(3)[5].to_s.gsub('.0','') + '-' + spreadsheet.row(3)[6].to_s.gsub('.0','')
            v.hora = spreadsheet.row(3)[8].to_s.gsub('.0','')
            v.profesional = spreadsheet.row(4)[4].to_s.upcase
            v.becario = spreadsheet.row(5)[2].to_s.upcase
            if spreadsheet.row(6)[5].to_s != ""
              v.tipodocumento = "TI"
            elsif spreadsheet.row(6)[8].to_s != ""
              v.tipodocumento = "CC"
            end
            v.identificacion = spreadsheet.row(7)[3].to_s.gsub('.0','')
            v.ies = spreadsheet.row(8)[2].to_s.upcase
            v.municipio = spreadsheet.row(8)[5].to_s.upcase
            v.programa = spreadsheet.row(9)[3].to_s.upcase
            v.semestre = spreadsheet.row(10)[3].to_s.upcase
            v.institucion_social = spreadsheet.row(10)[7].to_s.upcase
            if spreadsheet.row(12)[8].to_s != ""
              v.duracion =  "ESCASA"
            elsif spreadsheet.row(13)[8].to_s != ""
              v.duracion =  "SUFICIENTE"
            elsif spreadsheet.row(14)[8].to_s != ""
              v.duracion =  "EXCESIVA"
            end
            if spreadsheet.row(15)[8].to_s != ""
              v.tiempo =  "MAYOR A 50 HORAS"
            elsif spreadsheet.row(16)[8].to_s != ""
              v.tiempo =  "50 HORAS"
            elsif spreadsheet.row(17)[8].to_s != ""
              v.tiempo =  "MENOS DE 50 HORAS"
            elsif spreadsheet.row(18)[8].to_s != ""
              v.tiempo = spreadsheet.row(18)[8].to_s
            end
            if spreadsheet.row(19)[8].to_s != ""
              v.problema =  "SI"
            elsif spreadsheet.row(20)[8].to_s != ""
              v.problema =  "NO"
            end
            if spreadsheet.row(21)[8].to_s != ""
              v.relacion =  "MALA"
            elsif spreadsheet.row(22)[8].to_s != ""
              v.relacion =  "ACEPTABLE"
            elsif spreadsheet.row(23)[8].to_s != ""
              v.relacion =  "BUENA"
            end
            if spreadsheet.row(24)[8].to_s != ""
              v.atencion =  "MALA"
            elsif spreadsheet.row(25)[8].to_s != ""
              v.atencion =  "ACEPTABLE"
            elsif spreadsheet.row(26)[8].to_s != ""
              v.atencion =  "BUENA"
            end
            if spreadsheet.row(27)[8].to_s != ""
              v.actividades =  "POCO RELACIONADAS CON LOS ESTUDIOS"
            elsif spreadsheet.row(28)[8].to_s != ""
              v.actividades =  "RELACIONADAS CON LOS ESTUDIOS"
            elsif spreadsheet.row(29)[8].to_s != ""
              v.actividades =  "MUY RELACIONADAS CON LOS ESTUDIOS"
            end
            if spreadsheet.row(30)[8].to_s != ""
              v.formacion =  "POCO PROVECHOSA"
            elsif spreadsheet.row(31)[8].to_s != ""
              v.formacion =  "PROVECHOSA"
            elsif spreadsheet.row(32)[8].to_s != ""
              v.formacion =  "MUY PROVECHOSA"
            end
            if spreadsheet.row(33)[8].to_s != ""
              v.satisfaccion =  "POCO SATISFECHO"
            elsif spreadsheet.row(34)[8].to_s != ""
              v.satisfaccion =  "SATISFECHO"
            elsif spreadsheet.row(35)[8].to_s != ""
              v.satisfaccion =  "MUY SATISFECHO"
            end
            if spreadsheet.row(36)[8].to_s != ""
              v.acceso =  "INTERNET"
            elsif spreadsheet.row(37)[8].to_s != ""
              v.acceso =  "ANUNCIOS DE LA FACULTAD"
            elsif spreadsheet.row(38)[8].to_s != ""
              v.acceso =  "POR OTROS COMPAÑEROS"
            elsif spreadsheet.row(39)[8].to_s != ""
              v.acceso =  "LA CORPORACION"
            elsif spreadsheet.row(40)[8].to_s != ""
              v.acceso =  "USTED MISMO"
            end
            if spreadsheet.row(41)[8].to_s != ""
              v.informacion =  "MALA"
            elsif spreadsheet.row(42)[8].to_s != ""
              v.informacion =  "ACEPTABLE"
            elsif spreadsheet.row(43)[8].to_s != ""
              v.informacion =  "BUENA"
            end
            v.persona_id = id
            v.user_id = is_admin
            v.save
            flash[:notice] = "Atencion: El archivo para la identificacion #{identifi} ha sido cargado con exito."
            #respond_to { |format| format.js }
            redirect_to validacion_personassegsociales_path
          else
            flash[:alert] = "Error: La identificacion #{identifi} no se encuentra registrada en Mentes"
            #respond_to { |format| format.js }
            redirect_to validacion_personassegsociales_path
          end
        else
          flash[:alert] = 'Error: El archivo no tiene la Extensión .XLS o .XLSX, verifique'
          #respond_to { |format| format.js }
          redirect_to validacion_personassegsociales_path
        end
=end
      end
      redirect_to validacion_contratos_path(id: contratoid)
    else
      flash[:alert] = 'Error: Archivo Invalido'
      # respond_to { |format| format.js }
      redirect_to root_path
    end
  end

  def searchall
    palabra = "%#{replacespace(params[:q])}%"
    @contratos = Contrato.joins("left outer join empresas on contratos.empresa_id = empresas.id")
                         .where("contratos.estado = 'EN EJECUCION' and contratos.nro_contrato LIKE ? or empresas.nombre LIKE ? and contratos.id in (select contrato_id from contratosgrupos)", palabra, palabra).limit(10)
    respond_to do |format|
      format.json { render json: @contratos.map { |p| { id: p.id, name: "#{p.nombrecontrato}" } } }
    end
  end

  def search
    palabra = "%#{replacespace(params[:q])}%"
    @contratos = Contrato.joins("left outer join empresas on contratos.empresa_id = empresas.id")
                         .where("(contratos.estado = 'EN EJECUCION' and contratos.nro_contrato LIKE ? or empresas.nombre LIKE ?) and contratos.id in (select contrato_id from contratosgrupos where termino = 'QUINCENAL')", palabra, palabra).limit(10)
    respond_to do |format|
      format.json { render json: @contratos.map { |p| { id: p.id, name: "#{p.nombrecontrato}" } } }
    end
  end

  def searchm
    palabra = "%#{replacespace(params[:q])}%"
    @contratos = Contrato.joins("left outer join empresas on contratos.empresa_id = empresas.id")
                         .where("(contratos.estado = 'EN EJECUCION' and contratos.nro_contrato LIKE ? or empresas.nombre LIKE ?) and contratos.id in (select contrato_id from contratosgrupos where termino = 'MENSUAL')", palabra, palabra).limit(10)
    respond_to do |format|
      format.json { render json: @contratos.map { |p| { id: p.id, name: "#{p.nombrecontrato}" } } }
    end
  end

  def depurarinsumos
    @contrato = Contrato.find(params[:id])
    if Contratossolicitud.where(contrato_id: @contrato.id).exists? == false
      Contratosinsumo.where(contrato_id: @contrato.id).delete_all
      Contratosmaquinaria.where(contrato_id: @contrato.id).delete_all
      flash['danger'] = "Depuracion realizada"
    end
    redirect_to edit_contrato_path(id: @contrato.id, etapa: 'F')
  end

  def descargarepp
    @contrato = Contrato.find(params[:contrato_id])
    @empresa = @contrato.empresa
    respond_to do |format|
      format.pdf { render pdf: "SolicitudesEpps_#{Time.now.strftime("%Y%m%d")}", template: "contratos/descargarepp.html.erb", encoding: "UTF-8", page_size: 'Letter' }
    end
  end

  def descargacontrato
    @contrato = Contrato.find(params[:contrato_id])
    fch = params[:fch].to_s rescue nil
    if fch.to_s == ""
      fch = '-1'
    end
    if params[:clase].to_s == 'DOCUMENTOS'
      Ejecucion.create(user_id: is_admin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO SMS',
                       controlador_metodo: "DatasController.descargardocbycontrato(#{@contrato.id},#{is_admin},'#{fch}')", created_at: Time.now)
      flash['notice'] = "Proceso para descargar informacion iniciado"
    elsif params[:clase].to_s == 'CONTRATOS'
      Ejecucion.create(user_id: is_admin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO SMS',
                       controlador_metodo: "DatasController.predownload(#{@contrato.id},#{is_admin},'#{fch}')", created_at: Time.now)
      flash['notice'] = "Proceso para descargar contratos iniciado"
    elsif params[:clase].to_s == 'AFILIACIONES'
      Ejecucion.create(user_id: is_admin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO SMS',
                       controlador_metodo: "DatasController.descargardocbycontratoafiliaciones(#{@contrato.id},#{is_admin},'#{fch}')", created_at: Time.now)
      flash['notice'] = "Proceso para descargar contratos iniciado"
    elsif params[:clase].to_s == 'REFIRMAR'
      Ejecucion.create(user_id: is_admin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO SMS',
                       controlador_metodo: "DatasController.refirmarcontrato(#{@contrato.id},#{is_admin})", created_at: Time.now)
      flash['notice'] = "Proceso para Refirmar contratos iniciado"
    elsif params[:clase].to_s == 'DOTACION'
      Ejecucion.create(user_id: is_admin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO SMS',
                       controlador_metodo: "ContratosperfechasController.dotacion(#{@contrato.id},#{is_admin},'#{fch}')", created_at: Time.now)
      flash['notice'] = "Proceso para generar dotacion iniciado"
    elsif params[:clase].to_s == 'DOTACIONP'
      Ejecucion.create(user_id: is_admin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO SMS',
                       controlador_metodo: "ContratosperdotacionesController.carta_dotacion(#{@contrato.id},#{is_admin},'#{fch}')", created_at: Time.now)
      flash['notice'] = "Proceso para generar dotacion periodica iniciado"
    elsif params[:clase].to_s == 'DOTACIONPE'
      Ejecucion.create(user_id: is_admin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO SMS',
                       controlador_metodo: "ContratosperdotacionesController.carta_dotacione(#{@contrato.id},#{is_admin},'#{fch}')", created_at: Time.now)
      flash['notice'] = "Proceso para generar dotacion periodica sin cantidades iniciado"
    elsif params[:clase].to_s == 'CARTASTERMINACION'
      Ejecucion.create(user_id: is_admin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO SMS',
                       controlador_metodo: "DatasController.descargarcartabycontrato(#{@contrato.id},#{is_admin})", created_at: Time.now)
      flash['notice'] = "Proceso para descargar informacion iniciado"
    elsif params[:clase].to_s == 'PERIODICA'
      Ejecucion.create(user_id: is_admin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO SMS',
                       controlador_metodo: "ContratosperdotacionesController.carta_dotacion(#{@contrato.id},#{is_admin},'#{fch}')", created_at: Time.now)
      flash['notice'] = "Proceso para generar dotacion iniciado"
    elsif params[:clase].to_s == 'INDUCCION'
      Ejecucion.create(user_id: is_admin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO SMS',
                       controlador_metodo: "ContratosperfechasController.inducciongeneral(#{@contrato.id},#{is_admin},'#{fch}')", created_at: Time.now)
      flash['notice'] = "Proceso para generar Inducción iniciado"
    elsif params[:clase].to_s == 'CARTA'
      Ejecucion.create(user_id: is_admin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO SMS',
                       controlador_metodo: "ContratosperfechasController.cartam_contrato(#{@contrato.id},#{is_admin},'#{fch}')", created_at: Time.now)
      flash['notice'] = "Proceso para generar Carta Laboral iniciado"
    end
    redirect_to edit_contrato_path(id: @contrato.id, etapa: 'A')
  end

  def descargacontratoesp
    @contrato = Contrato.find(params[:contrato_id])
    fch = params[:fch].to_s rescue nil
    if fch.to_s == ""
      fch = '-1'
    end
    if params[:clase].to_s == 'DOTACION'
      Ejecucion.create(user_id: is_admin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO SMS',
                       controlador_metodo: "ContratosperfechasController.dotacion(#{@contrato.id},#{is_admin},'#{fch}')", created_at: Time.now)
      flash['notice'] = "Proceso para generar dotacion iniciado"
    elsif params[:clase].to_s == 'DOTACIONP'
      Ejecucion.create(user_id: is_admin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO SMS',
                       controlador_metodo: "ContratosperdotacionesController.carta_dotacion(#{@contrato.id},#{is_admin},'#{fch}')", created_at: Time.now)
      flash['notice'] = "Proceso para generar dotacion periodica iniciado"
    end
    redirect_to root_path
  end
  def cargardocumentos
    idCarpeta = params[:idcarpeta].to_s
    Ejecucion.create(user_id: is_admin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO SMS',
                     controlador_metodo: "DatasController.cargardigitales(#{idCarpeta},#{is_admin})", created_at: Time.now)
    flash['notice'] = "Proceso para cargar documentos de la HV iniciado"
    redirect_to root_path
  end

  private

  def set_layout
    if ['index', 'new', 'show_detalle'].include?(action_name)
      'application_admin'
    elsif ['edit'].include?(action_name)
      'application_contratos'
    elsif ['validacion'].include?(action_name)
      "inscripcion_layout"
    elsif ['capacitacionesusuario'].include?(action_name)
      'inscripcion_layoutmetro'
    else
      "application_admin"
    end
  end

  def set_contrato
    if params[:etapa].to_s != ""
      Contrato.find(params[:id]).update_columns(etapa: params[:etapa].to_s)
      # ActiveRecord::Base.connection.execute("update contratos set etapa = '#{params[:etapa]}' where id = #{params[:id]}")
      @etapa = params[:etapa].to_s
      if ["F", "M", "S", "P1"].include?(params[:etapa].to_s)
        @insumoId = params[:ubicacion][:insumo_id].to_s rescue nil
      end
      if params[:etapa].to_s == "P1" or params[:etapa].to_s == "PR"
        if params[:subetapa].to_s == "" and params[:etapa].to_s == "P1"
          @subetapa = 8
        elsif params[:subetapa].to_s == "" and params[:etapa].to_s == "PR"
          @subetapa = 10
        else
          @subetapa = params[:subetapa].to_s
        end
        User.find(is_admin).update_columns(subetapa: @subetapa)
        # ActiveRecord::Base.connection.execute("update users set subetapa = '#{@subetapa}' where id = #{is_admin}")
      end
    end
    @contrato = Contrato.find(params[:id])
  end

  def contrato_params
    params.require(:contrato).permit!
  end
end

