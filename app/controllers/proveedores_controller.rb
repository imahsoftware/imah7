class ProveedoresController < ApplicationController
  before_action :set_proveedor, only: [:show, :edit, :update, :destroy]

  layout :set_layout
  #before_action :checkaccess

  def checkaccess
    return is_permit('proveedores')
  end

  def search
    @proveedores = Proveedor.where("nombre LIKE ?", "%#{replacespace(params[:q]).upcase}%").limit(10)
    respond_to do |format|
      format.json {render json: @proveedores.map {|p| {id: p.id, name: "#{p.autobuscar}"}}}
    end
  end

  def index
    msj = ""
    if params[:identificacion].to_s != "" or params[:nombre].to_s != ""
      msj ="No hay resultados de la consulta"
    end
    nroreg = 10
    @proveedores = Proveedor.search(params[:identificacion],params[:nombre],params[:page],nroreg)
    if @proveedores.count.to_i == 0
      flash[:warning] = "No hay resultados de la consulta!!!"
    else
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @proveedores }
      end
    end
  end


  def new
    @proveedor = Proveedor.new
    @proveedor.etapa = 'A'
    render "proveedor_form"
  end

  def edit
    #@contratos = Contrato.where(proveedor_id: @proveedor.id).all.order("fecha_inicio desc")
    respond_to do |format|
      format.html { render :action => "proveedor_form" }
    end
  end

  def create
    @proveedor = Proveedor.new(proveedor_params)
    @proveedor.etapa = 'A'
    @proveedor.user_id = is_admin
    respond_to do |format|
      if @proveedor.save
        format.html { redirect_to edit_proveedor_path(etapa: "A", id: @proveedor.id), notice: "El registro ha sido registrado con Exito." }
        format.json { render :show, status: :created, location: @proveedor }
      else
        format.html { render :action => "proveedor_form" }
        format.json { render json: @proveedor.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @proveedor.user_act = is_admin
    if @proveedor.update(proveedor_params)
      flash['success'] = "Usuario actualizado"
      redirect_to edit_proveedor_path(id: @proveedor.id, etapa: 'A')
    else
      render "proveedor_form"
    end
  end

  def destroy
    @proveedor.destroy
    flash[:notice] = "El registro ha sido borrado con Exito."
    respond_to do |format|
      format.html { redirect_to(proveedores_url) }
      format.xml  { head :ok }
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

  def set_proveedor
    params[:etapa].to_s != "" ? Proveedor.find(params[:id]).update_columns(etapa: params[:etapa].to_s) : nil
    @proveedor = Proveedor.find(params[:id])
  end

  def proveedor_params
    params.require(:proveedor).permit!
  end
end
