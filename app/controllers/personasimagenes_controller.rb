class PersonasimagenesController < ApplicationController
  before_action :set_personasimagen, only: [:show, :destroy]

  def index
    @personasimagenes = Personasimagen.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Personasimagen.find(params[:active_id]) if params[:active_id].present?
    @persona = Persona.find(params[:persona_id])
    @personasimagen = Personasimagen.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Personasimagen.find(params[:active_id]) if params[:active_id].present?
    @personasimagen = Personasimagen.find(params[:id])
    @persona = @personasimagen.persona
    respond_to { |format| format.js }
  end

  def create
    @persona  = Persona.find(params[:persona_id])
    @personasimagen = Personasimagen.new(personasimagen_params)
    @personasimagen.persona_id = @persona.id
    @personasimagen.user_id = is_admin
    respond_to do |format|
      if @personasimagen.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @personasimagen } }
      end
    end
  end

  def update
    @personasimagen = Personasimagen.find(params[:id])
    @persona = @personasimagen.persona
    respond_to do |format|
      if @personasimagen.update(personasimagen_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @personasimagen } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @personasimagen.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_personasimagen
    @persona = Persona.find(params[:persona_id])
    @personasimagen = Personasimagen.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def personasimagen_params
    params.require(:personasimagen).permit!
  end
end
