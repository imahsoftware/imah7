class ContratosprefdetallesController < ApplicationController
  before_action :set_contratosprefdetalle, only: [:show, :destroy]

  def index
    @contratosprefdetalles = Contratosprefdetalle.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosprefdetalle.find(params[:active_id]) if params[:active_id].present?
    @contratosprefactura =  Contratosprefactura.find(params[:contratosprefactura_id])
    @contratosprefdetalle = Contratosprefdetalle.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosprefdetalle.find(params[:active_id]) if params[:active_id].present?
    @contratosprefdetalle = Contratosprefdetalle.find(params[:id])
    @contratosprefactura =  @contratosprefdetalle.contratosprefactura
    respond_to { |format| format.js }
  end

  def create
    @contratosprefactura =  Contratosprefactura.find(params[:contratosprefactura_id])
    @contratosprefdetalle = Contratosprefdetalle.new(contratosprefdetalle_params)
    @contratosprefdetalle.contratosprefactura_id = @contratosprefactura.id
    @contratosprefdetalle.user_id = is_admin
    respond_to do |format|
      if @contratosprefdetalle.save
        ActiveRecord::Base.connection.execute("CALL prc_prefact_saldos(#{@contratosprefactura.id})")
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosprefdetalle } }
      end
    end
  end

  def update
    @contratosprefdetalle = Contratosprefdetalle.find(params[:id])
    #@contratosprefdetalle.user_act = is_admin
    @contratosprefactura =  @contratosprefdetalle.contratosprefactura
    respond_to do |format|
      if @contratosprefdetalle.update(contratosprefdetalle_params)
        ActiveRecord::Base.connection.execute("CALL prc_prefact_saldos(#{@contratosprefactura.id})")
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosprefdetalle } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosprefdetalle.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosprefdetalle
    @contratosprefactura =  Contratosprefactura.find(params[:contratosprefactura_id])
    @contratosprefdetalle = Contratosprefdetalle.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosprefdetalle_params
    params.require(:contratosprefdetalle).permit!
  end
end
