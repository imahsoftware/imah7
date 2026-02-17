class ContratosperinvnotasController < ApplicationController
  before_action :set_contratosperinvnota, only: [:show, :destroy]

  def index
    @contratosperinvnotas = Contratosperinvnota.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosperinvnota.find(params[:active_id]) if params[:active_id].present?
    @contratosperinventario = Contratosperinventario.find(params[:contratosperinventario_id])
    @contratosperinvnota = Contratosperinvnota.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosperinvnota.find(params[:active_id]) if params[:active_id].present?
    @contratosperinvnota = Contratosperinvnota.find(params[:id])
    @contratosperinventario = @contratosperinvnota.contratosperinventario
    respond_to { |format| format.js }
  end

  def create
    @contratosperinventario  = Contratosperinventario.find(params[:contratosperinventario_id])
    @contratosperinvnota = Contratosperinvnota.new(contratosperinvnota_params)
    @contratosperinvnota.contratosperinventario_id = @contratosperinventario.id
    @contratosperinvnota.user_id = is_admin
    respond_to do |format|
      if @contratosperinvnota.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperinvnota } }
      end
    end
  end

  def update
    @contratosperinvnota = Contratosperinvnota.find(params[:id])
    @contratosperinventario = @contratosperinvnota.contratosperinventario
    respond_to do |format|
      if @contratosperinvnota.update(contratosperinvnota_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperinvnota } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosperinvnota.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosperinvnota
    @contratosperinventario = Contratosperinventario.find(params[:contratosperinventario_id])
    @contratosperinvnota = Contratosperinvnota.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosperinvnota_params
    params.require(:contratosperinvnota).permit!
  end
end
