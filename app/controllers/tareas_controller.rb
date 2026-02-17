class TareasController < ApplicationController
  before_action :set_tarea, only: [:show, :edit, :update, :destroy]

  layout :set_layout
  #before_action :checkaccess

  def checkaccess
    return is_permit('tareas')
  end

  def clonar
    @tarea = Tarea.find(params[:id])
    ActiveRecord::Base.connection.execute("CALL prc_duplicar_tarea(#{@tarea.id},'D')")
    respond_to do |format|
      flash[:notice] = "Tarea Clonada con Exito!!!"
      format.js { render inline: "location.reload();" }
    end
  end

  def gestion
    puts "Fabian... #{request.path.to_s}"
    idTarea =  User.find(is_admin).subetapa.to_i rescue nil
    if idTarea.present?
      @tareas = Tarea.select("tareas.*, (select count(id) from tareasactividades where tarea_id = tareas.id and estado = '0') pendientes,
                           (select count(id) from tareasactividades where tarea_id = tareas.id and estado = '0.5') procesos,
                           (select count(id) from tareasactividades where tarea_id = tareas.id and estado = '1.0') noaplica,
                           (select count(id) from tareasactividades where tarea_id = tareas.id and estado = '1') finalizadas ,
                           (select count(id) from tareasactividades where tarea_id = tareas.id) total,
                           (select sum(ifnull(estado,0)) from tareasactividades where tarea_id = tareas.id) sumtotal")
                  .where(id: idTarea)
    end
  end

  def cargar
    @tareasactividad = Tareasactividad.find(params[:id])
    @tareasactdoc = Tareasactdoc.new
  end

  def ver_grafica_general
    @tarea = Tarea.find(params[:id])
    @pendientes = @tarea.tareasactividades.where("estado = '0'").count rescue 0
    @procesos = @tarea.tareasactividades.where("estado = '0.5'").count rescue 0
    @finalizados = @tarea.tareasactividades.where("estado in ('1','1.0')").count rescue 0
  end

  def ver_grafica_usuarios
    @tarea = Tarea.find(params[:id])
  end


  def mostrar_monday
    @usuario = params[:user_persona] rescue nil
    @ruta = params[:ruta] rescue nil
    @showmonday = params[:tarea_id].to_s + '_' +params[:user_persona].to_s rescue nil
    @tarea = Tarea.find(params[:tarea_id])
  end

  def index
    @tareas = Tarea.all.order("fecha desc")
  end

  def new
    @tarea = Tarea.new
    render "tarea_form"
  end

  def edit
    respond_to do |format|
      format.html { render :action => "tarea_form" }
    end
  end

  def create
    @tarea = Tarea.new(tarea_params)
    respond_to do |format|
      if @tarea.save
        format.html { redirect_to edit_tarea_path(id: @tarea.id), notice: "El registro ha sido registrado con Exito." }
        format.json { render :show, status: :created, location: @tarea }
      else
        format.html { render :action => "tarea_form" }
        format.json { render json: @tarea.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @tarea.update(tarea_params)
      flash['success'] = "Usuario actualizado"
      ActiveRecord::Base.connection.execute("CALL prc_duplicar_tarea(#{@tarea.id},'R')")
      redirect_to edit_tarea_path(id: @tarea.id)
    else
      render "tarea_form"
    end
  end

  def destroy
    @tarea.destroy
    flash[:notice] = "El registro ha sido borrado con Exito."
    respond_to do |format|
      flash[:notice] = "Tarea Eliminado con Exito!!!"
      format.js { render inline: "location.reload();" }
    end
  end

  def detec
    idTarea = params[:id]
    User.find(is_admin).update_columns(subetapa: idTarea.to_s)
    redirect_to gestion_tareas_path
  end

  private

  def set_layout
    if ['index', 'new'].include?(action_name)
      'application_admin'
    elsif ['edit'].include?(action_name)
      'application_admin'
    elsif ['gestion'].include?(action_name)
      'application_tareas'
    else
      "application_admin"
    end
  end

  def set_tarea
    @tarea = Tarea.find(params[:id])
  end

  def tarea_params
    params.require(:tarea).permit!
  end
end
