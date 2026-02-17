class ContratospernotasController < ApplicationController
  before_action :set_contratospernota, only: [:show, :destroy]

  def index
    @contratospernotas = Contratospernota.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @tipo = params[:tipo] rescue nil
    @contratosperfecha = params[:contratosperfecha_id] rescue nil
    @active_record = Contratospernota.find(params[:active_id]) if params[:active_id].present?
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratospernota = Contratospernota.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratospernota.find(params[:active_id]) if params[:active_id].present?
    @contratospernota = Contratospernota.find(params[:id])
    @contratospersona = @contratospernota.contratospersona
    respond_to { |format| format.js }
  end

  def create
    @contratospersona  = Contratospersona.find(params[:contratospersona_id])
    @contratospernota = Contratospernota.new(contratospernota_params)
    @contratospernota.tipo_afiliacion = params[:tipo_afiliacion] rescue nil
    @contratospernota.contratosperfecha_id = params[:contratosperfecha_id] rescue nil
    @contratospernota.contratospersona_id = @contratospersona.id
    @contratospernota.user_id = is_admin
    respond_to do |format|
      if @contratospernota.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratospernota } }
      end
    end
  end

  def update
    @contratospernota = Contratospernota.find(params[:id])
    @contratospernota.user_act = is_admin
    @contratospersona = @contratospernota.contratospersona
    respond_to do |format|
      if @contratospernota.update(contratospernota_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratospernota } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratospernota.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratospernota
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratospernota = Contratospernota.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratospernota_params
    params.require(:contratospernota).permit!
  end
end
