class EncuestasController < ApplicationController
  before_action :set_encuesta, only: [:show, :edit, :update, :destroy]

  layout :set_layout
  #before_action :checkaccess

  def checkaccess
    return is_permit('encuestas')
  end

  def index
    @encuestas = Encuesta.all
  end

  def new
    @encuesta = Encuesta.new
    render "encuesta_form"
  end

  def edit
    respond_to do |format|
      format.html { render :action => "encuesta_form" }
    end
  end

  def create
    @encuesta = Encuesta.new(encuesta_params)
    respond_to do |format|
      if @encuesta.save
        format.html { redirect_to edit_encuesta_path(id: @encuesta.id), notice: "El registro ha sido registrado con Exito." }
        format.json { render :show, status: :created, location: @encuesta }
      else
        format.html { render :action => "encuesta_form" }
        format.json { render json: @encuesta.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @encuesta.update(encuesta_params)
      flash['success'] = "Usuario actualizado"
      redirect_to edit_encuesta_path(id: @encuesta.id)
    else
      render "encuesta_form"
    end
  end

  def destroy
    @encuesta.destroy
    flash[:notice] = "El registro ha sido borrado con Exito."
    respond_to do |format|
      format.html { redirect_to(encuestas_url) }
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

  def set_encuesta
    @encuesta = Encuesta.find(params[:id])
  end

  def encuesta_params
    params.require(:encuesta).permit!
  end
end
