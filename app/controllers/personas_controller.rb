class PersonasController < ApplicationController
  before_action :set_persona, only: [:show, :edit, :update, :destroy]

  layout :set_layout
  before_action :checkaccess

  def checkaccess
    return is_permit('personas')
  end

  def index
    # andres  QR
    #qr = Barby::QrCode.new('12345678')
    #@qr = Barby::CairoOutputter.new(qr).to_svg
    msj = ""
    if params[:nombre].to_s != "" or params[:identificacion].to_s != ""
      msj ="No hay resultados de la consulta"
    end
    nroreg = 10
    @personas = Persona.search(params[:nombre],params[:identificacion],params[:page],nroreg)
    if @personas.count.to_i == 0
      flash[:warning] = "No hay resultados de la consulta!!!"
    else
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @personas }
      end
    end
  end

  def new
    @persona = Persona.new
    render "persona_form"
  end

  def edit
    @personasevaluacionesr = Personasevaluacion.where(["persona_id = #{@persona.id}"]).order("id desc")
    @personasevaluacionesinf = Personasevaluacion.where(["persona_id = #{@persona.id} and (IF(eva_1='SI',1,0)+IF(eva_2='SI',1,0)+IF(eva_3='SI',1,0)+IF(eva_4='SI',1,0)+IF(eva_5='SI',1,0)+IF(eva_6='SI',1,0)+IF(eva_7='SI',1,0)+IF(eva_8='SI',1,0)) >= 2"]).order("id desc")
    respond_to do |format|
      format.html { render :action => "persona_form" }
    end
  end

  def create
    @persona = Persona.new(persona_params)
    respond_to do |format|
      if @persona.save
        format.html { redirect_to edit_persona_path(id: @persona.id), notice: "El registro ha sido registrado con Exito." }
        format.json { render :show, status: :created, location: @persona }
      else
        format.html { render :new }
        format.json { render json: @persona.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @persona.update(persona_params)
      flash['success'] = "Usuario actualizado"
      redirect_to edit_persona_path(id: @persona.id, etapa: 'A')
    else
      render "persona_form"
    end
  end

  def destroy
    @persona.destroy
    flash[:notice] = "El registro ha sido borrado con Exito."
    respond_to do |format|
      format.html { redirect_to(personas_url) }
      format.xml { head :ok }
    end
  end

  def seguimiento
    anno = params[:ubicacion][:anno].to_s rescue ""
    mes = params[:ubicacion][:mes].to_s rescue ""
    portafolioId = params[:ubicacion][:portafolio_id].to_s rescue ""
    if anno == "" or mes == "" or portafolioId == ""
      flash[:warning] = "No hay resultados de la consulta!!!"
      redirect_to personas_path
    else
      fchmin = anno+'-'+mes
      #portafolioId = is_portafolio
      namecorto = Portafolio.find(portafolioId).nombrecorto.to_s rescue nil
      ActiveRecord::Base.connection.execute("CALL registro('#{fchmin}',#{portafolioId})")
      headers = []
      headers << 'Identificacion'
      headers << 'Nombre'
      datos = []
      datos << 'identificacion'
      datos << 'nombre'
      fchs = Fecha.where(["DATE_FORMAT(fecha, '%%Y-%%m') = '#{fchmin}'"]).order("fecha asc")
      fchs.each do |a|
        datos << 'C'+a.fecha.strftime("%Y_%m_%d").to_s
        headers << a.fecha.strftime("%Y_%m_%d").to_s
      end
      tbDatos = Objeto.find_by_sql(["select * from datos where portafolio_id = ? ", portafolioId])
      ex = Axlsx::Package.new
      ex.use_autowidth = false
      wd = ex.workbook
      wd.styles do |style|
        titlec = wd.styles.add_style(b: true, bg_color: "FF045FB4",fg_color: 'F5F6CE',sz: 11,font_name: "Calibri",:alignment=>{:horizontal => :center, :vertical => :center})
        header1c = wd.styles.add_style(b: true, bg_color: "FFE87F07",fg_color: 'F5F6CE',sz: 11,font_name: "Calibri",:alignment=>{:horizontal => :center, :vertical => :center})
        datosiz = wd.styles.add_style(sz: 11,font_name: "Calibri",:alignment=>{:horizontal => :left, :vertical => :center})
        fecha = wd.styles.add_style(sz: 11,font_name: "Calibri", :format_code => 'dd-mm-yyyy',:alignment=>{:horizontal => :right, :vertical => :center})
        datosnumeros1 = wd.styles.add_style(:format_code => '#,###,###0',sz: 11,font_name: "Calibri",:alignment=>{:horizontal => :center, :vertical => :center})
        tamanos = [15,40,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12]
        wd.add_worksheet(:name => "Seguimiento #{namecorto}")  do |sheet|
          sheet.add_row headers,
                        :style => [titlec,titlec,
                                   header1c,header1c,header1c,header1c,header1c,header1c,header1c,header1c,header1c,header1c,
                                   header1c,header1c,header1c,header1c,header1c,header1c,header1c,header1c,header1c,header1c,
                                   header1c,header1c,header1c,header1c,header1c,header1c,header1c,header1c,header1c,header1c,header1c],
                        :height => 20,
                        :widths => tamanos
          puts headers
          tbDatos.each do |p|
            array1 = JSON.parse(p.to_json(only: [datos], :methods =>datos))
            sheet.add_row array1.values,
                          :style =>[datosiz,datosiz,
                                    datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,
                                    datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,
                                    datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1],
                          :types => [:string,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil],
                          :widths => tamanos
          end
        end
      end
      rootName = "#{::Rails.root}/public/Seg_#{namecorto}_#{Date.today}.xlsx"
      FileUtils.rm_r Dir.glob("#{rootName}")
      ex.serialize("#{rootName}")
      send_file rootName.to_s, :disposition => "attachment"
    end
  end

  def seguimientoa
    anno = params[:ubicacion][:annoa].to_s rescue ""
    mes = params[:ubicacion][:mesa].to_s rescue ""
    if anno == "" or mes == ""
      flash[:warning] = "No hay resultados de la consulta!!!"
      redirect_to personas_path
    else
      fchmin = anno+'-'+mes
      ActiveRecord::Base.connection.execute("CALL registro2('#{fchmin}')")
      headers = []
      headers << 'Identificacion'
      headers << 'Nombre'
      headers << 'Empresa'
      datos = []
      datos << 'identificacion'
      datos << 'nombre'
      datos << 'nombrepor'
      fchs = Fecha.where(["DATE_FORMAT(fecha, '%%Y-%%m') = '#{fchmin}' and fecha <= now()"]).order("fecha asc")
      fchs.each do |a|
        datos << 'M'+a.fecha.strftime("%Y_%m_%d").to_s
        datos << 'T'+a.fecha.strftime("%Y_%m_%d").to_s
        headers << 'M'+a.fecha.strftime("%Y_%m_%d").to_s
        headers << 'T'+a.fecha.strftime("%Y_%m_%d").to_s
      end
      tbDatos = Objeto.find_by_sql(["select * from datosfff"])
      ex = Axlsx::Package.new
      ex.use_autowidth = false
      wd = ex.workbook
      wd.styles do |style|
        titlec = wd.styles.add_style(b: true, bg_color: "FF045FB4",fg_color: 'F5F6CE',sz: 11,font_name: "Calibri",:alignment=>{:horizontal => :center, :vertical => :center})
        header1c = wd.styles.add_style(b: true, bg_color: "FFE87F07",fg_color: 'F5F6CE',sz: 11,font_name: "Calibri",:alignment=>{:horizontal => :center, :vertical => :center})
        datosiz = wd.styles.add_style(sz: 11,font_name: "Calibri",:alignment=>{:horizontal => :left, :vertical => :center})
        fecha = wd.styles.add_style(sz: 11,font_name: "Calibri", :format_code => 'dd-mm-yyyy',:alignment=>{:horizontal => :right, :vertical => :center})
        datosnumeros1 = wd.styles.add_style(:format_code => '#,###,###0',sz: 11,bg_color: '00BB2D',font_name: "Calibri",:alignment=>{:horizontal => :center, :vertical => :center})
        datosnumeros2 = wd.styles.add_style(:format_code => '#,###,###0',sz: 11,bg_color: 'ff0000',fg_color: 'F5F6CE',font_name: "Calibri",:alignment=>{:horizontal => :center, :vertical => :center})
        tamanos = [15,40,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12]

        wd.add_worksheet(:name => "Seguimiento")  do |sheet|
          sheet.add_row headers,
                        :style => titlec,
                        :height => 20,
                        :widths => tamanos
          puts headers
          tbDatos.each do |p|
            array1 = JSON.parse(p.to_json(only: [datos], :methods =>datos))
            puts array1.values
            sql = ""
            sql << " #{array1.values.join(",")}"
            puts "++++++"
            puts sql
            p = array1.values.map { |x| x == 1 ? eval('datosnumeros1') : x == 0 ? eval('datosnumeros2') : eval('datosiz') }
            puts "--------"
            puts p
            sheet.add_row array1.values, :style =>p,
                          #:style =>[datosiz,datosiz,
                          #          datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,
                          #         datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,
                          #          datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,
                          #          datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,
                          #          datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,
                          #          datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,datosnumeros1,
                          #          datosnumeros1,datosnumeros1],
                          :types => [:string,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil],
                          :widths => tamanos
          end
        end
      end
      rootName = "#{::Rails.root}/public/SegAdmin_#{Date.today}.xlsx"
      FileUtils.rm_r Dir.glob("#{rootName}")
      ex.serialize("#{rootName}")
      send_file rootName.to_s, :disposition => "attachment"
    end
  end

  def seguimientoa2
    fch = params[:fecha].to_s
    if fch == ""
      flash[:warning] = "No hay resultados de la consulta!!!"
      redirect_to personas_path
    else
      fchmin = fch
      ActiveRecord::Base.connection.execute("CALL registrodiario('#{fchmin}')")
      headers = []
      headers << 'Identificacion'
      headers << 'Nombre'
      headers << 'Empresa'
      headers << 'Mañana'
      headers << 'Tarde'
      datos = []
      datos << 'identificacion'
      datos << 'nombre'
      datos << 'nombrepor'
      datos << 'manana'
      datos << 'tarde'
      tbDatos = Objeto.find_by_sql(["select identificacion,nombre,nombrepor, DATE_FORMAT(manana,'%%Y-%%m-%%d %%h:%%i:%%s') manana, DATE_FORMAT(tarde,'%%Y-%%m-%%d %%h:%%i:%%s') tarde
                                    from informediario"])
      ex = Axlsx::Package.new
      ex.use_autowidth = false
      wd = ex.workbook
      wd.styles do |style|
        titlec = wd.styles.add_style(b: true, bg_color: "FF045FB4",fg_color: 'F5F6CE',sz: 11,font_name: "Calibri",:alignment=>{:horizontal => :center, :vertical => :center})
        header1c = wd.styles.add_style(b: true, bg_color: "FFE87F07",fg_color: 'F5F6CE',sz: 11,font_name: "Calibri",:alignment=>{:horizontal => :center, :vertical => :center})
        datosiz = wd.styles.add_style(sz: 11,font_name: "Calibri",:alignment=>{:horizontal => :left, :vertical => :center})
        fecha = wd.styles.add_style(sz: 11,font_name: "Calibri", :format_code => 'dd-mm-yyyy',:alignment=>{:horizontal => :right, :vertical => :center})
        datosnumeros1 = wd.styles.add_style(:format_code => '#,###,###0',sz: 11,bg_color: '00BB2D',font_name: "Calibri",:alignment=>{:horizontal => :center, :vertical => :center})
        datosnumeros2 = wd.styles.add_style(:format_code => '#,###,###0',sz: 11,bg_color: 'ff0000',fg_color: 'F5F6CE',font_name: "Calibri",:alignment=>{:horizontal => :center, :vertical => :center})
        fecha_min = wd.styles.add_style(sz: 11,font_name: "Calibri", :format_code => 'YYYY-MM-DD HH:MM:SS',:alignment=>{:horizontal => :right, :vertical => :center})
        tamanos = [15,40,20,20,20,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12]

        wd.add_worksheet(:name => "Seguimiento")  do |sheet|
          sheet.add_row headers,
                        :style => titlec,
                        :height => 20,
                        :widths => tamanos
          puts headers
          tbDatos.each do |p|
            array1 = JSON.parse(p.to_json(only: [datos], :methods =>datos))
            sheet.add_row array1.values,
                          :style => [datosiz,datosiz,datosiz,fecha_min,fecha_min],
                          :types => [:string,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil],
                          :widths => tamanos
          end
        end
      end
      rootName = "#{::Rails.root}/public/SegAdmin2_#{Date.today}.xlsx"
      FileUtils.rm_r Dir.glob("#{rootName}")
      ex.serialize("#{rootName}")
      send_file rootName.to_s, :disposition => "attachment"
    end
  end

  def activarinactivar
    if params[:act].to_s == 'A'
      Persona.where(id: params[:id]).update_all(administrativo: params[:act].to_s, updated_at: Time.now)
      flash['success'] = "Activado Administrativo"
      redirect_to personas_path
    elsif params[:act].to_s == 'I'
      Persona.where(id: params[:id]).update_all(administrativo: params[:act].to_s, updated_at: Time.now)
      flash['success'] = "InActivado Administrativo"
      redirect_to personas_path
    end
  end

  private

  def set_layout
    if ['index', 'new'].include?(action_name)
      'application_admin'
    elsif ['edit'].include?(action_name)
      'application_personas'
    else
      "application_admin"
    end
  end

  def set_persona
    @persona = Persona.find(params[:id])
  end

  def persona_params
    params.require(:persona).permit!
  end
end
