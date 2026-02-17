class ContratosgruposController < ApplicationController
  before_action :set_contratosgrupo, only: [:show, :destroy, :update, :create, :edit, :new]

  def index
    @contratosgrupos = Contratosgrupo.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosgrupo.find(params[:active_id]) if params[:active_id].present?
    @contratosgrupo = Contratosgrupo.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosgrupo.find(params[:active_id]) if params[:active_id].present?
    @contrato = @contratosgrupo.contrato
    respond_to { |format| format.js }
  end

  def create
    @contratosgrupo = Contratosgrupo.new(contratosgrupo_params)
    @contratosgrupo.contrato_id = @contrato.id
    respond_to do |format|
      if @contratosgrupo.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosgrupo } }
      end
    end
  end

  def update
    @contrato = @contratosgrupo.contrato
    respond_to do |format|
      if @contratosgrupo.update(contratosgrupo_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosgrupo } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosgrupo.destroy
  end

  def contratosmasive
    @contratosgrupo = Contratosgrupo.find(params[:id])
    if params[:fecha_inicio].to_s != ""
      @contratosperfechas = Contratosperfecha.where(["contrato_id = #{@contratosgrupo.contrato_id} and contratosgrupo_id = #{@contratosgrupo.id} and fecha_inicio = '#{params[:fecha_inicio].to_date}' and (fecha_fin is null or fecha_fin >= curdate())"])
    else
      @contratosperfechas = Contratosperfecha.where(["contrato_id = #{@contratosgrupo.contrato_id} and contratosgrupo_id = #{@contratosgrupo.id} and (fecha_fin is null or fecha_fin >= curdate())"])
    end
    namefile = @contratosgrupo.descripcion.gsub(' ','_').to_s
    fname = "Contrato_"+namefile.to_s rescue nil
    respond_to do |format|
      format.pdf {render pdf: "#{fname}", template: "contratosgrupos/contratosmasive", encoding: "UTF-8", page_size: 'Letter',:margin => {top: 15, :bottom => 20, :left => 15,:right => 15}}
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contratosgrupo
    @contrato = Contrato.find(params[:contrato_id])
    @contratosgrupo = Contratosgrupo.find(params[:id]) if params[:id]
  end

  # Only allow a list of trusted parameters through.
  def contratosgrupo_params
    params.require(:contratosgrupo).permit!
  end
end
