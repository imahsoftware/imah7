class ContratosinsumosController < ApplicationController
  before_action :set_contratosinsumo, only: [:show, :destroy]

  def fichatecnica
    contratosinsumo_id = params[:contratosinsumo_id]
    @contratosinsumo = Contratosinsumo.select(["contratosinsumos.*,
                                                (select distinct 'X' from contratosinsimagenes where contratosinsumo_id = contratosinsumos.id) existeimg,
                                                 (select presentacion from insumos where id = contratosinsumos.insumocce) presentacion"])
                                      .where(id: contratosinsumo_id)[0]
  end
  def index
    @contratosinsumos = Contratosinsumo.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosinsumo.find(params[:active_id]) if params[:active_id].present?
    @contrato = Contrato.find(params[:contrato_id])
    @contratosinsumo = Contratosinsumo.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosinsumo.find(params[:active_id]) if params[:active_id].present?
    @contratosinsumo = Contratosinsumo.find(params[:id])
    @contrato = @contratosinsumo.contrato
    respond_to { |format| format.js }
  end

  def create
    @contrato  = Contrato.find(params[:contrato_id])
    @contratosinsumo = Contratosinsumo.new(contratosinsumo_params)
    @contratosinsumo.contrato_id = @contrato.id
    @contratosinsumo.user_id = is_admin
    respond_to do |format|
      if @contratosinsumo.save
        ActiveRecord::Base.connection.execute("CALL prc_actsolicitudes")
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosinsumo } }
      end
    end
  end

  def update
    @contratosinsumo = Contratosinsumo.find(params[:id])
    @contratosinsumo.user_act = is_admin
    @contrato = @contratosinsumo.contrato
    respond_to do |format|
      if @contratosinsumo.update(contratosinsumo_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosinsumo } }
      end
    end
  end

  def edit_individual
    para = params[:contrato_id].to_i
    @contrato = Contrato.find(para)
    @contratosinsumos = Contratosinsumo.where(contrato_id: para).order("id asc")
  end

  def update_individual
    id = 0
    JSON.parse(params[:contratosinsumos].to_json).each do |object|
      id = Contratosinsumo.find(object[0]).contrato_id.to_s
      break if id != ""
    end
    Contratosinsumo.update(params[:contratosinsumos].keys, params[:contratosinsumos].values)
    flash[:notice] = "Actualizada con Exito."
    redirect_to edit_individual_contratosinsumos_path(contrato_id: id)
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosinsumo.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosinsumo
    @contrato = Contrato.find(params[:contrato_id])
    @contratosinsumo = Contratosinsumo.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosinsumo_params
    params.require(:contratosinsumo).permit!
  end
end
