class InsumosController < ApplicationController
  before_action :set_insumo, only: [:show, :edit, :update, :destroy]

  layout :set_layout
  #before_action :checkaccess

  def checkaccess
    return is_permit('insumos')
  end

  def fichas
    @insumo = Insumo.find(params[:id])
  end

  def search
    @insumos = Insumo.where("tipo = 'CONSUMO' and clase = 'GENERAL' and estado = 'ACTIVO' and bien_servicio LIKE ?", "%#{replacespace(params[:q]).upcase}%").limit(10)
    respond_to do |format|
      format.json {render json: @insumos.map {|p| {id: p.id, name: "#{p.insumodetalle}"}}}
    end
  end

  def index
    msj = ""
    clase = params[:ubicacion][:clase].to_s rescue nil
    if params[:bien_servicio].to_s != "" and clase.to_s != ""
      msj ="No hay resultados de la consulta"
    end
    nroreg = 10
    @insumos = Insumo.search(params[:bien_servicio],clase,params[:page],nroreg)
    if @insumos.count.to_i == 0
      flash[:warning] = "No hay resultados de la consulta!!!"
    else
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @insumos }
      end
    end
  end

  def new
    @insumo = Insumo.new
    render "insumo_form"
  end

  def edit
    #@contratos = Contrato.where(insumo_id: @insumo.id).all.order("fecha_inicio desc")
    #@vehiculos = Vehiculo.where(["id in (select distinct vehiculo_id from vehiculostramites where id in (select vehiculostramite_id from vehiculostinsumos where insumo_id = #{@insumo.id}))"]).all.order("id desc")
    respond_to do |format|
      format.html { render :action => "insumo_form" }
    end
  end

  def create
    @insumo = Insumo.new(insumo_params)
    @insumo.user_id = is_admin
    respond_to do |format|
      if @insumo.save
        format.html { redirect_to edit_insumo_path(etapa: "A", id: @insumo.id), notice: "El registro ha sido registrado con Exito." }
        format.json { render :show, status: :created, location: @insumo }
      else
        format.html { render :action => "insumo_form" }
        format.json { render json: @insumo.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @insumo.user_act = is_admin
    if @insumo.update(insumo_params)
      flash['success'] = "Usuario actualizado"
      redirect_to edit_insumo_path(id: @insumo.id, etapa: 'A')
    else
      render "insumo_form"
    end
  end

  def destroy
    @insumo.destroy
    flash[:notice] = "El registro ha sido borrado con Exito."
    respond_to do |format|
      format.html { redirect_to(insumos_url) }
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

  def set_insumo
    @insumo = Insumo.find(params[:id])
  end

  def insumo_params
    params.require(:insumo).permit!
  end
end
