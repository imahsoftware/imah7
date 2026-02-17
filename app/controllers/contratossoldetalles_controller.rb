class ContratossoldetallesController < ApplicationController
  before_action :set_contratossoldetalle, only: [:show, :destroy]

  def fichatecnica
    contratossoldetalle_id = params[:contratossoldetalle_id]
    @contratossoldetalle = Contratossoldetalle.select(["contratossoldetalles.*,
                                                        (select distinct 'X' from contratosinsimagenes where contratosinsumo_id = contratossoldetalles.contratosinsumo_id) existeimg,
                                                         (select presentacion from insumos where id = (select insumocce from contratosinsumos where id = contratossoldetalles.contratosinsumo_id)) presentacion"])
                                              .where(id: contratossoldetalle_id)[0]
  end
  def index
    @contratossoldetalles = Contratossoldetalle.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratossoldetalle.find(params[:active_id]) if params[:active_id].present?
    @contratossolicitud = Contratossolicitud.find(params[:contratossolicitud_id])
    @contratossoldetalle = Contratossoldetalle.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratossoldetalle.find(params[:active_id]) if params[:active_id].present?
    @contratossoldetalle = Contratossoldetalle.find(params[:id])
    @contratossolicitud = @contratossoldetalle.contratossolicitud
    respond_to { |format| format.js }
  end

  def create
    @contratossolicitud  = Contratossolicitud.find(params[:contratossolicitud_id])
    @contratossoldetalle = Contratossoldetalle.new(contratossoldetalle_params)
    @contratossoldetalle.contratossolicitud_id = @contratossolicitud.id
    @contratossoldetalle.user_id = is_admin
    respond_to do |format|
      if @contratossoldetalle.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratossoldetalle } }
      end
    end
  end

  def update
    @contratossoldetalle = Contratossoldetalle.find(params[:id])
    @contratossoldetalle.user_act = is_admin
    @contratossolicitud = @contratossoldetalle.contratossolicitud
    respond_to do |format|
      if @contratossoldetalle.update(contratossoldetalle_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratossoldetalle } }
      end
    end
  end

  def destroy
    flash['danger'] = 'Eliminado correctamente'
    @contratossoldetalle.destroy
  end

  def edit_individual
    para = params[:contratossolicitud_id].to_i
    @contratossolicitud = Contratossolicitud.find(para)
    Contratossede.where(["contrato_id = #{@contratossolicitud.contrato_id} and id not in (select sede from sedesactivas where contrato_id = #{@contratossolicitud.contrato.id} and user_interventor = #{@contratossolicitud.user_id})"]).each do |a|
      ActiveRecord::Base.connection.execute("update contratossoldetalles set cantsede_"+a.ordensede.to_s+" = 0 where contratossolicitud_id = #{@contratossolicitud.id}")
    end
    @contratossoldetalles = @contratossolicitud.contratossoldetalles.order("contratosinsumo_id asc")
  end

  def update_individual
    id = 0
    JSON.parse(params[:contratossoldetalles].to_json).each do |object|
      id = Contratossoldetalle.find(object[0]).contratossolicitud_id.to_s
      break if id != ""
    end
    Contratossoldetalle.update(params[:contratossoldetalles].keys, params[:contratossoldetalles].values)
    flash[:notice] = "Actualizada con Exito."
    redirect_to edit_individual_contratossoldetalles_path(contratossolicitud_id: id)
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratossoldetalle
    @contratossolicitud = Contratossolicitud.find(params[:contratossolicitud_id])
    @contratossoldetalle = Contratossoldetalle.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratossoldetalle_params
    params.require(:contratossoldetalle).permit!
  end
end
