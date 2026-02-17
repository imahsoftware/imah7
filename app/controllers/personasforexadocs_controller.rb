class PersonasforexadocsController < ApplicationController
  before_action :set_personasforexadoc, only: [:show, :destroy]

  def index
    @personasforexadocs = Personasforexadoc.all
  end

  def abrir_documento
    @personasformulariosexamen = Personasformulariosexamen.find(params[:id])
    @personasforexadoc = Personasforexadoc.new
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Personasforexadoc.find(params[:active_id]) if params[:active_id].present?
    @personasformulariosexamen = Personasformulariosexamen.find(params[:personasformulariosexamen_id])
    @personasforexadoc = Personasforexadoc.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Personasforexadoc.find(params[:active_id]) if params[:active_id].present?
    @personasforexadoc = Personasforexadoc.find(params[:id])
    @personasformulariosexamen = @personasforexadoc.personasformulariosexamen
    respond_to { |format| format.js }
  end

  def create
    @personasformulariosexamen = Personasformulariosexamen.find(params[:personasformulariosexamen_id])
    @personasforexadoc = Personasforexadoc.new(personasforexadoc_params)
    @personasforexadoc.personasformulariosexamen_id = @personasformulariosexamen.id
    respond_to do |format|
      if @personasforexadoc.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @personasforexadoc } }
      end
    end
  end

  def update
    @personasforexadoc = Personasforexadoc.find(params[:id])
    @personasformulariosexamen = @personasforexadoc.personasformulariosexamen
    respond_to do |format|
      if @personasforexadoc.update(personasforexadoc_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @personasforexadoc } }
      end
    end
  end

  def destroy
    @personasforexadoc.destroy
    respond_to do |format|
      flash['success'] = 'Eliminado correctamente'
      format.js { render inline: "location.reload();" }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_personasforexadoc
    @personasformulariosexamen = Personasformulariosexamen.find(params[:personasformulariosexamen_id])
    @personasforexadoc = Personasforexadoc.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def personasforexadoc_params
    params.require(:personasforexadoc).permit!
  end
end
