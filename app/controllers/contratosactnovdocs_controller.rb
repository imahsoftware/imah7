class ContratosactnovdocsController < ApplicationController
  before_action :set_contratosactnovdoc, only: [:show, :destroy]

  def index
    @contratosactnovdocs = Contratosactnovdoc.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosactnovdoc.find(params[:active_id]) if params[:active_id].present?
    @contratosactnovedad = Contratosactnovedad.find(params[:contratosactnovedad_id])
    @contratosactnovdoc = Contratosactnovdoc.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosactnovdoc.find(params[:active_id]) if params[:active_id].present?
    @contratosactnovdoc = Contratosactnovdoc.find(params[:id])
    @contratosactnovedad = @contratosactnovdoc.contratosactnovedad
    respond_to { |format| format.js }
  end

  def create
    @contratosactnovedad  = Contratosactnovedad.find(params[:contratosactnovedad_id])
    @contratosactnovdoc = Contratosactnovdoc.new(contratosactnovdoc_params)
    @contratosactnovdoc.contratosactnovedad_id = @contratosactnovedad.id
    @contratosactnovdoc.user_id = is_admin
    respond_to do |format|
      if @contratosactnovdoc.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosactnovdoc } }
      end
    end
  end

  def update
    @contratosactnovdoc = Contratosactnovdoc.find(params[:id])
    @contratosactnovedad = @contratosactnovdoc.contratosactnovedad
    respond_to do |format|
      if @contratosactnovdoc.update(contratosactnovdoc_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosactnovdoc } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosactnovdoc.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosactnovdoc
    @contratosactnovedad = Contratosactnovedad.find(params[:contratosactnovedad_id])
    @contratosactnovdoc = Contratosactnovdoc.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosactnovdoc_params
    params.require(:contratosactnovdoc).permit!
  end
end
