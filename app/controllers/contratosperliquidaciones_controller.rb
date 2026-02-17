class ContratosperliquidacionesController < ApplicationController
  before_action :set_contratosperliquidacion, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_user!, except: [:liquidacion]

  layout :set_layout

  def cargarimagenes
    isadmin = is_admin
    system("sudo chmod 777 -R /home/nomina/ftp/*") 
    img = Objeto.find_by_sql(["SELECT p.`identificacion`, s.`contratosperfecha_id`, l.id
                              FROM   solicitudesretiros s, contratosperliquidaciones l, contratospersonas p
                              WHERE  s.consecutivo = '#{params[:consecutivo].to_s}'
                              AND    s.`contratosperliquidacion_id` = l.`id`
                              AND    s.`contratospersona_id` = p.`id`"])
    img.each do |g|
      begin
        file = File.open("/home/nomina/ftp/#{g.identificacion.to_s}.pdf", 'rb')
        if file.present?
          contratosperlimagen = Contratosperlimagen.new
          contratosperlimagen.contratosperfecha_id = g.contratosperfecha_id
          contratosperlimagen.user_id = isadmin
          contratosperlimagen.liquidacionesimagen = file
          contratosperlimagen.save
          file.close
          if contratosperlimagen.id.to_i > 0
            File.delete(file)
          end
        else
          file.close
        end
      rescue Exception => ex
        puts "Errror...." + g.identificacion.to_s + ex.message[0..1000].to_s
      end
    end
    flash[:notice] = "Terminamos...."
    redirect_to contratospernominas_path
  end

  def novedad
    @contratosperliquidacion = Contratosperliquidacion.find(params[:id])
  end

  def liquidacion
    @cpl = Contratosperliquidacion.find(params[:id])
    #ActiveRecord::Base.connection.execute("CALL prc_liquidacion_recal_esp(#{@cpl.contratosperfecha_id})")
    @logo = Contratosperfecha.find(@cpl.contratosperfecha_id).contrato.empresa.logo.to_s
    @contratosperliquidacion = Contratosperliquidacion.find(params[:id])
    @contratosperliqnovedades = Contratosperliqnovedad.where(contratosperliquidacion_id: params[:id])
    @isadmin = is_admin
    fname = "AsearLiquidacion_" + @contratosperliquidacion.contratosperfecha.contratospersona.autobuscar.gsub(' ','_').to_s
    respond_to do |format|
      format.pdf { render pdf:"#{fname}", template:"contratosperliquidaciones/liquidacion", encoding: "UTF-8", page_size: 'Letter'}
    end
  end

  def reliquidacion
    @cpl = Contratosperliquidacion.find(params[:id])
    ActiveRecord::Base.connection.execute("CALL prc_liquidacion_recal_esp(#{@cpl.contratosperfecha_id})")
    respond_to do |format|
      format.js
    end
  end

  def liquidacion_masive
    @consecutivo = params[:consecutivo].to_s
    @solicitudesretiros = Solicitudesretiro.where(consecutivo: @consecutivo)
    @isadmin = is_admin
    fname = "AsearLiquidacion_" + @consecutivo
    respond_to do |format|
      format.pdf { render pdf:"#{fname}", template:"contratosperliquidaciones/liquidacion_masive", encoding: "UTF-8", page_size: 'Letter'} #,disposition: 'attachment'}
    end
  end

  def liquidacionmasive
    @consecutivo = params[:consecutivo].to_s
    @solicitudesretiros = Solicitudesretiro.where(consecutivo: @consecutivo)
    @isadmin = is_admin
    fname = "AsearLiquidacion_" + @consecutivo
    respond_to do |format|
      format.pdf { render pdf:"#{fname}", template:"contratosperliquidaciones/liquidacionmasive", encoding: "UTF-8", page_size: 'Letter'} #,disposition: 'attachment'}
    end
  end

  def index

  end

  def new
  end

  def edit
    respond_to do |format|
      format.html { render :action => "contratosperliquidacion_form" }
    end
  end

  def create

  end

  def update
    @contratosperliquidacion.user_act = is_admin
    if @contratosperliquidacion.update(contratosperliquidacion_params)
      flash[:notice] = "Actualizado con Exito"
      redirect_to edit_contratosperliquidacion_path(id: @contratosperliquidacion.id)
    else
      render "contratosperliquidacion_form"
    end
  end

  def archivoplano
    entidad = params[:entidad].to_s rescue ""
    tipocuenta = params[:tipocuenta].to_s rescue ""
    consecutivo = params[:consecutivo].to_s rescue ""
    if entidad.to_s != "" and consecutivo.to_s != ""
      if entidad.to_s == "BANCOLOMBIA"
        objetos = Objeto.find_by_sql([" SELECT CONCAT('18110442538ASEAR S.A. E.S.P225',RPAD(SUBSTR(r.consecutivo,1,10),10,' '),DATE_FORMAT(CURDATE(),'%%y%%m%%d'),'A',DATE_FORMAT(CURDATE(),'%%y%%m%%d'),
                                               LPAD(COUNT(9),6,'0'),LPAD(SUM(ROUND(l.total)),24,'0'),'61335009703D') dato
                                        FROM   contratosperliquidaciones l, solicitudesretiros r, contratosperfechas f, contratospersonas p
                                        WHERE  r.consecutivo = #{consecutivo}
                                        AND    r.contratosperfecha_id = l.contratosperfecha_id
                                        AND    l.contratosperfecha_id = f.id
                                        AND    f.contratospersona_id = p.id
                                        AND    p.banco = '#{entidad}'
                                        UNION ALL
                                        SELECT CONCAT(6,LPAD(p.identificacion,15,'0'),RPAD(SUBSTR(p.nombre_completo,1,18),18,' '),'005600078',LPAD(p.cuenta_bancolombia,17,'0'),
                                               'S37',LPAD(ROUND(l.total),10,'0'))
                                        FROM   contratosperliquidaciones l, solicitudesretiros r, contratosperfechas f, contratospersonas p
                                        WHERE  r.consecutivo = #{consecutivo}
                                        AND    r.contratosperfecha_id = l.contratosperfecha_id
                                        AND    l.contratosperfecha_id = f.id
                                        AND    f.contratospersona_id = p.id
                                        AND    p.banco = '#{entidad}'"])
        rutaupload = "#{::Rails.root}/public/Liquidacion_#{entidad}_#{consecutivo.to_s}_#{Time.now.strftime("%Y%m%d")}.txt"
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
                                                LPAD(ROUND(l.total),16,'0'),'00',
                                                LPAD('0',48,'0'),
                                                RPAD(SUBSTR(p.nombre_completo,1,30),30,' '),
                                                LPAD(p.identificacion,11,'0'),
                                                LPAD('0',26,'0'),
                                                LPAD('0',2,'0')) dato,
                                                LPAD(CRC32(CONCAT('02','000023','06',LPAD('477014427',16,'0'),'052','01',
                                                LPAD(p.cuenta_bancolombia,16,'0'),
                                                LPAD(@rownum:=@rownum+1,9,'0'),
                                                LPAD(ROUND(l.total),16,'0'),'00',
                                                LPAD('0',48,'0'),
                                                RPAD(SUBSTR(p.nombre_completo,1,30),30,' '),
                                                LPAD(p.identificacion,11,'0'),
                                                LPAD('0',26,'0'),
                                                LPAD('0',2,'0'))),15,' ') dato2
                                        FROM   (SELECT @rownum:=0) d, contratosperliquidaciones l, solicitudesretiros r, contratosperfechas f, contratospersonas p
                                        WHERE  r.consecutivo = #{consecutivo}
                                        AND    r.contratosperfecha_id = l.contratosperfecha_id
                                        AND    l.contratosperfecha_id = f.id
                                        AND    f.contratospersona_id = p.id
                                        AND    p.banco = '#{entidad}'"])
        rutaupload = "#{::Rails.root}/public/Liquidacion_#{entidad}_#{consecutivo.to_s}_#{Time.now.strftime("%Y%m%d")}.txt"
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
                                                   LPAD(SUM(ROUND(l.total)),18,'0'),'00',LPAD(CRC32('#{sqlDatos}'),15,' '),
                                                   LPAD(' ',145,' ')) dato
                                            FROM   contratosperliquidaciones l, solicitudesretiros r, contratosperfechas f, contratospersonas p
                                            WHERE  r.consecutivo = #{consecutivo}
                                            AND    r.contratosperfecha_id = l.contratosperfecha_id
                                            AND    l.contratosperfecha_id = f.id
                                            AND    f.contratospersona_id = p.id
                                            AND    p.banco = '#{entidad}'"])[0].dato.to_s
          the_file.write datofinal.to_s + "\r\n"
          the_file.close
        end
        send_file rutaupload, type: "text/plain", x_sendfile: true
      elsif entidad.to_s == "DAVIVIENDA"
        objetos = Objeto.find_by_sql(["SELECT CONCAT('RC',LPAD('8110442538',16,'0'),'NOMI','NOMI',LPAD('38070107123',16,'0'),
                                                'CA','000051',LPAD(SUM(ROUND(l.total)),16,'0'),'00',LPAD(COUNT(9),6,'0'),
                                                DATE_FORMAT(CURDATE(),'%%Y%%m%%d%%h%%m%%s'),'00009999',LPAD('0',16,'0'),'01',LPAD('0',56,'0')) dato
                                        FROM   contratosperliquidaciones l, solicitudesretiros r, contratosperfechas f, contratospersonas p
                                        WHERE  r.consecutivo = #{consecutivo}
                                        AND    r.contratosperfecha_id = l.contratosperfecha_id
                                        AND    l.contratosperfecha_id = f.id
                                        AND    f.contratospersona_id = p.id
                                        AND    p.tipo_cuenta = '#{tipocuenta}'
                                        AND    p.banco = '#{entidad}'
                                        UNION ALL
                                        SELECT CONCAT('TR',LPAD(p.identificacion,16,'0'),LPAD('0',16,'0'),
                                                LPAD(p.cuenta_bancolombia,16,'0'),(CASE WHEN p.tipo_cuenta = 'DAVIPLATA' THEN 'DP' ELSE 'CA' END),
                                                '000051',LPAD(ROUND(l.total),16,'0'),'00','000000','02','1','9999',LPAD('0',41,'0'),LPAD('0',40,'0')) dato
                                        FROM   contratosperliquidaciones l, solicitudesretiros r, contratosperfechas f, contratospersonas p
                                        WHERE  r.consecutivo = #{consecutivo}
                                        AND    r.contratosperfecha_id = l.contratosperfecha_id
                                        AND    l.contratosperfecha_id = f.id
                                        AND    f.contratospersona_id = p.id
                                        AND    p.tipo_cuenta = '#{tipocuenta}'
                                        AND    p.banco = '#{entidad}'"])
        rutaupload = "#{::Rails.root}/public/Liquidacion_#{entidad}_#{tipocuenta.to_s}_#{consecutivo.to_s}_#{Time.now.strftime("%Y%m%d")}.txt"
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
                                               RPAD(p.cuenta_bancolombia,17,' '),LPAD(ROUND(l.total),16,'0'),'00','A','000','001','0000',RPAD('PAGO DE LIQ',80,' '),
                                               '0',LPAD(l.id,10,'0'),'N',
                                               LPAD(' ',8,' '),LPAD(' ',16,' '),'  ',LPAD(' ',22,' '),'N',LPAD(' ',8,' ')) dato
                                        FROM   contratosperliquidaciones l, solicitudesretiros r, contratosperfechas f, contratospersonas p
                                        WHERE  r.consecutivo = #{consecutivo}
                                        AND    r.contratosperfecha_id = l.contratosperfecha_id
                                        AND    l.contratosperfecha_id = f.id
                                        AND    f.contratospersona_id = p.id
                                        AND    p.banco = '#{entidad}'"])
        rutaupload = "#{::Rails.root}/public/Liquidacion_#{entidad}_#{tipocuenta.to_s}_#{consecutivo.to_s}_#{Time.now.strftime("%Y%m%d")}.txt"
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
      redirect_to contratospernominas_path
    end
  end

  def recalculo
    consecutivo = params[:consecutivo]
    ActiveRecord::Base.connection.execute("CALL prc_liquidaciones_recal_esp_masiva(#{consecutivo})")
    redirect_to contratospernominas_path
  end

  private

  def set_layout
    if ['index', 'new'].include?(action_name)
      'application_admin'
    elsif ['edit'].include?(action_name)
      'application_contratosperliquidaciones'
    elsif ['validacion'].include?(action_name)
      "inscripcion_layout"
    elsif ['liquidacion'].include?(action_name)
      'blank'
    else
      "application_admin"
    end
  end

  def set_contratosperliquidacion
    @contratosperliquidacion = Contratosperliquidacion.find(params[:id])
  end

  def contratosperliquidacion_params
    params.require(:contratosperliquidacion).permit!
  end
end

