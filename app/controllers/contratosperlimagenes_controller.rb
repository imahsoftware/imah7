class ContratosperlimagenesController < ApplicationController
  before_action :set_contratosperlimagen, only: [:show, :edit, :update, :destroy]

  def index
    @contratosperlimagenes = Contratosperlimagen.all
  end

  def show
  end

  def new
    @contratosperlimagen = Contratosperlimagen.new
    @contratosperlimagen.contratosperfecha_id = params[:contratosperfecha_id].to_i
  end

  def edit
  end

  def create
    @contratosperlimagen = Contratosperlimagen.new(contratosperlimagen_params)
    @contratosperlimagen.user_id = is_admin
    respond_to do |format|
      if @contratosperlimagen.save
        flash['success'] = "Documento cargado con exito"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperlimagen } }
      end
    end
  end

  def update
    respond_to do |format|
      if @contratosperlimagen.update(contratosperlimagen_params)
        format.html { redirect_to @contratosperlimagen, notice: 'Contratosperlimagen was successfully updated.' }
        format.json { render :show, status: :ok, location: @contratosperlimagen }
      else
        format.html { render :edit }
        format.json { render json: @contratosperlimagen.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contratosperlimagenes/1
  # DELETE /contratosperlimagenes/1.json
  def destroy
    @contratosperlimagen.destroy
    respond_to do |format|
      format.html { redirect_to contratospernominas_path, notice: 'Soporte Eliminado con exito...' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosperlimagen
    @contratosperlimagen = Contratosperlimagen.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosperlimagen_params
    params.require(:contratosperlimagen).permit!
  end
end
