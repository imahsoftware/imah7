class ParcargosController < ApplicationController
  before_action :set_parcargo, only: [:show, :edit, :update, :destroy]

  layout :set_layout
  #before_action :checkaccess

  def checkaccess
    return is_permit('parcargos')
  end

  def index
    @parcargos = Parcargo.all
  end

  def replicar
    @parcargo = Parcargo.find(params[:id])
    parcargo = Parcargo.new
    parcargo.descripcion = @parcargo.descripcion.to_s + ' - DUPLICADO'
    parcargo.observacion = @parcargo.observacion
    parcargo.save
    isadmin = is_admin
    ActiveRecord::Base.connection.execute("insert into parcargosdocs (parcargo_id,user_id,descripcion,obligatorio,observacion,estado,created_at,updated_at,soloimagen)
                                           select #{parcargo.id},#{isadmin},descripcion,obligatorio,observacion,estado,now(),now(),soloimagen
                                           from parcargosdocs where parcargo_id = #{@parcargo.id}")
    redirect_to edit_parcargo_path(id: parcargo.id), notice: "El registro ha sido duplicado con Exito."
  end

  def new
    @parcargo = Parcargo.new
    render "parcargo_form"
  end

  def edit
    #@contratos = Contrato.where(parcargo_id: @parcargo.id).all.order("fecha_inicio desc")
    #@vehiculos = Vehiculo.where(["id in (select distinct vehiculo_id from vehiculostramites where id in (select vehiculostramite_id from vehiculostparcargos where parcargo_id = #{@parcargo.id}))"]).all.order("id desc")
    respond_to do |format|
      format.html { render :action => "parcargo_form" }
    end
  end

  def create
    @parcargo = Parcargo.new(parcargo_params)
    @parcargo.user_id = is_admin
    @parcargo.portafolio_id = is_portafolio
    respond_to do |format|
      if @parcargo.save
        format.html { redirect_to edit_parcargo_path(id: @parcargo.id), notice: "El registro ha sido registrado con Exito." }
        format.json { render :show, status: :created, location: @parcargo }
      else
        format.html { render :action => "parcargo_form" }
        format.json { render json: @parcargo.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @parcargo.update(parcargo_params)
      flash['success'] = "Usuario actualizado"
      redirect_to edit_parcargo_path(id: @parcargo.id)
    else
      render "parcargo_form"
    end
  end

  def destroy
    @parcargo.destroy
    flash[:notice] = "El registro ha sido borrado con Exito."
    respond_to do |format|
      format.html { redirect_to(parcargos_url) }
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

  def set_parcargo
    @parcargo = Parcargo.find(params[:id])
  end

  def parcargo_params
    params.require(:parcargo).permit!
  end
end
