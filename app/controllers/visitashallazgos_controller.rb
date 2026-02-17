class VisitashallazgosController < ApplicationController
  before_action :set_visitashallazgo, only: [:show, :destroy]

  def index
    @visitashallazgos = Visitashallazgo.all
  end

  def captura
    @visita = Visita.find(params[:visita_id])
    @image = Visitashallazgo.new
  end

  def captura_imagen
    @visita = Visita.find(params[:visita_id])
    @visita.visitashallazgos.where(tipo: 'CAPTURA IMAGEN HALLAZGO').delete_all

    data = params[:image][:image_data]
    image_data = Base64.decode64(data)
    new_file = File.new("public/webcam/captura_hallazgo_#{@visita.id}.png", 'wb')
    new_file.write(image_data)
    file = File.open(new_file, 'rb')

    @visitashallazgo = Visitashallazgo.new(
      visita_id: @visita.id,
      user_id: current_user.id, # Asegúrate de usar el método correcto para obtener el ID del usuario actual
      tipo: "CAPTURA IMAGEN HALLAZGO",
      docvisitashallazgo: file
    )

    if @visitashallazgo.save(validate: false)
      antes_exists = @visita.visitashallazgos.exists?(tipo: 'CAPTURA IMAGEN HALLAZGO')
      render json: { success: true, antesExists: antes_exists }
    else
      render json: { success: false, message: "Error al guardar la imagen." }, status: :unprocessable_entity
    end
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Visitashallazgo.find(params[:active_id]) if params[:active_id].present?
    @visita = Visita.find(params[:visita_id])
    @visitashallazgo = Visitashallazgo.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Visitashallazgo.find(params[:active_id]) if params[:active_id].present?
    @visitashallazgo = Visitashallazgo.find(params[:id])
    @visita = @visitashallazgo.visita
    respond_to { |format| format.js }
  end


  def create
    @visita  = Visita.find(params[:visita_id])
    @visitashallazgo = Visitashallazgo.new(visitashallazgo_params)
    @visitashallazgo.visita_id = @visita.id
    @visitashallazgo.user_id = is_admin
    respond_to do |format|
      if @visitashallazgo.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @visitashallazgo } }
      end
    end
  end

  def update
    @visitashallazgo = Visitashallazgo.find(params[:id])
    @visita = @visitashallazgo.visita
    respond_to do |format|
      if @visitashallazgo.update(visitashallazgo_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @visitashallazgo } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @visitashallazgo.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_visitashallazgo
    @visita = Visita.find(params[:visita_id])
    @visitashallazgo = Visitashallazgo.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def visitashallazgo_params
    params.require(:visitashallazgo).permit!
  end
end
