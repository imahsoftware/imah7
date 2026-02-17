class ContratosusersController < ApplicationController
  before_action :set_contratosuser, only: [:show, :destroy]

  def index
    @contratosusers = Contratosuser.all
  end

  def show
    respond_to { |format| format.js }
  end

  def sede
    contrato_id = params[:contrato_id]
    user_interventor = params[:user_interventor]
    @nombreinterventor = User.find(user_interventor).nombrecompleto rescue nil
    @sedes = Contratossede.where(["id in (select sede from sedesactivas where contrato_id = #{contrato_id} and user_interventor = #{user_interventor})"])
  end

  def new
    @active_record = Contratosuser.find(params[:active_id]) if params[:active_id].present?
    @contrato = Contrato.find(params[:contrato_id])
    @contratosuser = Contratosuser.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosuser.find(params[:active_id]) if params[:active_id].present?
    @contratosuser = Contratosuser.find(params[:id])
    @contrato = @contratosuser.contrato
    respond_to { |format| format.js }
  end

  def create
    @contrato  = Contrato.find(params[:contrato_id])
    @contratosuser = Contratosuser.new(contratosuser_params)
    @contratosuser.contrato_id = @contrato.id
    @contratosuser.user_id = is_admin
    respond_to do |format|
      if @contratosuser.save
        ActiveRecord::Base.connection.execute("CALL prc_actperfilcontratosindividual('#{@contrato.id}')")
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosuser } }
      end
    end
  end

  def update
    @contratosuser = Contratosuser.find(params[:id])
    @contratosuser.user_act = is_admin
    @contrato = @contratosuser.contrato
    respond_to do |format|
      if @contratosuser.update(contratosuser_params)
        ActiveRecord::Base.connection.execute("CALL prc_actperfilcontratosindividual('#{@contrato.id}')")
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosuser } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosuser.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosuser
    @contrato = Contrato.find(params[:contrato_id])
    @contratosuser = Contratosuser.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosuser_params
    params.require(:contratosuser).permit!
  end
end
