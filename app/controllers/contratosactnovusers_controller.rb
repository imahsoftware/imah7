class ContratosactnovusersController < ApplicationController
  before_action :set_contratosactnovuser, only: [:show, :destroy]

  def index
    @contratosactnovusers = Contratosactnovuser.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosactnovuser.find(params[:active_id]) if params[:active_id].present?
    @contratosactnovedad = Contratosactnovedad.find(params[:contratosactnovedad_id])
    @contratosactnovuser = Contratosactnovuser.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosactnovuser.find(params[:active_id]) if params[:active_id].present?
    @contratosactnovuser = Contratosactnovuser.find(params[:id])
    @contratosactnovedad = @contratosactnovuser.contratosactnovedad
    respond_to { |format| format.js }
  end

  def create
    @contratosactnovedad  = Contratosactnovedad.find(params[:contratosactnovedad_id])
    @contratosactnovuser = Contratosactnovuser.new(contratosactnovuser_params)
    @contratosactnovuser.contratosactnovedad_id = @contratosactnovedad.id
    @contratosactnovuser.user_id = is_admin
    respond_to do |format|
      if @contratosactnovuser.save
        if @contratosactnovedad.estado == 'PENDIENTE'
          @contratosactnovedad.estado = 'EN PROCESO'
          @contratosactnovedad.fecha_enproceso = Time.now
          @contratosactnovedad.save
        end
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosactnovuser } }
      end
    end
  end

  def update
    @contratosactnovuser = Contratosactnovuser.find(params[:id])
    @contratosactnovedad = @contratosactnovuser.contratosactnovedad
    respond_to do |format|
      if @contratosactnovuser.update(contratosactnovuser_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosactnovuser } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosactnovuser.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosactnovuser
    @contratosactnovedad = Contratosactnovedad.find(params[:contratosactnovedad_id])
    @contratosactnovuser = Contratosactnovuser.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosactnovuser_params
    params.require(:contratosactnovuser).permit!
  end
end
