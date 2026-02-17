class PersonasformulariosdocsController < ApplicationController
  before_action :set_personasformulariosdoc, only: [:show, :destroy]
  before_action :set_personasformulariosdoc, except: [:marcar_visto,:cambioestado]

  def index
    @personasformulariosdocs = Personasformulariosdoc.all
  end

  def abrir_documento
    @parcargosdoc = Parcargosdoc.find(params[:parcargosdoc_id])
    @parcargo = @parcargosdoc.parcargo
    @personasformulario = Personasformulario.find(params[:personasformulario_id])
    @personasformulariosdoc = Personasformulariosdoc.new
  end

  def cambioestado
    @personasformulariosdoc = Personasformulariosdoc.find(params[:id])
    @personasformulariosdoc.estado = params[:estado]
    @personasformulariosdoc.user_revisa = is_admin
    @personasformulariosdoc.save(validate: false)
    redirect_to edit_personasformulario_path(etapa: 2, id: @personasformulariosdoc.personasformulario_id), notice: "Realizada con exito"
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Personasformulariosdoc.find(params[:active_id]) if params[:active_id].present?
    @personasformulario = Personasformulario.find(params[:personasformulario_id])
    @personasformulariosdoc = Personasformulariosdoc.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Personasformulariosdoc.find(params[:active_id]) if params[:active_id].present?
    @personasformulariosdoc = Personasformulariosdoc.find(params[:id])
    @personasformulario = @personasformulariosdoc.personasformulario
    respond_to { |format| format.js }
  end

  def create
    @personasformulario = Personasformulario.find(params[:personasformulario_id])
    @personasformulariosdoc = Personasformulariosdoc.new(personasformulariosdoc_params)
    @personasformulariosdoc.personasformulario_id = @personasformulario.id
    errorDoc = ""
    if @personasformulariosdoc.parcargosdoc.soloimagen.to_s == 'SI'
      if ['image/jpeg','image/png','image/pjpeg'].exclude?(@personasformulariosdoc.soporte_digital_content_type.to_s)
        errorDoc = 'SI'
      end
    end
    respond_to do |format|
      if errorDoc == 'SI'
        flash[:notice] = "El documento solo puede ser una Imagen"
        format.js { render 'layouts/errors', locals: { object: @personasformulariosdoc } }
      else
        if @personasformulariosdoc.save
          flash[:notice] = "#{t :notice_crea_msj}"
          format.js { render inline: "location.reload();" }
        else
          format.js { render 'layouts/errors', locals: { object: @personasformulariosdoc } }
        end
      end

    end
  end

  def update
    @personasformulariosdoc = Personasformulariosdoc.find(params[:id])
    @personasformulario = @personasformulariosdoc.personasformulario
    if @personasformulario.estado == 'APROBADO'
      @personasformulario.user_revisa = is_admin
    end
    respond_to do |format|
      if @personasformulariosdoc.update(personasformulariosdoc_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @personasformulariosdoc } }
      end
    end
  end

  def destroy
    @personasformulariosdoc.destroy
    respond_to do |format|
      flash['success'] = 'Eliminado correctamente'
      format.js { render inline: "location.reload();" }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_personasformulariosdoc
    @personasformulario = Personasformulario.find(params[:personasformulario_id])
    @personasformulariosdoc = Personasformulariosdoc.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def personasformulariosdoc_params
    params.require(:personasformulariosdoc).permit!
  end
end
