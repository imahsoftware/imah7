class ContratospermasivasController < ApplicationController
  before_action :set_contratospermasiva, only: [:show, :edit, :update, :destroy]

  def get_contratospermasiva_contrato_id
    @contrato = params[:ubicacion_contrato_id]
    @contratosgrupos = Contratosgrupo.where(contrato_id: @contrato) if @contrato
    @contratoscargos = Contratoscargo.where(contrato_id: @contrato) if @contrato
    respond_to { |format| format.js }
  end

  def masiva
    contrato = params[:ubicacion][:contrato_id].to_s rescue ""
    contratosgrupo = params[:contratospermasiva][:contratosgrupo_id].to_s rescue ""
    fecha = params[:contratospermasiva][:fecha].to_s rescue ""
    obser = params[:contratospermasiva][:observacion].to_s rescue ""
    if contrato == "" or contratosgrupo == "" or fecha == "" or obser == ""
      flash[:warning] = "No hay resultados de la consulta!!!"
      redirect_to contratospernominas_path
    else
      if Contratosperfecha.where("contrato_id= #{contrato} and contratosgrupo_id = #{contratosgrupo} and (fecha_fin is null or fecha_fin >= '#{fecha.to_date}')").exists?
        c = Contratospermasiva.create(contrato_id: contrato, contratosgrupo_id:contratosgrupo ,user_id: is_admin, fecha:fecha.to_date, observacion:obser, estado: 'PENDIENTE', proceso: 'LIQUIDACION')
        #puts "Creado...."+c.id.to_s
        ActiveRecord::Base.connection.execute("CALL prc_liquidacionesmasiva(#{c.id},'A')")
        flash[:success] = "Proceso Masivo Generado con EXITO!!!"
        redirect_to edit_contratospermasiva_path(id: c.id)
      else
        flash[:warning] = "Proceso masivo: No hay datos!!!"
        redirect_to contratospernominas_path
      end
    end
  end

  def masivaesp
    contrato = params[:ubicacion][:contrato_id].to_s rescue ""
    contratosgrupo = params[:contratospermasiva][:contratosgrupo_id].to_s rescue ""
    if contratosgrupo == 'Seleccione'
      contratosgrupo = ""
    end
    contratoscargo = params[:contratospermasiva][:contratoscargo_id].to_s rescue ""
    fecha = params[:contratospermasiva][:fecha].to_s rescue ""
    fecha_fin = params[:contratospermasiva][:fecha_fin].to_s rescue ""
    obser = params[:contratospermasiva][:observacion].to_s rescue ""
    if contrato == "" or contratosgrupo == "" or fecha == "" or fecha_fin == "" or obser == ""
      flash[:warning] = "No hay resultados de la consulta!!!, debe registrar todos los campos....."
      redirect_to contratospernominas_path
    else
      if Contratosperfecha.where("contrato_id= #{contrato} and contratosgrupo_id = #{contratosgrupo} and fecha_fin between '#{fecha.to_date}' and '#{fecha_fin.to_date}'").exists?
        c = Contratospermasiva.create(contrato_id: contrato, contratosgrupo_id:contratosgrupo, contratoscargo_id: contratoscargo,
                                      user_id: is_admin, fecha:fecha.to_date, fecha_inicio: fecha.to_date, fecha_fin:fecha_fin.to_date,
                                      observacion:obser, estado: 'PENDIENTE', proceso: 'LIQUIDACION')
        ActiveRecord::Base.connection.execute("CALL prc_liquidacionesmasiva(#{c.id},'A1')")
        flash[:success] = "Proceso Masivo Generado con EXITO!!!"
        redirect_to edit_contratospermasiva_path(id: c.id)
      else
        flash[:warning] = "Proceso masivo: No hay datos!!!"
        redirect_to contratospernominas_path
      end
    end
  end

  def masivaproceso
    contrato = params[:ubicacion][:contrato_id].to_s rescue ""
    contratosgrupo = params[:contratospermasiva][:contratosgrupo_id].to_s rescue ""
    fecha = params[:contratospermasiva][:fecha].to_s rescue ""
    fechainicio = params[:contratospermasiva][:fecha_inicio].to_s rescue ""
    fechafin = params[:contratospermasiva][:fecha_fin].to_s rescue ""
    proceso = params[:contratospermasiva][:proceso].to_s rescue ""
    obser = params[:contratospermasiva][:observacion].to_s rescue ""
    masivo = params[:contratospermasiva][:masivo].to_s rescue ""
    if masivo.to_s == 'SI' and fechainicio != "" and fechafin != "" and proceso != ""
      Ejecucion.create(user_id: is_admin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO SMS',
                       controlador_metodo: "ContratospermasivasController.masivaprocesos(#{is_admin},'#{proceso.to_s}','#{fechainicio.to_date}','#{fechafin.to_date}')", created_at: Time.now)
      flash[:success] = "Proceso Masivo se inicia es este momento...!!!"
      redirect_to contratospernominas_path
    else  
      if fechainicio == "" or fechafin == "" or proceso == "" or fecha == ""
        flash[:warning] = "No hay resultados de la consulta!!!"
        redirect_to contratospernominas_path
      else
        c = Contratospermasiva.create(contrato_id: contrato, contratosgrupo_id:contratosgrupo ,user_id: is_admin, fecha:fecha.to_date, observacion:obser, estado: 'PENDIENTE', proceso: proceso, fecha_inicio: fechainicio, fecha_fin: fechafin)
        ActiveRecord::Base.connection.execute("CALL prc_liquidacionesmasiva(#{c.id},'C')")
        flash[:success] = "Proceso Masivo Generado con EXITO!!!"
        redirect_to contratospernominas_path
      end
    end
  end

  def self.masivaprocesos(isAdmin,proceso,fchinicio,fchfin)
    user = User.find(isAdmin)
    ActiveRecord::Base.connection.execute("CALL prc_generacion_mas('#{proceso.to_s}','G','#{fchinicio.to_date}','#{fchfin.to_date}')")
    mensaje = "ASEAR: Estimad@ #{user.nombre.capitalize rescue nil}, proceso masivo especial finalizado con exito".html_safe
    Asearsms::SendsmsServices.new.send_sms_procesos(user.celular.to_s, mensaje)
  end

  def archivoplanoproceso
    idpermasiva = params[:contratospermasiva_id].to_s rescue ""
    contratogrupo = params[:contratosgrupo_id].to_s rescue ""
    entidad = params[:entidad].to_s rescue ""
    tipocuenta = params[:tipocuenta].to_s rescue ""
    nombegrupo = Contratosgrupo.find(contratogrupo).descripcion.gsub(" ","_").to_s rescue nil
    if contratogrupo.to_s != ""
      if entidad.to_s == "BANCOLOMBIA"
        objetos = Objeto.find_by_sql([" SELECT CONCAT('18110442538ASEAR S.A. E.S.P225',RPAD(SUBSTR(c.id,1,10),10,' ')
                                               ,DATE_FORMAT(CURDATE(),'%%y%%m%%d'),'A',DATE_FORMAT(CURDATE(),'%%y%%m%%d'),
                                               LPAD(COUNT(9),6,'0'),LPAD(SUM(ROUND(n.prima)),24,'0'),'61335009703D') dato
                                        FROM   contratospermasivas c, contratospermasdetalles n, contratosperfechas f, contratospersonas p
                                        WHERE  c.id = #{idpermasiva}
                                        AND    c.id = n.contratospermasiva_id
                                        AND    n.contratosperfecha_id = f.id
                                        AND    f.contratospersona_id = p.id
                                        AND    p.banco = '#{entidad}'
                                        UNION ALL
                                        SELECT CONCAT(6,LPAD(p.identificacion,15,'0'),RPAD(SUBSTR(nombre_completo,1,18),18,' '),'005600078',LPAD(p.cuenta_bancolombia,17,'0'),
                                               'S37',LPAD(ROUND(n.prima),10,'0'))
                                        FROM   contratospermasivas c, contratospermasdetalles n, contratosperfechas f, contratospersonas p
                                        WHERE  c.id = #{idpermasiva}
                                        AND    c.id = n.contratospermasiva_id
                                        AND    n.contratosperfecha_id = f.id
                                        AND    f.contratospersona_id = p.id
                                        AND    p.banco = '#{entidad}'"])
        rutaupload = "#{::Rails.root}/public/#{entidad}_#{nombegrupo.to_s}_#{Time.now.strftime("%Y%m%d")}.txt"
        File.delete(rutaupload) rescue nil
        File.open(rutaupload, "w") do |the_file|
          objetos.each do |dat|
            the_file.write dat.dato.to_s + "\r\n"
          end
          the_file.close
        end
        send_file rutaupload, type: "text/plain", x_sendfile: true
      elsif entidad.to_s == "AVVILLAS"
        objetos = Objeto.find_by_sql([" SELECT CONCAT('01',DATE_FORMAT(CURDATE(),'%%Y%%m%%d%%h%%m%%s'),'088','02',LPAD(' ',170,' ')) dato,
                                                LPAD(CRC32(CONCAT('01',DATE_FORMAT(CURDATE(),'%%Y%%m%%d%%h%%m%%s'),'088','02',LPAD(' ',170,' '))),15,' ') dato2
                                        UNION ALL
                                        SELECT CONCAT('02','000023','06',LPAD('477014427',16,'0'),'052','01',
                                                      LPAD(p.cuenta_bancolombia,16,'0'),
                                                      LPAD(@rownum:=@rownum+1,9,'0'),
                                                      LPAD(ROUND(n.prima),16,'0'),'00',
                                                      LPAD('0',48,'0'),
                                                      RPAD(SUBSTR(nombre_completo,1,30),30,' '),
                                                      LPAD(p.identificacion,11,'0'),
                                                      LPAD('0',26,'0'),
                                                      LPAD('0',2,'0')) dato,
                                               LPAD(CRC32(CONCAT('02','000023','06',LPAD('477014427',16,'0'),'052','01',
                                                                LPAD(p.cuenta_bancolombia,16,'0'),
                                                                LPAD(@rownum:=@rownum+1,9,'0'),
                                                LPAD(ROUND(n.prima),16,'0'),'00',
                                                LPAD('0',48,'0'),
                                                RPAD(SUBSTR(nombre_completo,1,30),30,' '),
                                                LPAD(p.identificacion,11,'0'),
                                                LPAD('0',26,'0'),
                                                LPAD('0',2,'0'))),15,' ') dato2
                                        FROM   (SELECT @rownum:=0) r, contratospermasivas c, contratospermasdetalles n, contratosperfechas f, contratospersonas p
                                        WHERE  c.id = #{idpermasiva}
                                        AND    c.id = n.contratospermasiva_id
                                        AND    n.contratosperfecha_id = f.id
                                        AND    f.contratospersona_id = p.id
                                        AND    p.banco = '#{entidad}'"])
        rutaupload = "#{::Rails.root}/public/#{entidad}_#{nombegrupo.to_s}_#{Time.now.strftime("%Y%m%d")}.txt"
        crc32 = []
        File.delete(rutaupload) rescue nil
        File.open(rutaupload, "w") do |the_file|
          objetos.each do |dat|
            crc32 << dat.dato2
            the_file.write dat.dato.to_s + "\r\n"
          end
          sqlDatos = ""
          sqlDatos << "#{crc32.join("")}"
          datofinal = Objeto.find_by_sql([" SELECT CONCAT('03',
                                                   LPAD(COUNT(9),9,'0'),
                                                   LPAD(SUM(ROUND(n.prima)),18,'0'),'00',LPAD(CRC32('#{sqlDatos}'),15,' '),
                                                   LPAD(' ',145,' ')) dato
                                            FROM   contratospermasivas c, contratospermasdetalles n, contratosperfechas f, contratospersonas p
                                            WHERE  c.id = #{idpermasiva}
                                            AND    c.id = n.contratospermasiva_id
                                            AND    n.contratosperfecha_id = f.id
                                            AND    f.contratospersona_id = p.id
                                            AND    p.banco = '#{entidad}'"])[0].dato.to_s
          the_file.write datofinal.to_s + "\r\n"
          the_file.close
        end
        send_file rutaupload, type: "text/plain", x_sendfile: true
      elsif entidad.to_s == "DAVIVIENDA"
        objetos = Objeto.find_by_sql(["SELECT CONCAT('RC',LPAD('8110442538',16,'0'),'NOMI','NOMI',LPAD('38070107123',16,'0'),
                                                'CA','000051',LPAD(SUM(ROUND(n.prima)),16,'0'),'00',LPAD(COUNT(9),6,'0'),
                                                DATE_FORMAT(CURDATE(),'%%Y%%m%%d%%h%%m%%s'),'00009999',LPAD('0',16,'0'),'01',LPAD('0',56,'0')) dato
                                        FROM   contratospermasivas c, contratospermasdetalles n, contratosperfechas f, contratospersonas p
                                        WHERE  c.id = #{idpermasiva}
                                        AND    c.id = n.contratospermasiva_id
                                        AND    n.contratosperfecha_id = f.id
                                        AND    f.contratospersona_id = p.id
                                        AND    p.tipo_cuenta = '#{tipocuenta}'
                                        AND    p.banco = '#{entidad}'
                                        UNION ALL
                                        SELECT CONCAT('TR',LPAD(p.identificacion,16,'0'),LPAD('0',16,'0'),
                                                LPAD(p.cuenta_bancolombia,16,'0'),(CASE WHEN p.tipo_cuenta = 'DAVIPLATA' THEN 'DP' ELSE 'CA' END),
                                                '000051',LPAD(ROUND(n.prima),16,'0'),'00','000000','02','1','9999',LPAD('0',41,'0'),LPAD('0',40,'0')) dato
                                        FROM   contratospermasivas c, contratospermasdetalles n, contratosperfechas f, contratospersonas p
                                        WHERE  c.id = #{idpermasiva}
                                        AND    c.id = n.contratospermasiva_id
                                        AND    n.contratosperfecha_id = f.id
                                        AND    f.contratospersona_id = p.id
                                        AND    p.tipo_cuenta = '#{tipocuenta}'
                                        AND    p.banco = '#{entidad}'"])
        rutaupload = "#{::Rails.root}/public/#{entidad}_#{nombegrupo.to_s}_#{tipocuenta.to_s}_#{Time.now.strftime("%Y%m%d")}.txt"
        File.delete(rutaupload) rescue nil
        File.open(rutaupload, "w") do |the_file|
          objetos.each do |dat|
            the_file.write dat.dato.to_s + "\r\n"
          end
          the_file.close
        end
        send_file rutaupload, type: "text/plain", x_sendfile: true
      elsif entidad.to_s == "BANCO DE BOGOTA"
        objetos = Objeto.find_by_sql(["SELECT CONCAT('1',DATE_FORMAT(CURDATE(),'%%Y%%m%%d'),'000000000000000000000000','1','000000',LPAD('114239866',11,'0'),RPAD('ASEAR ESP S.A.S',40,' '),
                                                     LPAD('8110442538',11,'0'),'001','0000',DATE_FORMAT(CURDATE(),'%%Y%%m%%d'),'114','N',LPAD(' ',40,' '),LPAD(' ',80,' '),'N',LPAD(' ',8,' ')) dato
                                        UNION ALL
                                        SELECT CONCAT('2C',LPAD(p.identificacion,11,'0'),RPAD(SUBSTR(p.nombre_completo,1,40),40,' '),'02',
                                                RPAD(p.cuenta_bancolombia,17,' '),LPAD(ROUND(n.prima),16,'0'),'00','A','000','001','0000',RPAD('PAGO PROCESO',80,' '),
                                                '0',LPAD(n.id,10,'0'),'N',
                                                LPAD(' ',8,' '),LPAD(' ',16,' '),'  ',LPAD(' ',22,' '),'N',LPAD(' ',8,' ')) dato
                                        FROM   contratospermasivas c, contratospermasdetalles n, contratosperfechas f, contratospersonas p
                                        WHERE  c.id = #{idpermasiva}
                                        AND    c.id = n.contratospermasiva_id
                                        AND    n.contratosperfecha_id = f.id
                                        AND    f.contratospersona_id = p.id
                                        AND    p.banco = '#{entidad}'"])
        rutaupload = "#{::Rails.root}/public/#{entidad}_#{nombegrupo.to_s}_#{Time.now.strftime("%Y%m%d")}.txt"
        File.delete(rutaupload) rescue nil
        File.open(rutaupload, "w") do |the_file|
          objetos.each do |dat|
            the_file.write dat.dato.to_s + "\r\n"
          end
          the_file.close
        end
        send_file rutaupload, type: "text/plain", x_sendfile: true
      end
    else
      redirect_to root_path
    end
  end

  def incluirnomina
    @contratospermasiva = Contratospermasiva.find(params[:id])
    ActiveRecord::Base.connection.execute("CALL prc_liquidacionesmasiva(#{@contratospermasiva.id},'N')")
    flash[:warning] = "Proceso masivo: Listo!!!"
    redirect_to contratospernominas_path
  end

  def generarplanos
    @contratospermasiva = Contratospermasiva.find(params[:id])
    @contratospermasiva.estado = 'ARCHIVOPLANO'
    @contratospermasiva.save
    flash[:warning] = "Proceso masivo: Listo!!!"
    redirect_to contratospernominas_path
  end

  def reversarnomina
    @contratospermasiva = Contratospermasiva.find(params[:id])
    ActiveRecord::Base.connection.execute("CALL prc_liquidacionesmasiva(#{@contratospermasiva.id},'EL')")
    flash[:warning] = "Proceso masivo: Listo!!!"
    redirect_to contratospernominas_path
  end

  def aprobar
    @contratospermasiva = Contratospermasiva.find(params[:id])
    if @contratospermasiva.estado.to_s == 'PENDIENTE'
      ActiveRecord::Base.connection.execute("update contratospermasivas set estado_gen = 'Generando..' where id = #{@contratospermasiva.id}")
      isadmin = is_admin
      Ejecucion.create(user_id: isadmin, estado: 'PENDIENTE', portafolio_id: 1, tipo: 'ENVIO SMS',
                       controlador_metodo: "ContratospermasivasController.procesos(#{isadmin},#{@contratospermasiva.id},'B')", created_at: Time.now)
      #ActiveRecord::Base.connection.execute("CALL prc_liquidacionesmasiva(#{@contratospermasiva.id},'B')")
    end
    flash[:warning] = "El proceso masivo ha sido iniciado, cuando finalice se notificará al Celular!!!"
    redirect_to contratospernominas_path
  end

  def self.procesos(isAdmin,contratospermasivaId,vcClase)
    user = User.find(isAdmin)
    if vcClase == 'B'
      ActiveRecord::Base.connection.execute("CALL prc_liquidacionesmasiva(#{contratospermasivaId},'B')")
      ActiveRecord::Base.connection.execute("update contratospermasivas set estado_gen = null where id = #{contratospermasivaId}")
    end
    mensaje = "ASEAR: Estimad@ #{user.nombre.capitalize rescue nil}, proceso finalizado del Lote Masivo nro. #{contratospermasivaId}".html_safe
    Asearsms::SendsmsServices.new.send_sms_procesos(user.celular.to_s, mensaje)
  end

  def aprobarproceso
    @contratospermasiva = Contratospermasiva.find(params[:id])
    if @contratospermasiva.estado.to_s == 'PENDIENTE'
      ActiveRecord::Base.connection.execute("CALL prc_liquidacionesmasiva(#{@contratospermasiva.id},'D')")
    end
    flash[:warning] = "Proceso masivo: Listo!!!"
    redirect_to contratospernominas_path
  end

  def edit
    respond_to do |format|
      format.html { render :action => "contratospermasiva_form" }
    end
  end

  def destroy
    ActiveRecord::Base.connection.execute("CALL prc_liquidacionesmasiva(#{@contratospermasiva.id},'E')")
    @contratospermasiva.destroy
    flash['success'] = 'Eliminado con Exito'
    redirect_to contratospernominas_path
  end

  private

    def set_contratospermasiva
      @contratospermasiva = Contratospermasiva.find(params[:id])
    end

    def contratospermasiva_params
      params.require(:contratospermasiva).permit!
    end
end
