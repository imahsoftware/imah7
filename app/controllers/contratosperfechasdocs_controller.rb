class ContratosperfechasdocsController < ApplicationController
  before_action :set_contratosperfechasdoc, only: [:show, :edit, :update, :destroy]


  def new
    @tipo = params[:tipo]
    @estado = params[:estado]
    @contratosperfecha = Contratosperfecha.find(params[:contratosperfecha_id])
    @contratosperfechasdoc = Contratosperfechasdoc.new
  end


  def create
    @estado = params[:estado]
    @contratosperfecha = Contratosperfecha.find(params[:contratosperfecha_id])
    @contratosperfechasdoc = Contratosperfechasdoc.new(contratosperfechasdoc_params)
    @contratosperfechasdoc.user_id = is_admin
    @contratosperfechasdoc.contratosperfecha_id = @contratosperfecha.id
    @contratosperfechasdoc.tipo = params[:tipo]
    respond_to do |format|
      if @contratosperfechasdoc.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperfechasdoc } }
      end
    end
  end


  def destroy
    @contratosperfechasdoc.destroy
    respond_to do |format|
      flash['success'] = 'Eliminado correctamente'
      format.js { render inline: "location.reload();" }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contratosperfechasdoc
      @contratosperfechasdoc = Contratosperfechasdoc.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def contratosperfechasdoc_params
      params.require(:contratosperfechasdoc).permit(:contratosperfecha_id, :descripcion, :soporte_digital)
    end
end
