class ContratossoleppsdetallesController < ApplicationController
  before_action :set_contratossoleppsdetalle, only: [:show, :destroy]

  def index
    @contratossoleppsdetalles = Contratossoleppsdetalle.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratossoleppsdetalle.find(params[:active_id]) if params[:active_id].present?
    @contratossolepp = Contratossolepp.find(params[:contratossolepp_id])
    @contratossoleppsdetalle = Contratossoleppsdetalle.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratossoleppsdetalle.find(params[:active_id]) if params[:active_id].present?
    @contratossoleppsdetalle = Contratossoleppsdetalle.find(params[:id])
    @contratossolepp = @contratossoleppsdetalle.contratossolepp
    respond_to { |format| format.js }
  end

  def create
    @contratossolepp = Contratossolepp.find(params[:contratossolepp_id])
    @contratossoleppsdetalle = Contratossoleppsdetalle.new(contratossoleppsdetalle_params)
    @contratossoleppsdetalle.contratossolepp_id = @contratossolepp.id
    @contratossoleppsdetalle.cant_aprobada = params[:contratossoleppsdetalle][:cantidad]
    respond_to do |format|
      if @contratossoleppsdetalle.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @contratossoleppsdetalle } }
      end
    end
  end

  def update
    @contratossoleppsdetalle = Contratossoleppsdetalle.find(params[:id])
    @contratossolepp = @contratossoleppsdetalle.contratossolepp
    @contratossoleppsdetalle.cant_aprobada = params[:contratossoleppsdetalle][:cantidad]
    respond_to do |format|
      if @contratossoleppsdetalle.update(contratossoleppsdetalle_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @contratossoleppsdetalle } }
      end
    end
  end

  def update2
    @contratossoleppsdetalle = Contratossoleppsdetalle.find(params[:id])
    @contratossoleppsdetalle.update(contratossoleppsdetalle_params)
    head :no_content
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratossoleppsdetalle.destroy
    respond_to do |format|
      flash['success'] = 'Eliminado correctamente'
      format.js { render inline: "location.reload();" }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contratossoleppsdetalle
    @contratossolepp = Contratossolepp.find(params[:contratossolepp_id])
    @contratossoleppsdetalle = Contratossoleppsdetalle.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratossoleppsdetalle_params
    params.require(:contratossoleppsdetalle).permit!
  end
end
