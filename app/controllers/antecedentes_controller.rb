class AntecedentesController < ApplicationController

  before_action :set_antecedente, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :index2, :index3, :new, :finalizado, :create]

  layout :determine_layout

  def index
  end

  def index2
  end

  def index3
  end

  def buscador
    @c = Antecedente.new
    @c.identificacion = params[:identificacion]
    @antecedentes = Antecedente.search(@c)
    if @antecedentes.count == 0
      flash[:notice] = "No hay resultados de la busqueda"
      redirect_to antecedentes_path
    else
      if @antecedentes.count == 1
        redirect_to edit_antecedente_path(id: @antecedentes.first.id, etapa: "A")
      else
        respond_to do |format|
          format.html
        end
      end
    end
  end

  # GET /antecedentes/new
  def new
    @antecedente = Antecedente.new
    @antecedente.portafolio_id = params[:portafolio_id]
    #@portafolio = params[:portafolio_id]
    @regresar = params[:regresar]
    render :action => "antecedente_form"
  end

  def edit
    respond_to do |format|
      format.html {render :action => "antecedente_form"}
    end
  end

  def finalizado
    @antecedente = Antecedente.find(params[:id])
    #@hc = "2019-09-09 23:59:59"
    #if Time.now.strftime("%Y-%m-%d %X") >= @hc
    #  @mensaje = "Recuerda que para terminar el proceso deberas de ingresar a la plataforma con tu usuario y contraseña que acabas de registrar. "
    #else
    #  @mensaje = "Has finalizado exitosamente el registro inicial, ahora con los datos registrados en la preinscripción puedes continuar
    #              el proceso ingresando al portal de la corporación."
    #end
  end

  def create
    @regresar = params[:regresa]
    @antecedente = Antecedente.new(antecedente_params)
    @regresar = @antecedente.regresar
    ident = @antecedente.identificacion.to_s
    ident = ident.to_s.strip
    ident = ident.gsub(" ","")
    ident = ident.gsub(".","")
    if ident.to_s != "" and Persona.exists?(["identificacion = '#{ident}' and portafolio_id = #{@antecedente.portafolio_id.to_i}"]) == true
      flash[:notice] = "Ya te encuentras registrado, debes ingresar con tus datos de acceso."
      redirect_to root_path
    else
      if @antecedente.save
        ident = @antecedente.identificacion.to_s
        if Persona.exists?(["identificacion = '#{ident}' and portafolio_id = #{@antecedente.portafolio_id.to_i}"]) == false
          begin
            persona = Persona.create(identificacion: ident, nombre: @antecedente.nombre.to_s, portafolio_id: @antecedente.portafolio_id).id
            if persona
              ActiveRecord::Base.connection.execute("update antecedentes set persona_id = #{persona} where id =  #{@antecedente.id} and portafolio_id = #{@antecedente.portafolio_id}")
            end
          end
        end
        if User.exists?(["upper(username) = '#{ident}' and portafolio_id = #{@antecedente.portafolio_id}"]) == false
          begin
            user = User.create(identificacion: ident, email:  ident + "@asear.esp.com", password: ident, nombre: @antecedente.nombre.to_s, tipoconsulta: 'PERSONA', portafolio_id: @antecedente.portafolio_id, username: ident, activo: 'S', etapa: 'A', persona_id: persona, celular: 0).id
            if user
              ActiveRecord::Base.connection.execute("update users set persona_id = #{persona} where id = #{user} and portafolio_id = #{@antecedente.portafolio_id}")
            end
          end
        end
        redirect_to finalizado_antecedentes_path(id: @antecedente.id)
      else
        flash[:notice] = "Se produjo un error al actualizar, debes diligenciar todos los campos obligatorios."
        render :action => "antecedente_form"
      end
    end
  end


  def update
    @antecedente = Antecedente.find(params[:id])
    if @antecedente.update_attributes(antecedente_params)
      flash[:notice] = "Actualizado con Exito"
      redirect_to edit_antecedente_path(@antecedente)
      #redirect_to finalizado_aantecedentes_path(id: @aantecedente.id)
    else
      flash[:notice] = "Se produjo un error al actualizar, debes diligenciar todos los campos obligatorios."
      render :action => "antecedente_form"
    end
    #rescue
    #  redirect_to edit_aantecedente_path(@aantecedente)
  end

  def destroy
    @antecedente.destroy
    respond_to do |format|
      format.html {redirect_to antecedentes_url, notice: 'Antecedente was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  private

  def set_antecedente
    @antecedente = Antecedente.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def antecedente_params
    params.require(:antecedente).permit!
  end

  def determine_layout
    if ['edit', 'update'].include?(action_name)
      "antecedente_layout"
    elsif ['perido20182'].include?(action_name)
      'application'
    elsif ['consolidado'].include?(action_name)
      'excel'
    else
      "inscripcion_layout"
    end
  end
end
