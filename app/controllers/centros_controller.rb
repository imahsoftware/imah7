class CentrosController < ApplicationController
  before_action :set_centro, only: [:show, :edit, :update, :destroy]

  layout :set_layout
  before_action :checkaccess

  def checkaccess
    return is_permit('centros')
  end

  def index
    @q = Centro.ransack(params[:q])
    @centros = @q.result.paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Centro.find(params[:active_id]) if params[:active_id].present?
    @centro = Centro.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Centro.find(params[:active_id]) if params[:active_id].present?
    @centro = Centro.find(params[:id])
    respond_to { |format| format.js }
  end

  def create
    @centro = Centro.new(centro_params)
    respond_to do |format|
      if @centro.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @centro } }
      end
    end
  end

  def update
    respond_to do |format|
      if @centro.update(centro_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @centro } }
      end
    end
  end

  def destroy
    @centro.destroy
    flash['success'] = "Eliminado con exito"
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_centro
    @centro = Centro.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def centro_params
    params.require(:centro).permit!
  end

  def set_layout
    if ['index', 'new'].include?(action_name)
      'application_admin'
    elsif ['edit'].include?(action_name)
      'application_users'
    else
      'application'
    end
  end
end
