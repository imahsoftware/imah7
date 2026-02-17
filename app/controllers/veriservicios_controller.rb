class VeriserviciosController < ApplicationController
  before_action :set_veriservicio, only: [:show, :edit, :update, :destroy]

  layout :set_layout
  # before_action :checkaccess

  def checkaccess
    return is_permit('veriservicios')
  end

  def get_contratossede_id
    @contrato = Contrato.find(params[:veriservicio_contrato_id])  if params[:veriservicio_contrato_id].present? && ["Seleccione"].exclude?(params[:veriservicio_contrato_id])
    @contratossedes = @contrato.contratossedes
    respond_to { |format| format.js }
  end

  def show_detalle
    @ruta = params[:ruta]
    @fecha = params[:fecha]
    @fechaparams = @fecha.gsub('-', '_')
    @veriservicios = Veriservicio.where("estado_proceso = 'EN PROCESO' and id in (select veriservicio_id from veriserviciosagendas where fecha_reprogramacion = '#{@fecha}')").order("id asc")
  end

  def self.generar_formatoPdf(veriserviciosagendaId, veriservicioId, isadmin)
    @veriserviciosagenda = Veriserviciosagenda.find(veriserviciosagendaId)
    @veriservicio = Veriservicio.find(veriservicioId)
    portafolio = Portafolio.find(@veriservicio.contrato.empresa.portafolio_id)
    @logo_firma = portafolio.logo_firma
    @logo = portafolio.logo_empresa_assets
    @nombre_firma = portafolio.nombre_rep.to_s
    @nombre_empresa = portafolio.razon_social.to_s

    @datos = Objeto.find_by_sql("
                          SELECT
                            v.clasificacion,
                            CAST(i.codigo_aportes AS UNSIGNED) AS codigo_aportes_numerico,
                            ROUND(SUM(CASE WHEN v.calificacion BETWEEN 1 AND 5 THEN v.calificacion ELSE 0 END) /
                                  NULLIF(COUNT(CASE WHEN v.calificacion BETWEEN 1 AND 5 THEN 1 ELSE NULL END), 0), 2) AS total

                         FROM veriserviciositems v
                         JOIN iparametros i ON v.clasificacion = i.clasificacion
                         WHERE v.veriservicio_id = #{@veriservicio.id}
                            AND v.calificacion IN (0, 1, 2, 3, 4, 5)
                            AND i.campo = 'verificacion_servicio'
                          GROUP BY v.clasificacion, codigo_aportes_numerico
                          ORDER BY codigo_aportes_numerico ASC, v.clasificacion ASC

                          ")

    @datos.each do |dato|
      Veriserviciosagendasdato.create(veriservicio_id: @veriservicio.id, clasificacion: dato.clasificacion, orden: dato.codigo_aportes_numerico, total: dato.total, veriserviciosagenda_id: @veriserviciosagenda.id)
    end


    rutafact = "#{::Rails.root}/public/archivos/pdf"
    fname = "VerificacionServicio_#{@veriserviciosagenda.id}.pdf"
    rutanamefile = "#{::Rails.root}/public/archivos/pdf/#{fname}.pdf"
    pdf = ApplicationController.render pdf: "#{fname}", template: "veriservicios/formatoPdf.html.erb", :save_to_file => rutanamefile, :save_only => true,
                                       encoding: "UTF-8", page_size: 'Letter', :margin => { top: 50, :bottom => 25, :left => 0, :right => 0 },
                                       :header => { spacing: 10, :html => { :template => 'veriservicios/headerPdf/header_acta_servicio.html.erb',  locals: { logo: @logo } } },
                                       locals: { veriservicio_id: @veriservicio.id, veriserviciosagenda_id: @veriserviciosagenda.id }

    save_path = Rails.root.join(rutafact, "#{fname}.pdf")
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
    file = File.open("#{::Rails.root}/public/archivos/pdf/#{fname}.pdf", 'rb')
    @veriserviciosasoporte = Veriserviciosasoporte.new
    @veriserviciosasoporte.veriserviciosagenda_id = @veriserviciosagenda.id
    @veriserviciosasoporte.verisoporte = file
    @veriserviciosasoporte.descripcion = "CERTIFICADO DE VERIFICACION - AGENDA #{@veriserviciosagenda.id}"
    @veriserviciosasoporte.user_id = isadmin
    @veriserviciosasoporte.save(validate: false)
    system("rm -r #{rutanamefile}") rescue nil
  end

  def formatoPdf
    @veriserviciosagenda = Veriserviciosagenda.find(params[:veriserviciosagenda_id])
    @veriservicio = Veriservicio.find(params[:id])
    portafolio = Portafolio.find(@veriservicio.contrato.empresa.portafolio_id)
    @logo_firma = portafolio.logo_firma
    @logo = portafolio.logo_empresa_assets
    @nombre_firma = portafolio.nombre_rep.to_s
    @nombre_empresa = portafolio.razon_social.to_s
    fname = "VerificacionServicio" + @veriservicio.id.to_s rescue nil
    respond_to do |format|
      format.pdf { render pdf: "#{fname}", template: "veriservicios/formatoPdf.html.erb",
                          encoding: "UTF-8", page_size: 'Letter',
                          :margin => { top: 35, :bottom => 10, :left => 0, :right => 0 },
                          :header => { spacing: 10, :html => { :template => 'veriservicios/headerPdf/header_acta_servicio.html.erb',
                                                               locals: { logo: @logo } } }}
    end
  end

  def dash
    @fechas = Veriserviciosagenda.select("fecha_reprogramacion").
      where("veriservicio_id in (select id from veriservicios where estado_proceso = 'EN PROCESO')").
      distinct.order("fecha_reprogramacion desc")
  end

  def fichas
    @veriservicio = Veriservicio.find(params[:id])
  end

  def search
    @veriservicios = Veriservicio.where("tipo = 'CONSUMO' and clase = 'GENERAL' and estado = 'ACTIVO' and bien_servicio LIKE ?", "%#{replacespace(params[:q]).upcase}%").limit(10)
    respond_to do |format|
      format.json { render json: @veriservicios.map { |p| { id: p.id, name: "#{p.veriserviciodetalle}" } } }
    end
  end

  def index

    veriservicio = Veriservicio.find_by(estado_proceso: 'PENDIENTE')

    if veriservicio
      redirect_to edit_veriservicio_path(id: veriservicio.id), notice: "Verificación en proceso"
    end

    msj = ""
    contrato = params[:ubicacion][:contrato_id] rescue nil
    estado_proceso = params[:ubicacion][:estado_proceso] rescue nil

    if  contrato.to_s != ""
      msj = "No hay resultados de la consulta"
    end
    nroreg = 10
    @veriservicios = Veriservicio.search(contrato, estado_proceso, params[:page], nroreg)
    if @veriservicios.count.to_i == 0
      flash[:warning] = "No hay resultados de la consulta!!!"
    else
      respond_to do |format|
        format.html # index.html.erb
        format.xml { render :xml => @veriservicios }
      end
    end
  end

  def new
    @veriservicio = Veriservicio.new
    render "veriservicio_form"
  end

  def verificacion
    @veriservicio = Veriservicio.find(params[:id])
    @veriservicio.estado_proceso = 'FINALIZADO'
    @veriservicio.user_proceso = is_admin
    @veriservicio.fecha_proceso = Time.now
    @veriservicio.save(validate: false)
    respond_to do |format|
      flash['success'] = "Proceso Finalizado"
      format.js { render inline: "location.reload();" }
    end
  end

  def edit
    @etapa = params[:etapa].present? ? params[:etapa] : 'A'
    @evaluador = false
    @mensaje = false
    total_items = Veriserviciositem.where(veriservicio_id: @veriservicio.id).count rescue 0
    if total_items.to_i == Veriserviciositem.where("veriservicio_id = #{@veriservicio.id} AND calificacion IS NOT NULL and calificacion NOT IN (1,2,3)").count.to_i
      @evaluador = true
    end
    if Veriserviciositem.where("veriservicio_id = #{@veriservicio.id} AND calificacion IS NOT NULL and calificacion IN (1,2,3)").present?
      @mensaje = true
    end
    respond_to do |format|

      items_con_calificacion = @veriservicio.veriserviciositems.where(calificacion: [1, 2, 3])

      # Encontrar un item que no tenga registros en las tablas relacionadas
      registro = items_con_calificacion.find do |item|
        !Veriserviciosinota.exists?(veriserviciositem_id: item.id) ||
          !Veriserviciosicompromiso.exists?(veriserviciositem_id: item.id) ||
          !Veriserviciosiimagen.exists?(veriserviciositem_id: item.id)
      end

      # Buscar items con calificación en 4 o 5
      items_con_calificacion_ok = @veriservicio.veriserviciositems.where(calificacion: [4, 5])

      # Encontrar un item que no tenga registros en las tablas relacionadas
      registro2 = items_con_calificacion_ok.find do |item|
        !Veriserviciosinota.exists?(veriserviciositem_id: item.id) ||
          !Veriserviciosiimagen.exists?(veriserviciositem_id: item.id)
      end

      if registro2
        format.html { redirect_to item_veriserviciositems_path(id: registro2.id), notice: "Pendiente por diligencias" }
      elsif registro
        format.html { redirect_to item_veriserviciositems_path(id: registro.id), notice: "Pendiente por diligencias" }
      else
        format.html { render action: "veriservicio_form" }
      end
    end
  end

  def create
    @veriservicio = Veriservicio.new(veriservicio_params)
    @veriservicio.user_id = is_admin
    @veriservicio.estado_proceso = 'PENDIENTE'
    respond_to do |format|
      if @veriservicio.save
        ActiveRecord::Base.connection.execute("
            INSERT INTO veriserviciositems ( veriservicio_id, clasificacion, descripcion, orden, created_at, updated_at)
            SELECT  #{@veriservicio.id}, clasificacion, descripcion, codigo_dian,  NOW(), NOW()
            FROM iparametros
            WHERE campo = 'verificacion_servicio' AND estado  = 'ACTIVO'
            ORDER BY CAST(codigo_aportes AS SIGNED), CAST(codigo_dian AS SIGNED)
        ")
        veriserviciosagendaId = Veriserviciosagenda.create!(user_id: is_admin, veriservicio_id: @veriservicio.id, nota: 'INICIO DE VERIFICACION', fecha_reprogramacion: Time.now).id
        Veriserviciosuser.create!(veriservicio_id: @veriservicio.id, user_id: @veriservicio.user_id, veriserviciosagenda_id: veriserviciosagendaId)

        format.html { redirect_to edit_veriservicio_path(id: @veriservicio.id, etapa: "A"), notice: "El registro ha sido registrado con Exito." }
        format.json { render :show, status: :created, location: @veriservicio }
      else
        format.html { render :action => "veriservicio_form" }
        format.json { render json: @veriservicio.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @veriservicio.update(veriservicio_params)
      flash['success'] = "Usuario actualizado"
      redirect_to edit_veriservicio_path(id: @veriservicio.id, etapa: "A")
    else
      render "veriservicio_form"
    end
  end

  def destroy
    @veriservicio.destroy
    flash[:notice] = "El registro ha sido borrado con Exito."
    respond_to do |format|
      format.html { redirect_to(veriservicios_url) }
      format.xml { head :ok }
    end
  end

  private

  def set_layout
    if ['index', 'new'].include?(action_name)
      'application_admin'
    elsif ['edit'].include?(action_name)
      'application_admin'
    else
      "application_admin"
    end
  end

  def set_veriservicio
    @veriservicio = Veriservicio.find(params[:id])
  end

  def veriservicio_params
    params.require(:veriservicio).permit!
  end
end
