class PortafoliosvehiculosController < ApplicationController
  before_action :set_portafoliosvehiculo, only: [:show, :destroy]

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Portafoliosvehiculo.find(params[:active_id]) if params[:active_id].present?
    @portafolio = Portafolio.find(params[:portafolio_id])
    @portafoliosvehiculo = Portafoliosvehiculo.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Portafoliosvehiculo.find(params[:active_id]) if params[:active_id].present?
    @portafoliosvehiculo = Portafoliosvehiculo.find(params[:id])
    @portafolio = @portafoliosvehiculo.portafolio
    respond_to { |format| format.js }
  end

  def create
    @portafolio  = Portafolio.find(params[:portafolio_id])
    @portafoliosvehiculo = Portafoliosvehiculo.new(portafoliosvehiculo_params)
    @portafoliosvehiculo.portafolio_id = @portafolio.id
    @portafoliosvehiculo.user_id = is_admin
    respond_to do |format|
      if @portafoliosvehiculo.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @portafoliosvehiculo } }
      end
    end
  end

  def update
    @portafoliosvehiculo = Portafoliosvehiculo.find(params[:id])
    @portafolio = @portafoliosvehiculo.portafolio
    respond_to do |format|
      if @portafoliosvehiculo.update(portafoliosvehiculo_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @portafoliosvehiculo } }
      end
    end
  end

  def destroy
    @portafoliosvehiculo.destroy
    flash['success'] = 'Eliminado correctamente'
  end

  private
    def set_portafoliosvehiculo
      @portafolio = Portafolio.find(params[:portafolio_id])
      @portafoliosvehiculo = Portafoliosvehiculo.find(params[:id]) if params[:id]
    end

    def portafoliosvehiculo_params
      params.require(:portafoliosvehiculo).permit! #(:portafolio_id, :descripcion, :user_id)
    end
end
