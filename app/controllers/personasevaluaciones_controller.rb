class PersonasevaluacionesController < ApplicationController
  before_action :set_personasevaluacion, only: [:show, :edit, :update, :destroy]

  layout :determine_layout

  before_action :checkaccess, only: [:new,:create], if: :user_signed_in?
  #Restriccion
  #6-8:30
  #5:00 a 9:00 pm
  def checkaccess
    #if is_persona == true
      @existeHoy = ""
      if is_personaadmin == 'A'
        if Time.now.strftime('%H:%M').to_s >= '00:01' and Time.now.strftime('%H:%M').to_s <= '08:30'
          @existeHoy = Personasevaluacion.where(["persona_id = #{is_personaid} and date(created_at) = date(now()) and DATE_FORMAT(created_at,'%%H') < '12'"]).exists?
        elsif Time.now.strftime('%H:%M').to_s >= '17:00' and Time.now.strftime('%H:%M').to_s <= '22:00'
          @existeHoy = Personasevaluacion.where(["persona_id = #{is_personaid} and date(created_at) = date(now()) and DATE_FORMAT(created_at,'%%H') >= '12'"]).exists?
        elsif Time.now.strftime("%A").upcase == 'SATURDAY' and Time.now.strftime('%H:%M').to_s >= '12:10' and Time.now.strftime('%H:%M').to_s <= '14:30'
          @existeHoy = Personasevaluacion.where(["persona_id = #{is_personaid} and date(created_at) = date(now()) and DATE_FORMAT(created_at,'%%H') >= '12'"]).exists?
        else
          @existeHoy = true
        end
        if @existeHoy
          flash[:notice] = "Evaluacion diaria YA registrada o NO realizada en el tiempo habilitado.."
          redirect_to root_path
        end
      else
        if Time.now.strftime('%H').to_s < '12'
          @existeHoy = Personasevaluacion.where(["persona_id = #{is_personaid} and date(created_at) = date(now()) and DATE_FORMAT(created_at,'%%H') < '12'"]).exists?
        elsif Time.now.strftime('%H') >= '12'
          @existeHoy = Personasevaluacion.where(["persona_id = #{is_personaid} and date(created_at) = date(now()) and DATE_FORMAT(created_at,'%%H') >= '12'"]).exists?
        end
        if @existeHoy
          flash[:notice] = "Evaluacion diaria YA registrada con Exito."
          redirect_to root_path
        end
      end
    #end
  end

  def index
     #@personasevaluaciones = Personasevaluacion.all
  end

  def new
    @personasevaluacion = Personasevaluacion.new
    @personasevaluacion.persona_id = params[:persona_id].to_i
    render "personasevaluacion_form"
  end

  def edit
    respond_to do |format|
      format.html { render :action => "personasevaluacion_form" }
    end
  end

  def show

  end

  def create
    #if is_persona == true
      @existeHoy = ""
      if Time.now.strftime('%H').to_s < '12'
        @existeHoy = Personasevaluacion.where(["persona_id = #{is_personaid} and date(created_at) = date(now()) and DATE_FORMAT(created_at,'%%H') < '12'"]).exists?
      elsif Time.now.strftime('%H') >= '12'
        @existeHoy = Personasevaluacion.where(["persona_id = #{is_personaid} and date(created_at) = date(now()) and DATE_FORMAT(created_at,'%%H') >= '12'"]).exists?
      end
      if @existeHoy
        flash[:notice] = "Evaluacion diaria YA registrada con Exito."
        redirect_to root_path
      else
        @personasevaluacion = Personasevaluacion.new(personasevaluacion_params)
        if @personasevaluacion.save
          ActiveRecord::Base.connection.execute("CALL validacion")
          flash[:notice] = "Evaluacion diaria registrada con Exito."
          redirect_to root_path
        else
          render action: "personasevaluacion_form"
        end
      end
    #end
  end

  def update
    if @personasevaluacion.update(personasevaluacion_params)
      flash[:notice] = "El registro ha sido actualizado con Exito."
      redirect_to edit_personasevaluacion_path(@personasevaluacion)
    else
      render "personasevaluacion_form"
    end
  end

  def destroy
    @personasevaluacion.destroy
    flash[:notice] = "El registro ha sido borrado con Exito."
    respond_to do |format|
      format.html { redirect_to(personasevaluaciones_url) }
      format.xml  { head :ok }
    end
  end

  def calificar
    @personasevaluacion = Personasevaluacion.find(params[:id])
    @personasevaluacion.descartado = 'SI'
    @personasevaluacion.user_descarta = is_admin
    @personasevaluacion.save
    redirect_to root_path
  end

  private
    def set_personasevaluacion
      @personasevaluacion = Personasevaluacion.find(params[:id])
    end

    def personasevaluacion_params
      params.require(:personasevaluacion).permit!
    end

  def determine_layout
    if ['edit', 'update'].include?(action_name)
      "antecedente_layout"
    elsif ['index', 'perido20182'].include?(action_name)
      'application'
    elsif ['consolidado'].include?(action_name)
      'excel'
    else
      "inscripcion_layout"
    end
  end
end
