class ContratosenteppsdetallesController < ApplicationController
  before_action :set_contratosenteppsdetalle, only: [:show, :destroy]

  def index
    @contratosenteppsdetalles = Contratosenteppsdetalle.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosenteppsdetalle.find(params[:active_id]) if params[:active_id].present?
    @contratosentepp = Contratosentepp.find(params[:contratosentepp_id])
    @contratosenteppsdetalle = Contratosenteppsdetalle.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosenteppsdetalle.find(params[:active_id]) if params[:active_id].present?
    @contratosenteppsdetalle = Contratosenteppsdetalle.find(params[:id])
    @contratosentepp = @contratosenteppsdetalle.contratosentepp
    respond_to { |format| format.js }
  end

  def create
    @contratosentepp = Contratosentepp.find(params[:contratosentepp_id])
    @contratosenteppsdetalle = Contratosenteppsdetalle.new(contratosenteppsdetalle_params)
    @contratosenteppsdetalle.contratosentepp_id = @contratosentepp.id
    @contratosenteppsdetalle.user_id = is_admin
    @contratosenteppsdetalle.envio_usuario(is_admin)
    respond_to do |format|
      if @contratosenteppsdetalle.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @contratosenteppsdetalle } }
      end
    end
  end

  def update
    @contratosenteppsdetalle = Contratosenteppsdetalle.find(params[:id])
    @contratosentepp = @contratosenteppsdetalle.contratosentepp
    respond_to do |format|
      if @contratosenteppsdetalle.update(contratosenteppsdetalle_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @contratosenteppsdetalle } }
      end
    end
  end

  def update2
    @contratosenteppsdetalle = Contratosenteppsdetalle.find(params[:id])
    @contratosenteppsdetalle.update(contratosenteppsdetalle_params)
    head :no_content
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosenteppsdetalle.destroy
    respond_to do |format|
      flash['success'] = 'Eliminado correctamente'
      format.js { render inline: "location.reload();" }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contratosenteppsdetalle
    @contratosentepp = Contratosentepp.find(params[:contratosentepp_id])
    @contratosenteppsdetalle = Contratosenteppsdetalle.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosenteppsdetalle_params
    params.require(:contratosenteppsdetalle).permit!
  end
end
