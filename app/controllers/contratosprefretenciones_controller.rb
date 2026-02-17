class ContratosprefretencionesController < ApplicationController
  before_action :set_contratosprefretencion, only: [:show, :destroy]

  def index
    @contratosprefretenciones = Contratosprefretencion.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosprefretencion.find(params[:active_id]) if params[:active_id].present?
    @contratosprefactura =  Contratosprefactura.find(params[:contratosprefactura_id])
    @contratosprefretencion = Contratosprefretencion.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosprefretencion.find(params[:active_id]) if params[:active_id].present?
    @contratosprefretencion = Contratosprefretencion.find(params[:id])
    @contratosprefactura =  @contratosprefretencion.contratosprefactura
    respond_to { |format| format.js }
  end

  def create
    @contratosprefactura =  Contratosprefactura.find(params[:contratosprefactura_id])
    @contratosprefretencion = Contratosprefretencion.new(contratosprefretencion_params)
    @contratosprefretencion.contratosprefactura_id = @contratosprefactura.id
    @contratosprefretencion.user_id = is_admin
    respond_to do |format|
      if @contratosprefretencion.save
        #ActiveRecord::Base.connection.execute("CALL prc_prefact_saldos(#{@contratosprefactura.id})")
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosprefretencion } }
      end
    end
  end

  def update
    @contratosprefretencion = Contratosprefretencion.find(params[:id])
    #@contratosprefretencion.user_act = is_admin
    @contratosprefactura =  @contratosprefretencion.contratosprefactura
    respond_to do |format|
      if @contratosprefretencion.update(contratosprefretencion_params)
        #ActiveRecord::Base.connection.execute("CALL prc_prefact_saldos(#{@contratosprefactura.id})")
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosprefretencion } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosprefretencion.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosprefretencion
    @contratosprefactura =  Contratosprefactura.find(params[:contratosprefactura_id])
    @contratosprefretencion = Contratosprefretencion.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosprefretencion_params
    params.require(:contratosprefretencion).permit!
  end
end
