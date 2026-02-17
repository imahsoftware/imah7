class ContratosprosedesController < ApplicationController
  before_action :set_contratosprosede, only: [:show, :destroy]

  # GET /contratosprosedes
  # GET /contratosprosedes.json
  def index
    @contratosprosedes = Contratosprosede.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosprosede.find(params[:active_id]) if params[:active_id].present?
    @contratosproyecto = Contratosproyecto.find(params[:contratosproyecto_id])
    @contratosprosede = Contratosprosede.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosprosede.find(params[:active_id]) if params[:active_id].present?
    @contratosprosede = Contratosprosede.find(params[:id])
    @contratosproyecto = @contratosprosede.contratosproyecto
    respond_to { |format| format.js }
  end

  def create
    @contratosproyecto = Contratosproyecto.find(params[:contratosproyecto_id])
    @contratosprosede = Contratosprosede.new(contratosprosede_params)
    @contratosprosede.contratosproyecto_id = @contratosproyecto.id
    @contratosprosede.user_id = is_admin
    respond_to do |format|
      if @contratosprosede.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosprosede } }
      end
    end
  end

  def update
    @contratosprosede = Contratosprosede.find(params[:id])
    @contratosproyecto = @contratosprosede.contratosproyecto
    respond_to do |format|
      if @contratosprosede.update(contratosprosede_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosprosede } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosprosede.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contratosprosede
    @contratosproyecto = Contratosproyecto.find(params[:contratosproyecto_id])
    @contratosprosede = Contratosprosede.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosprosede_params
    params.require(:contratosprosede).permit!
  end
end
