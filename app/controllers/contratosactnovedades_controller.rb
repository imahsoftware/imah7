class ContratosactnovedadesController < ApplicationController
  before_action :set_contratosactnovedad, only: [:show, :visualizar, :edit, :update, :destroy, :destroy2, :mostrare]

  layout :set_layout
  #before_action :checkaccess

  def checkaccess
    return is_permit('contratosactnovedades')
  end

  def index
    @usr = User.find(is_admin)
    @contratosactnovedades = Contratosactnovedad.where(user_id: @usr.id).order(created_at: :asc)
  end

  def indexadmin
    isadmin = is_admin
    @contratosactnovedades = Contratosactnovedad.all
    if params[:etapa].to_s == ""
      @etapa = '1'
      ActiveRecord::Base.connection.execute("update users set etapa_seguimiento = '1' where id = #{isadmin}")
    else
      @etapa = params[:etapa]
      ActiveRecord::Base.connection.execute("update users set etapa_seguimiento = '#{params[:etapa]}' where id = #{isadmin}")
    end
    if @etapa.to_s == "1"
      @pendientes = @contratosactnovedades.where(estado: 'PENDIENTE')
    elsif @etapa.to_s == "2"
      @procesos = @contratosactnovedades.where(estado: 'EN PROCESO')
    elsif @etapa.to_s == "3"
      @atendidos = @contratosactnovedades.where(estado: 'ATENDIDO')
    elsif @etapa.to_s == "4"
    elsif @etapa.to_s == "5"
    elsif @etapa.to_s == "6"
      if params[:ubicacion][:nodo].present?# and params[:ubicacion][:fecha].present?
        @nodo = params[:ubicacion][:nodo]
        #@periodo = params[:ubicacion][:fecha]
      else
        @nodo = Seguimientonodo.select("nodo").distinct.first.nodo rescue nil
        #@periodo = Contratosactnovedad.select("DATE_FORMAT(fecha,'%m-%Y') as periodo").distinct.last.periodo rescue nil
      end
    end
  end

  def cambioestado
    @contratosactnovedad = Contratosactnovedad.find(params[:id])
    @contratosactnovedad.estado = params[:estado]
    @contratosactnovedad.fecha_atendido = Time.now
    @contratosactnovedad.save
    redirect_to edit_contratosactnovedad_path(etapa: "A", id: @contratosactnovedad.id), notice: "Realizada con exito"
  end

  def edit
    respond_to do |format|
      format.html { render :action => "contratosactnovedad_form" }
    end
  end

  def solicitud
    @contratosactnovedad = Contratosactnovedad.find(params[:id]) if params[:id]
    fname = "Solicitud_" + @contratosactnovedad.id.to_s rescue nil
    respond_to do |format|
      format.pdf { render pdf: "#{fname}", template: "contratosactnovedades/solicitud", encoding: "UTF-8", page_size: 'Letter', :margin => { top: 10, :bottom => 20, :left => 15, :right => 15 }, disposition: 'attachment' }
    end
  end

  # ********************************************************************************
  # ------------------- PROCESO DE GRAFICAS - 20-Abril-2022 -------------------
  # # ******************************************************************************

  # Descripcion: Graficas por estados - Seguimientos por Dia
  # Fecha Creacion: 21-Junio-2022
  # Autor: AFP
  def dash_seguimientos; end

  # Descripcion: Rake que se ejecuta cada dos horas para cargar el prcceso de dashboard
  # Fecha Creacion: 03-Julio-2022
  # Autor: AFP
  def self.rake_dash_seguimientos
    ActiveRecord::Base.connection.execute("delete from segumientoconsolidados where tipo IN ('DIA','CONSOLIDADO')")
    ["PENDIENTE", "EN PROCESO"].each do |estado|
      fch1 = ""
      Contratosactnovedad.select(["DATE_FORMAT(fecha, '%m') as mes, DATE_FORMAT(fecha, '%Y') as anno"]).where(["estado = '#{estado}'"]).distinct(["DATE_FORMAT(fecha, '%m') as mes, DATE_FORMAT(fecha, '%Y') as anno"]).order("DATE_FORMAT(fecha, '%Y') desc,  DATE_FORMAT(fecha, '%Y') desc").each do |f|
        fch1 = f.mes.to_s + '-' + f.anno.to_s
        ActiveRecord::Base.connection.execute("call prc_seguimientos('#{estado.gsub('_', ' ')}','#{fch1}', 'DIA')")
        ActiveRecord::Base.connection.execute("call prc_seguimientos('#{estado.gsub('_', ' ')}','#{fch1}', 'CONSOLIDADO')")
      end
    end
  end

  def self.rake_dash_seguimientosnodos
    ActiveRecord::Base.connection.execute("delete from seguimientonodos")
    Contratosactnovedad.select("DATE_FORMAT(fecha,'%m-%Y') as periodo").distinct.each do |p|
      Contratosactnovedad.select("nodo").distinct.each do |nodo|
        ActiveRecord::Base.connection.execute("call prc_seguimientosfiltros('#{nodo.nodo}','#{p.periodo}')")
      end
    end
  end

  # Descripcion: Graficas por estados - Seguimientos por Acumulado
  # Fecha Creacion: 21-Junio-2022
  # Autor: AFP
  def dash_seguimientosacumulado; end

  # Descripcion: Graficas por estados y nodos
  # Fecha Creacion: 04-Julio-2022
  # Autor: AFP
  def dash_seguimientosnodos; end

  def etapar
    if params[:etapa].to_s != ""
      User.where(id: is_admin).update_all(etapa: params[:etapa].to_s, updated_at: Time.now)
    end
    redirect_to contratosactnovedades_path
  end

  def etapar2
    if params[:etapa].to_s != ""
      User.where(id: is_admin).update_all(etapa: params[:etapa].to_s, updated_at: Time.now)
    end
    redirect_to indexadmin_contratosactnovedades_path
  end

  private

  def set_layout
    if ['index', 'edit'].include?(action_name)
      'inscripcion_layoutmetro'
    elsif ["dash_seguimientos", "dash_seguimientosacumulado", "dash_seguimientosnodos"].include?(action_name)
      'basicoreporte'
    else
      "application_admin"
    end
  end

  def set_contratosactnovedad
    params[:etapa].to_s != "" ? Contratosactnovedad.find(params[:id]).update_columns(etapa: params[:etapa].to_s) : nil
    @contratosactnovedad = Contratosactnovedad.find(params[:id])
  end

  def contratosactnovedad_params
    params.require(:contratosactnovedad).permit!
  end
end

