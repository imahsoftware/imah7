class EntradasController < ApplicationController
  before_action :set_entrada, only: [:show, :edit, :update, :destroy]

  layout :set_layout
  #before_action :checkaccess

  def checkaccess
    return is_permit('entradas')
  end

  def index
    msj = ""
    if params[:format] == 'xlsx'
      nroreg = 100000
    else
      nroreg = 10
    end
    @entradas = Entrada.search(params[:nombre],params[:identificacion],params[:fchinicio],params[:fchfin],is_portafolio,params[:page],nroreg)

    if @entradas.count.to_i == 0
      flash[:warning] = "No hay resultados de la consulta!!!"
    else
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @entradas }
        format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="Registro_'+"#{Time.now.strftime("%Y%m%d_%X")}"+'.xlsx"'}
      end
    end
  end

  def buscador
    identi = params[:identificacion].to_s.strip
    if identi != ""
      @entrada = Entrada.where(identificacion: identi).last rescue nil
      if @entrada
        flash[:success] = "Identificacion encontrada!!!"
        redirect_to new_entrada_path(identificacion: identi, nombre: @entrada.nombre, barrio_id: @entrada.barrio_id, celular: @entrada.celular, clase: @entrada.clase, portafolio_id: @entrada.portafolio_id)
      else
        flash[:warning] = "La identificacion No se encuentra!!!"
        redirect_to new_entrada_path(identificacion: identi)
      end
    end
  end

  def new
    @entrada = Entrada.new
    if params[:identificacion].to_s != ""
      @entrada.identificacion = params[:identificacion].to_s
    end
    if params[:nombre].to_s != ""
      @entrada.nombre = params[:nombre].to_s
      @entrada.barrio_id = params[:barrio_id].to_s
      @entrada.celular = params[:celular].to_s
      @entrada.clase = params[:clase].to_s
      @entrada.portafolio_id = params[:portafolio_id].to_s
    end
    render "entrada_form"
  end

  def edit
    respond_to do |format|
      format.html { render :action => "entrada_form" }
    end
  end

  def create
    @entrada = Entrada.new(entrada_params)
    ident = @entrada.identificacion.to_s
    ident = ident.to_s.strip
    ident = ident.gsub(" ","")
    ident = ident.gsub(".","")
    @entrada.user_id = is_admin
    if @entrada.save
      flash[:notice] = "Creado con exito"
      redirect_to buscador_entradas_path
    else
      flash[:notice] = "Se produjo un error al actualizar, debes diligenciar todos los campos obligatorios."
      render :action => "entrada_form"
    end
  end

  def update
    if @entrada.update(entrada_params)
      flash['success'] = "Usuario actualizado"
      redirect_to edit_entrada_path(id: @entrada.id, etapa: 'A')
    else
      render "entrada_form"
    end
  end

  def destroy
    @entrada.destroy
    flash[:notice] = "El registro ha sido borrado con Exito."
    respond_to do |format|
      format.html { redirect_to(entradas_url) }
      format.xml { head :ok }
    end
  end

  private

  def set_layout
    if ['index'].include?(action_name)
      'application_admin'
    elsif ['edit'].include?(action_name)
      'application_entradas'
    else
      "entrada_layout"
    end
  end

  def set_entrada
    @entrada = Entrada.find(params[:id])
  end

  def entrada_params
    params.require(:entrada).permit!
  end
end
