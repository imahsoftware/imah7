class ContratospergruposController < ApplicationController
  before_action :set_contratospergrupo, only: [:show, :destroy]

  def index
    @contratospergrupos = Contratospergrupo.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratospergrupo.find(params[:active_id]) if params[:active_id].present?
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratospergrupo = Contratospergrupo.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratospergrupo.find(params[:active_id]) if params[:active_id].present?
    @contratospergrupo = Contratospergrupo.find(params[:id])
    @contratospersona = @contratospergrupo.contratospersona
    respond_to { |format| format.js }
  end

  def create
    @contratospersona  = Contratospersona.find(params[:contratospersona_id])
    @contratospergrupo = Contratospergrupo.new(contratospergrupo_params)
    @contratospergrupo.contratospersona_id = @contratospersona.id
    @contratospergrupo.user_id = is_admin
    respond_to do |format|
      if @contratospergrupo.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratospergrupo } }
      end
    end
  end

  def update
    @contratospergrupo = Contratospergrupo.find(params[:id])
    @contratospergrupo.user_act = is_admin
    @contratospersona = @contratospergrupo.contratospersona
    respond_to do |format|
      if @contratospergrupo.update(contratospergrupo_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratospergrupo } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratospergrupo.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratospergrupo
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratospergrupo = Contratospergrupo.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratospergrupo_params
    params.require(:contratospergrupo).permit!
  end
end
