class VisitasdocsController < ApplicationController
  before_action :set_visitasdoc, only: [:show, :destroy]
  #
  def index
    @visitasdocs = Visitasdoc.all
  end

  def captura
    @visita = Visita.find(params[:visita_id])
    @image = Visitasdoc.new
  end

  def captura_trasera
    @visita = Visita.find(params[:visita_id])
    @image = Visitasdoc.new
  end


  def captura_imagen
    @visita = Visita.find(params[:visita_id])

    data = params[:image][:image_data]
    image_data = Base64.decode64(data)
    new_file = File.new("public/webcam/captura_doc_visita_#{@visita.id}.png", 'wb')
    new_file.write(image_data)
    file = File.open(new_file, 'rb')

    @visitasdoc = Visitasdoc.new(
      visita_id: @visita.id,
      user_id: current_user.id, # Asegúrate de usar el método correcto para obtener el ID del usuario actual
      tipo: "CAPTURA IMAGEN",
      docvisita: file
    )

    if @visitasdoc.save(validate: false)
      antes_exists = @visita.visitasdocs.exists?(tipo: 'CAPTURA IMAGEN')
      redirect_path = complementar_visitas_path(etapa: 'C', id: @visita.id)
      render json: { success: true, antesExists: antes_exists, redirect_path: redirect_path } and return
    else
      render json: { success: false, message: "Error al guardar la imagen." }, status: :unprocessable_entity
    end
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Visitasdoc.find(params[:active_id]) if params[:active_id].present?
    @visita = Visita.find(params[:visita_id])
    @visitasdoc = Visitasdoc.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Visitasdoc.find(params[:active_id]) if params[:active_id].present?
    @visitasdoc = Visitasdoc.find(params[:id])
    @visita = @visitasdoc.visita
    respond_to { |format| format.js }
  end

  def create2
    @visitascompromiso = Visitascompromiso.find(params[:id])
    @visitasdoc = Visitasdoc.new(visitasdoc_params)
    @visitasdoc.visita_id = @visitascompromiso.visita_id
    @visitasdoc.user_id = is_admin
    @visitasdoc.visitascompromiso_id = @visitascompromiso.id
    respond_to do |format|
      if @visitasdoc.save
        flash[:notice] = "Observacion Registrada con exito."
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @visitasdoc } }
      end
    end
  end

  def create
    @visita  = Visita.find(params[:visita_id])
    @visitasdoc = Visitasdoc.new(visitasdoc_params)
    @visitasdoc.visita_id = @visita.id
    @visitasdoc.user_id = is_admin
    respond_to do |format|
      if @visitasdoc.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @visitasdoc } }
      end
    end
  end

  def update
    @visitasdoc = Visitasdoc.find(params[:id])
    @visita = @visitasdoc.visita
    respond_to do |format|
      if @visitasdoc.update(visitasdoc_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @visitasdoc } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @visitasdoc.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_visitasdoc
    @visita = Visita.find(params[:visita_id])
    @visitasdoc = Visitasdoc.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def visitasdoc_params
    params.require(:visitasdoc).permit!
  end
end
