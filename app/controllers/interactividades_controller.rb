class InteractividadesController < ApplicationController
  # before_filter :require_user
  before_action :set_interactividad, only: [:show, :edit, :update, :destroy]
  layout :determine_layout


  def index
    @interactividades = Interactividad.search(params[:search], params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @interactividades }
    end
  end

  def show
    respond_to { |format| format.js }
  end
  def new
    # @interactividad = Interactividad.new
    # render :action => "interactividad_form"
    @active_record = Interactividad.find(params[:active_id]) if params[:active_id].present?
    @interventoria = Interventoria.find(params[:interventoria_id])
    @interactividad = Interactividad.new
    respond_to { |format| format.js }
  end

  def edit
    # @interactividad = Interactividad.find(params[:id])
    # respond_to do |format|
    #   format.html { render :action => "interactividad_form" }
    # end

    @active_record = Interactividad.find(params[:active_id]) if params[:active_id].present?
    @interactividad = Interactividad.find(params[:id])
    @interventoria = @interactividad.interventoria
    respond_to { |format| format.js }
  end

  def siguiente
    @interactividad = Interactividad.find_by_interventoria_id_and_consecutivo(params[:id], params[:consecutivo])
    redirect_to edit_interactividad_path(@interactividad)
  end

  def create
    # @interactividad = Interactividad.new(params[:interactividad])
    # if @interactividad.save
    #   flash[:notice] = "El registro ha sido registrado con Exito."
    #   redirect_to edit_interactividad_path(@interactividad)
    # else
    #   render :action => "interactividad_form"
    # end
    @interventoria = Interventoria.find(params[:interventoria_id])
    @interactividad = Interactividad.new(interactividad_params)
    @interactividad.interventoria_id = @interventoria.id
    @interactividad.user_id = is_admin.id
    respond_to do |format|
      if @interactividad.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @interactividad } }
      end
    end
  end

  def update
    # @interactividad = Interactividad.find(params[:id])
    # if @interactividad.update_attributes(params[:interactividad])
    #   flash[:notice] = "El registro ha sido actualizado con Exito."
    #   redirect_to edit_interactividad_path(@interactividad)
    # else
    #   render :action => "interactividad_form"
    # end
    # rescue
    #   redirect_to edit_interactividad_path(@interactividad)
    respond_to do |format|
      if @interactividad.update(interactividad_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @interactividad } }
      end
    end
  end

  def cargue_documentos
    @interactividad = Interactividad.find(params[:interactividad_id])
    @interventoria = @interactividad.interventoria
    @interactimagen = Interactimagen.new
  end

  def cargue_observaciones
    @interactividad = Interactividad.find(params[:interactividad_id])
    @interventoria = @interactividad.interventoria
    @interactobservacion = Interactobservacion.new
  end

  def destroy
    @interactividad.destroy
    respond_to do |format|
      flash['success'] = I18n.t('notifications.records.destroy')
      format.js
    end
  end

  def update_observation
    @interactividad = Interactividad.find(params[:id])
    if @interactividad.update(desarrollo: params[:desarrollo].to_s.upcase)
      render json: { status: 'success', message: 'Desarrollo actualizada correctamente', desarrollo: @interactividad.desarrollo }
    else
      render json: { status: 'error', message: 'Error al actualizar la observación' }
    end
  end

  private
  def determine_layout
    if ['actaaprobacionobra'].include?(action_name)
      "atencion"
    elsif['informeoperador','informefinanciero','informeactualizacion','informepersonal','informecomuna','informeconcepto','informeseguimiento'].include?(action_name)
      "excel"
    else
      "application"
    end
  end

  def set_interactividad
    @interventoria = Interventoria.find(params[:interventoria_id])
    @interactividad = Interactividad.find(params[:id]) if params[:id]
  end
  def interactividad_params
    params.require(:interactividad).permit!
    end
end
