class ContratosperusersController < ApplicationController
  before_action :set_contratosperuser, only: [:show, :destroy, :edit]

  def index
    @contratosperusers = Contratosperuser.all
  end

  def show
    respond_to { |format| format.js }
  end

  def abrircargue
    @archivo = Archivo.new
    @archivo.datoid = 7
    #respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosperuser.find(params[:active_id]) if params[:active_id].present?
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratosperuser = Contratosperuser.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosperuser.find(params[:active_id]) if params[:active_id].present?
    @contratospersona = @contratosperuser.contratospersona
    respond_to { |format| format.js }
  end

  def create
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratosperuser = Contratosperuser.new(contratosperuser_params)
    @contratosperuser.contratospersona_id = @contratospersona.id
    respond_to do |format|
      if @contratosperuser.save
        ActiveRecord::Base.connection.execute("CALL prc_validasuperbypersonaid(#{@contratospersona.id})")
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperuser } }
      end
    end
  end

  def update
    @contratosperuser = Contratosperuser.find(params[:id])
    @contratospersona = @contratosperuser.contratospersona
    respond_to do |format|
      if @contratosperuser.update(contratosperuser_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperuser } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosperuser.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contratosperuser
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratosperuser = Contratosperuser.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosperuser_params
    params.require(:contratosperuser).permit!
  end
end
