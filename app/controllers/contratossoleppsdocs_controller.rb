class ContratossoleppsdocsController < ApplicationController
  before_action :set_contratossoleppsdoc, only: [:show, :destroy]

  def index
    @contratossoleppsdocs = Contratossoleppsdoc.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratossoleppsdoc.find(params[:active_id]) if params[:active_id].present?
    @contratossolepp = Contratossolepp.find(params[:contratossolepp_id])
    @contratossoleppsdoc = Contratossoleppsdoc.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratossoleppsdoc.find(params[:active_id]) if params[:active_id].present?
    @contratossoleppsdoc = Contratossoleppsdoc.find(params[:id])
    @contratossolepp = @contratossoleppsdoc.contratossolepp
    respond_to { |format| format.js }
  end

  def create
    @contratossolepp  = Contratossolepp.find(params[:contratossolepp_id])
    @contratossoleppsdoc = Contratossoleppsdoc.new(contratossoleppsdoc_params)
    @contratossoleppsdoc.contratossolepp_id = @contratossolepp.id
    @contratossoleppsdoc.user_id = is_admin
    respond_to do |format|
      if @contratossoleppsdoc.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratossoleppsdoc } }
      end
    end
  end

  def update
    @contratossoleppsdoc = Contratossoleppsdoc.find(params[:id])
    @contratossolepp = @contratossoleppsdoc.contratossolepp
    respond_to do |format|
      if @contratossoleppsdoc.update(contratossoleppsdoc_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratossoleppsdoc } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratossoleppsdoc.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratossoleppsdoc
    @contratossolepp = Contratossolepp.find(params[:contratossolepp_id])
    @contratossoleppsdoc = Contratossoleppsdoc.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratossoleppsdoc_params
    params.require(:contratossoleppsdoc).permit!
  end
end
