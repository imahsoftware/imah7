# app/controllers/interactividades_controller.rb
class InteractividadesController < ApplicationController
  before_action :set_interactividad, only: [:show, :edit, :update, :destroy]
  layout 'application_interventorias'

  # ── SHOW ─────────────────────────────────────────────────────────────────
  def show
    respond_to { |format| format.js }
  end

  # ── NEW ──────────────────────────────────────────────────────────────────
  def new
    @active_record = Interactividad.find(params[:active_id]) if params[:active_id].present?
    @interventoria  = Interventoria.find(params[:interventoria_id])
    @interactividad = Interactividad.new
    respond_to { |format| format.js }
  end

  # ── EDIT ─────────────────────────────────────────────────────────────────
  def edit
    @active_record  = Interactividad.find(params[:active_id]) if params[:active_id].present?
    @interactividad = Interactividad.find(params[:id])
    @interventoria  = @interactividad.interventoria
    respond_to { |format| format.js }
  end

  # ── CREATE ────────────────────────────────────────────────────────────────
  def create
    @interventoria  = Interventoria.find(params[:interventoria_id])
    @interactividad = @interventoria.interactividades.build(interactividad_params)
    @interactividad.user_id      = is_admin.id
    @interactividad.consecutivo  = (@interventoria.interactividades.maximum(:consecutivo) || 0) + 1

    respond_to do |format|
      if @interactividad.save
        @interventoria.registrar_bitacora(is_admin.id, "NUEVA OBLIGACIÓN: #{@interactividad.actividad.truncate(60)}")
        flash[:notice] = t(:notice_crea_msj)
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @interactividad } }
      end
    end
  end

  # ── UPDATE ────────────────────────────────────────────────────────────────
  def update
    respond_to do |format|
      if @interactividad.update(interactividad_params)
        flash[:notice] = t(:notice_actualiza_msj)
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @interactividad } }
      end
    end
  end

  # ── DESTROY ───────────────────────────────────────────────────────────────
  def destroy
    @interventoria = @interactividad.interventoria
    @interactividad.destroy
    # Renumerar consecutivos
    @interventoria.interactividades.order(:consecutivo).each_with_index do |ia, i|
      ia.update_column(:consecutivo, i + 1)
    end
    respond_to do |format|
      flash[:success] = t('notifications.records.destroy')
      format.js
    end
  end

  # ── UPDATE_OBSERVATION (AJAX autoguardado) ────────────────────────────────
  def update_observation
    @interactividad = Interactividad.find(params[:id])
    desarrollo = params[:desarrollo].to_s.upcase.strip

    if @interactividad.update(desarrollo: desarrollo)
      render json: { status: 'success', desarrollo: @interactividad.desarrollo }
    else
      render json: { status: 'error', message: 'Error al guardar' }, status: :unprocessable_entity
    end
  end

  # ── CARGUE DE DOCUMENTOS (modal) ──────────────────────────────────────────
  def cargue_documentos
    @interactividad = Interactividad.find(params[:interactividad_id])
    @interventoria  = @interactividad.interventoria
    @interactimagen = Interactimagen.new
    respond_to do |format|
      format.js   # → cargue_documentos.js.erb
      format.html { render partial: 'interactividades/cargar_documentos' }
    end
  end

  # ── CARGUE DE OBSERVACIONES (modal) ───────────────────────────────────────
  def cargue_observaciones
    @interactividad      = Interactividad.find(params[:interactividad_id])
    @interventoria       = @interactividad.interventoria
    @interactobservacion = Interactobservacion.new
    # Detectar si viene desde revisioninter para renderizar fila correcta al guardar
    @contexto = request.referer.to_s.include?('revisioninter') ? 'supervisor' : 'contratista'
    respond_to do |format|
      format.js
      format.html { render partial: 'interactividades/cargar_observaciones' }
    end
  end

  private

  def set_interactividad
    @interventoria  = Interventoria.find(params[:interventoria_id])
    @interactividad = Interactividad.find(params[:id]) if params[:id]
  end

  def interactividad_params
    params.require(:interactividad).permit!
  end
end
