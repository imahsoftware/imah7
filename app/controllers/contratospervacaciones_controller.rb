class ContratospervacacionesController < ApplicationController
  before_action :set_contratospervacacion, only: [:show, :edit, :update, :destroy]

  layout :set_layout

  def index
  end

  def show
  end

  def marcar_firma
    @contratospervacacion = Contratospervacacion.find(params[:id])
    @contratospervacacion.firma = 'SI'
    @contratospervacacion.save(validate: false)
  end

  def evaluar
    if params[:e].to_s == 'PAGADO'
      consecutivo = params[:consecutivo].to_s
      if consecutivo.to_i > 0
        Contratospervacacion.where(consecutivo: consecutivo).update_all(estado: 'PAGADA', updated_at: Time.now)
        ActiveRecord::Base.connection.execute("CALL prc_vacaciones_corte(-1,#{consecutivo})")
      end
    else
      @contratospervacacion = Contratospervacacion.find(params[:id])
      if params[:e].to_s == 'APROBADA'
        @contratospervacacion.user_aprueba = is_admin
        @contratospervacacion.estado = 'APROBADA'
        @contratospervacacion.save
        ActiveRecord::Base.connection.execute("CALL prc_vacaciones_corte(#{@contratospervacacion.id},-1)")
      elsif params[:e].to_s == 'LIQUIDADA'
        @contratospervacacion.estado = 'LIQUIDADA'
        @contratospervacacion.consecutivo = is_consecutivovaca
        @contratospervacacion.save
      elsif params[:e].to_s == 'ELIMINAR'
        @contratospervacacion.destroy
      end
    end
    respond_to do |format|
      flash['success'] = "Proceso Realizado"
      format.js
    end
  end

  def vacacion
    if params[:contratosperfecha_id].to_s != ""
      @contratospervacaciones = Contratospervacacion.where(contratosperfecha_id: params[:contratosperfecha_id].to_i).order("id asc")
    else
      @contratospervacaciones = Contratospervacacion.where(id: params[:id].to_i).order("id asc")
    end
    #@cpl = @contratospervacacion
    #@logo = @contratospervacacion.contratosperfecha.contrato.empresa.logo.to_s
    @isadmin = is_admin
    fname = "LiqVacaciones_" + @contratospervacaciones[0].contratosperfecha.contratospersona.identificacion.to_s
    respond_to do |format|
      format.pdf { render pdf: "#{fname}", template: "contratospervacaciones/vacacion", encoding: "UTF-8", page_size: 'Letter' } #,disposition: 'attachment'}
    end
  end

  def carta
    if params[:contratosperfecha_id].to_s != ""
      @contratospervacacion = Contratospervacacion.where(contratosperfecha_id: params[:contratosperfecha_id].to_i)[0]
    else
      @contratospervacacion = Contratospervacacion.find(params[:id])
    end
    @cpl = @contratospervacacion
    @logo = @contratospervacacion.contratosperfecha.contrato.empresa.logo.to_s
    @isadmin = is_admin
    fname = "CartaVacaciones_" + @contratospervacacion.contratosperfecha.contratospersona.identificacion.to_s
    respond_to do |format|
      format.pdf { render pdf: "#{fname}", template: "contratospervacaciones/carta.html.erb", encoding: "UTF-8", page_size: 'Letter' } #,disposition: 'attachment'}
    end
  end

  def vacacion_masive
    @consecutivo = params[:consecutivo].to_s
    @contratospervacaciones = Contratospervacacion.where(consecutivo: @consecutivo)
    @isadmin = is_admin
    fname = "AsearVacaciones_" + @consecutivo
    respond_to do |format|
      format.pdf { render pdf: "#{fname}", template: "contratospervacaciones/vacacion_masive", encoding: "UTF-8", page_size: 'Letter' } #,disposition: 'attachment'}
    end
  end

  def vacacionmasive
    @consecutivo = params[:consecutivo].to_s
    @contratospervacaciones = Contratospervacacion.where(consecutivo: @consecutivo)
    @isadmin = is_admin
    fname = "AsearVacaciones_" + @consecutivo
    respond_to do |format|
      format.pdf { render pdf: "#{fname}", template: "contratospervacaciones/vacacionmasive", encoding: "UTF-8", page_size: 'Letter' } #,disposition: 'attachment'}
    end
  end

  def archivoplano
    entidad = params[:entidad].to_s rescue ""
    tipocuenta = params[:tipocuenta].to_s rescue ""
    consecutivo = params[:consecutivo].to_s rescue ""
    if entidad.to_s != "" and consecutivo.to_s != ""
      if entidad.to_s == "BANCOLOMBIA"
        objetos = Objeto.find_by_sql([" SELECT CONCAT('18110442538ASEAR S.A. E.S.P225',RPAD(SUBSTR(r.consecutivo,1,10),10,' '),DATE_FORMAT(CURDATE(),'%%y%%m%%d'),'A',DATE_FORMAT(CURDATE(),'%%y%%m%%d'),
                                               LPAD(COUNT(9),6,'0'),LPAD(SUM(ROUND(r.valor_total)),24,'0'),'61335009703D') dato
                                        FROM   contratospervacaciones r, contratosperfechas f, contratospersonas p
                                        WHERE  r.consecutivo = #{consecutivo}
                                        AND    r.contratosperfecha_id = f.id
                                        AND    f.contratospersona_id = p.id
                                        AND    p.banco = '#{entidad}'
                                        UNION ALL
                                        SELECT CONCAT(6,LPAD(p.identificacion,15,'0'),RPAD(SUBSTR(p.nombre_completo,1,18),18,' '),'005600078',LPAD(p.cuenta_bancolombia,17,'0'),
                                               'S37',LPAD(ROUND(r.valor_total),10,'0'))
                                        FROM   contratospervacaciones r, contratosperfechas f, contratospersonas p
                                        WHERE  r.consecutivo = #{consecutivo}
                                        AND    r.contratosperfecha_id = f.id
                                        AND    f.contratospersona_id = p.id
                                        AND    p.banco = '#{entidad}'"])
        rutaupload = "#{::Rails.root}/public/Vacaciones_#{entidad}_#{consecutivo.to_s}_#{Time.now.strftime("%Y%m%d")}.txt"
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
                                                LPAD(ROUND(r.valor_total),16,'0'),'00',
                                                LPAD('0',48,'0'),
                                                RPAD(SUBSTR(p.nombre_completo,1,30),30,' '),
                                                LPAD(p.identificacion,11,'0'),
                                                LPAD('0',26,'0'),
                                                LPAD('0',2,'0')) dato,
                                                LPAD(CRC32(CONCAT('02','000023','06',LPAD('477014427',16,'0'),'052','01',
                                                LPAD(p.cuenta_bancolombia,16,'0'),
                                                LPAD(@rownum:=@rownum+1,9,'0'),
                                                LPAD(ROUND(r.valor_total),16,'0'),'00',
                                                LPAD('0',48,'0'),
                                                RPAD(SUBSTR(p.nombre_completo,1,30),30,' '),
                                                LPAD(p.identificacion,11,'0'),
                                                LPAD('0',26,'0'),
                                                LPAD('0',2,'0'))),15,' ') dato2
                                        FROM   (SELECT @rownum:=0) d, contratospervacaciones r, contratosperfechas f, contratospersonas p
                                        WHERE  r.consecutivo = #{consecutivo}
                                        AND    r.contratosperfecha_id = f.id
                                        AND    f.contratospersona_id = p.id
                                        AND    p.banco = '#{entidad}'"])
        rutaupload = "#{::Rails.root}/public/Vacaciones_#{entidad}_#{consecutivo.to_s}_#{Time.now.strftime("%Y%m%d")}.txt"
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
                                                   LPAD(SUM(ROUND(r.valor_total)),18,'0'),'00',LPAD(CRC32('#{sqlDatos}'),15,' '),
                                                   LPAD(' ',145,' ')) dato
                                            FROM   contratospervacaciones r, contratosperfechas f, contratospersonas p
                                            WHERE  r.consecutivo = #{consecutivo}
                                            AND    r.contratosperfecha_id = f.id
                                            AND    f.contratospersona_id = p.id
                                            AND    p.banco = '#{entidad}'"])[0].dato.to_s
          the_file.write datofinal.to_s + "\r\n"
          the_file.close
        end
        send_file rutaupload, type: "text/plain", x_sendfile: true
      elsif entidad.to_s == "DAVIVIENDA"
        objetos = Objeto.find_by_sql(["SELECT CONCAT('RC',LPAD('8110442538',16,'0'),'NOMI','NOMI',LPAD('38070107123',16,'0'),
                                                'CA','000051',LPAD(SUM(ROUND(r.valor_total)),16,'0'),'00',LPAD(COUNT(9),6,'0'),
                                                DATE_FORMAT(CURDATE(),'%%Y%%m%%d%%h%%m%%s'),'00009999',LPAD('0',16,'0'),'01',LPAD('0',56,'0')) dato
                                        FROM   contratospervacaciones r, contratosperfechas f, contratospersonas p
                                        WHERE  r.consecutivo = #{consecutivo}
                                        AND    r.contratosperfecha_id = f.id
                                        AND    f.contratospersona_id = p.id
                                        AND    p.tipo_cuenta = '#{tipocuenta}'
                                        AND    p.banco = '#{entidad}'
                                        UNION ALL
                                        SELECT CONCAT('TR',LPAD(p.identificacion,16,'0'),LPAD('0',16,'0'),
                                                LPAD(p.cuenta_bancolombia,16,'0'),(CASE WHEN p.tipo_cuenta = 'DAVIPLATA' THEN 'DP' ELSE 'CA' END),
                                                '000051',LPAD(ROUND(r.valor_total),16,'0'),'00','000000','02','1','9999',LPAD('0',41,'0'),LPAD('0',40,'0')) dato
                                        FROM   contratospervacaciones r, contratosperfechas f, contratospersonas p
                                        WHERE  r.consecutivo = #{consecutivo}
                                        AND    r.contratosperfecha_id = f.id
                                        AND    f.contratospersona_id = p.id
                                        AND    p.tipo_cuenta = '#{tipocuenta}'
                                        AND    p.banco = '#{entidad}'"])
        rutaupload = "#{::Rails.root}/public/Vacaciones_#{entidad}_#{tipocuenta.to_s}_#{consecutivo.to_s}_#{Time.now.strftime("%Y%m%d")}.txt"
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
                                               RPAD(p.cuenta_bancolombia,17,' '),LPAD(ROUND(l.valor_total),16,'0'),'00','A','000','001','0000',RPAD('PAGO VAC',80,' '),
                                               '0',LPAD(l.id,10,'0'),'N',
                                               LPAD(' ',8,' '),LPAD(' ',16,' '),'  ',LPAD(' ',22,' '),'N',LPAD(' ',8,' ')) dato
                                        FROM   contratospervacaciones l, contratosperfechas f, contratospersonas p
                                        WHERE  l.consecutivo = #{consecutivo}
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

  def new
    @contratospervacacion = Contratospervacacion.new
    @contratospervacacion.contrato_id = params[:contrato_id].to_i
    @contratospervacacion.contratosperfecha_id = params[:contratosperfecha_id].to_i
    @contratospervacacion.contratospersona_id = params[:contratospersona_id].to_i
  end

  def edit
  end

  def create
    @contratospervacacion = Contratospervacacion.new(contratospervacacion_params)
    @contratospervacacion.user_id = is_admin
    @contratospervacacion.estado = 'PENDIENTE'
    respond_to do |format|
      if @contratospervacacion.save
        ActiveRecord::Base.connection.execute("CALL prc_vacaciones(#{@contratospervacacion.id})")
        flash['success'] = "Creado con exito"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratospervacacion } }
      end
    end
  end

  def update
    respond_to do |format|
      if @contratospervacacion.update(contratospervacacion_params)
        flash['success'] = "Actualizado con exito"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratospervacacion } }
      end
    end
  end

  def destroy
    @contratospervacacion.destroy
    flash['success'] = "Solicitud eliminada con exito"
    redirect_to contratospernominas_path
  end

  private

  def set_layout
    if ['vacacion'].include?(action_name)
      'blank'
    else
      "application_admin"
    end
  end

  def set_contratospervacacion
    @contratospervacacion = Contratospervacacion.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratospervacacion_params
    params.require(:contratospervacacion).permit!
  end
end
