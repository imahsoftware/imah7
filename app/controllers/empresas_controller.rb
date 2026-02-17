class EmpresasController < ApplicationController
  before_action :set_empresa, only: [:show, :edit, :update, :destroy]

  layout :set_layout
  before_action :checkaccess

  def checkaccess
    return is_permit('empresas')
  end

  def search
    @empresas = Empresa.where("nombre LIKE ?", "%#{replacespace(params[:q]).upcase}%").limit(10)
    respond_to do |format|
      format.json { render json: @empresas.map { |p| { id: p.id, name: "#{p.autobuscar}" } } }
    end
  end

  def index
    isadmin = is_admin
    validacion = ""
    if isadmin != 15910 and isadmin != 4561
      dato = Objeto.find_by_sql("SELECT DISTINCT 'X' existe FROM viw_consolidabloqueo WHERE user_id = #{isadmin}")[0] rescue nil
    end
    if dato.present?
      flash[:warning] = 'Hola!!! Para donde vas si no has terminado los temas pendientes'
      redirect_to root_path
    else
      prefactura = params[:prefactura].to_s rescue nil
      @recibo = params[:recibo].to_s rescue nil
      if params[:identificacion].to_s != "" or params[:nombre].to_s != "" or @recibo != "" or prefactura != ""
        @empresas = Empresa.search(params[:identificacion], params[:nombre], params[:page], 10, prefactura, @recibo)
      else
        @empresas = Empresa.where(identificacion: -1)
      end
      respond_to do |format|
        @empresas.present? ?
          flash[:notice] = "Total de registros encontrados #{@empresas.count}" :
          flash[:notice] = "No hay resultado de la busqueda"
        format.js
        format.html
      end
    end
  end

  def new
    @empresa = Empresa.new
    @empresa.etapa = 'A'
    render "empresa_form"
  end

  def edit
    begin
      @contratos = Contrato.where(empresa_id: @empresa.id).all.order("fecha_inicio desc")
      respond_to do |format|
        format.html { render :action => "empresa_form" }
      end
    rescue => e
      # Bugsnag.notify(e)
      flash[:error] = "Ha ocurrido un error en create"
    end
  end

  def create
    @empresa = Empresa.new(empresa_params)
    @empresa.etapa = 'A'
    @empresa.user_id = is_admin
    respond_to do |format|
      if @empresa.save
        format.html { redirect_to edit_empresa_path(etapa: "A", id: @empresa.id), notice: "El registro ha sido registrado con Exito." }
        format.json { render :show, status: :created, location: @empresa }
      else
        format.html { render :action => "empresa_form" }
        format.json { render json: @empresa.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @empresa.user_act = is_admin
    if @empresa.update(empresa_params)
      flash['success'] = "Usuario actualizado"
      redirect_to edit_empresa_path(id: @empresa.id, etapa: 'A')
    else
      render "empresa_form"
    end
  end

  def destroy
    @empresa.destroy
    flash[:notice] = "El registro ha sido borrado con Exito."
    respond_to do |format|
      format.html { redirect_to(empresas_url) }
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

  def set_empresa
    params[:etapa].to_s != "" ? Empresa.find(params[:id]).update_columns(etapa: params[:etapa].to_s) : nil
    @empresa = Empresa.find(params[:id])
  end

  def empresa_params
    params.require(:empresa).permit!
  end
end
