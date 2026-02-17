class ContratosactnovnotasController < ApplicationController
  before_action :set_contratosactnovnota, only: [:show, :destroy]

  def index
    @contratosactnovnotas = Contratosactnovnota.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosactnovnota.find(params[:active_id]) if params[:active_id].present?
    @contratosactnovedad = Contratosactnovedad.find(params[:contratosactnovedad_id])
    @contratosactnovnota = Contratosactnovnota.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosactnovnota.find(params[:active_id]) if params[:active_id].present?
    @contratosactnovnota = Contratosactnovnota.find(params[:id])
    @contratosactnovedad = @contratosactnovnota.contratosactnovedad
    respond_to { |format| format.js }
  end

  def create
    @contratosactnovedad  = Contratosactnovedad.find(params[:contratosactnovedad_id])
    @contratosactnovnota = Contratosactnovnota.new(contratosactnovnota_params)
    @contratosactnovnota.contratosactnovedad_id = @contratosactnovedad.id
    @contratosactnovnota.user_id = is_admin
    respond_to do |format|
      if @contratosactnovnota.save
        if @contratosactnovedad.estado == 'PENDIENTE'
          @contratosactnovedad.estado = 'EN PROCESO'
          @contratosactnovedad.fecha_enproceso = Time.now
          @contratosactnovedad.save
        end
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosactnovnota } }
      end
    end
  end

  def update
    @contratosactnovnota = Contratosactnovnota.find(params[:id])
    @contratosactnovedad = @contratosactnovnota.contratosactnovedad
    respond_to do |format|
      if @contratosactnovnota.update(contratosactnovnota_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosactnovnota } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosactnovnota.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosactnovnota
    @contratosactnovedad = Contratosactnovedad.find(params[:contratosactnovedad_id])
    @contratosactnovnota = Contratosactnovnota.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosactnovnota_params
    params.require(:contratosactnovnota).permit!
  end
end
