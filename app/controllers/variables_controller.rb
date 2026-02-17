class VariablesController < ApplicationController
  before_action :set_variable, only: [:show, :edit, :update, :destroy]

  #before_action :checkaccess, only: [:index, :edit], if: :user_signed_in?

  def checkaccess
    return is_permit('variables')
  end

  def index
    @q = Variable.ransack(params[:q])
    @variables = @q.result.paginate(:page => params[:page], :per_page => 50)
    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Variable.find(params[:active_id]) if params[:active_id].present?
    @variable = Variable.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Variable.find(params[:active_id]) if params[:active_id].present?
    @variable = Variable.find(params[:id])
    respond_to { |format| format.js }
  end

  def create
    @variable = Variable.new(variable_params)
    respond_to do |format|
      if @variable.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @variable } }
      end
    end
  end

  def update
    respond_to do |format|
      if @variable.update(variable_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @variable } }
      end
    end
  end

  def destroy
    @variable.destroy
    flash['success'] = 'Eliminado con Exito'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_variable
    @variable = Variable.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def variable_params
    params.require(:variable).permit!
  end
end