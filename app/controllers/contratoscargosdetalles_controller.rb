class ContratoscargosdetallesController < ApplicationController
  before_action :set_contratoscargosdetalle, only: [:show, :destroy, :new]

  def index
    @contratoscargosdetalles = Contratoscargosdetalle.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratoscargosdetalle.find(params[:active_id]) if params[:active_id].present?
    @contratoscargo = Contratoscargo.find(params[:contratoscargo_id])
    @contratoscargosdetalle = Contratoscargosdetalle.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratoscargosdetalle.find(params[:active_id]) if params[:active_id].present?
    @contratoscargosdetalle = Contratoscargosdetalle.find(params[:id])
    @contratoscargo = @contratoscargosdetalle.contratoscargo
    respond_to { |format| format.js }
  end

  def create
    @contratoscargo  = Contratoscargo.find(params[:contratoscargo_id])
    @contratoscargosdetalle = Contratoscargosdetalle.new(contratoscargosdetalle_params)
    @contratoscargosdetalle.contratoscargo_id = @contratoscargo.id
    @contratoscargosdetalle.user_id = is_admin
    respond_to do |format|
      if @contratoscargosdetalle.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratoscargosdetalle } }
      end
    end
  end

  def update
    @contratoscargosdetalle = Contratoscargosdetalle.find(params[:id])
    @contratoscargo = @contratoscargosdetalle.contratoscargo
    respond_to do |format|
      if @contratoscargosdetalle.update(contratoscargosdetalle_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratoscargosdetalle } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratoscargosdetalle.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratoscargosdetalle
    @contratoscargo = Contratoscargo.find(params[:contratoscargo_id])
    @contratoscargosdetalle = Contratoscargosdetalle.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratoscargosdetalle_params
    params.require(:contratoscargosdetalle).permit!
  end
end
