class ContratoscargosactsController < ApplicationController
  before_action :set_contratoscargosact, only: [:show, :destroy, :new]

  def index
    @contratoscargosacts = Contratoscargosact.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratoscargosact.find(params[:active_id]) if params[:active_id].present?
    @contratoscargo = Contratoscargo.find(params[:contratoscargo_id])
    @contratoscargosact = Contratoscargosact.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratoscargosact.find(params[:active_id]) if params[:active_id].present?
    @contratoscargosact = Contratoscargosact.find(params[:id])
    @contratoscargo = @contratoscargosact.contratoscargo
    respond_to { |format| format.js }
  end

  def create
    @contratoscargo  = Contratoscargo.find(params[:contratoscargo_id])
    @contratoscargosact = Contratoscargosact.new(contratoscargosact_params)
    @contratoscargosact.contratoscargo_id = @contratoscargo.id
    @contratoscargosact.user_id = is_admin
    respond_to do |format|
      if @contratoscargosact.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratoscargosact } }
      end
    end
  end

  def update
    @contratoscargosact = Contratoscargosact.find(params[:id])
    @contratoscargo = @contratoscargosact.contratoscargo
    respond_to do |format|
      if @contratoscargosact.update(contratoscargosact_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratoscargosact } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratoscargosact.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratoscargosact
    @contratoscargo = Contratoscargo.find(params[:contratoscargo_id])
    @contratoscargosact = Contratoscargosact.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratoscargosact_params
    params.require(:contratoscargosact).permit!
  end
end
