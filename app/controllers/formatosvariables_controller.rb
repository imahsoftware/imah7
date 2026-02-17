class FormatosvariablesController < ApplicationController
  before_action :set_formatosvariable, only: [:show, :destroy]

  def index
    @formatosvariables = Formatosvariable.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Formatosvariable.find(params[:active_id]) if params[:active_id].present?
    @formato = Formato.find(params[:formato_id])
    @formatosvariable = Formatosvariable.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Formatosvariable.find(params[:active_id]) if params[:active_id].present?
    @formatosvariable = Formatosvariable.find(params[:id])
    @formato = @formatosvariable.formato
    respond_to { |format| format.js }
  end

  def create
    @formato  = Formato.find(params[:formato_id])
    @formatosvariable = Formatosvariable.new(formatosvariable_params)
    @formatosvariable.formato_id = @formato.id
    respond_to do |format|
      if @formatosvariable.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @formatosvariable } }
      end
    end
  end

  def update
    @formatosvariable = Formatosvariable.find(params[:id])
    @formato = @formatosvariable.formato
    respond_to do |format|
      if @formatosvariable.update(formatosvariable_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @formatosvariable } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @formatosvariable.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_formatosvariable
    @formato = Formato.find(params[:formato_id])
    @formatosvariable = Formatosvariable.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def formatosvariable_params
    params.require(:formatosvariable).permit!
  end
end
