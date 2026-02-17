class EgresosimagenesController < ApplicationController
  before_action :set_egresosimagen, only: [:show, :edit, :update, :destroy]

  def index
    @egresosimagenes = Egresosimagen.all
  end

  def show
  end

  def new
    @egresosimagen = Egresosimagen.new
    @egresosimagen.egreso_id = params[:egreso_id].to_i
  end

  def edit
  end

  def create
    @egresosimagen = Egresosimagen.new(egresosimagen_params)
    @egresosimagen.user_id = is_admin
    respond_to do |format|
      if @egresosimagen.save
        flash['success'] = "Documento cargado con exito"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @egresosimagen } }
      end
    end
  end

  def update
    respond_to do |format|
      if @egresosimagen.update(egresosimagen_params)
        format.html { redirect_to @egresosimagen, notice: 'Egresosimagen was successfully updated.' }
        format.json { render :show, status: :ok, location: @egresosimagen }
      else
        format.html { render :edit }
        format.json { render json: @egresosimagen.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @egresosimagen.destroy
    respond_to do |format|
      format.html { redirect_to egresosimagenes_url, notice: 'Egresosimagen was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_egresosimagen
    @egresosimagen = Egresosimagen.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def egresosimagen_params
    params.require(:egresosimagen).permit!
  end
end
