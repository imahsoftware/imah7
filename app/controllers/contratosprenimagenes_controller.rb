class ContratosprenimagenesController < ApplicationController
  before_action :set_contratosprenimagen, only: [:show, :edit, :update, :destroy]

  def index
    @contratosprenimagenes = Contratosprenimagen.all
  end

  def show
  end

  def new
    @contratosprenimagen = Contratosprenimagen.new
    @contratosprenimagen.contrato_id = params[:contrato_id].to_i
    @contratosprenimagen.contratosgrupo_id = params[:contratosgrupo_id].to_i
  end

  def edit
  end

  def create
    @contratosprenimagen = Contratosprenimagen.new(contratosprenimagen_params)
    @contratosprenimagen.user_id = is_admin
    respond_to do |format|
      if @contratosprenimagen.save
        flash['success'] = "Documento cargado con exito"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosprenimagen } }
      end
    end
  end

  def update
    respond_to do |format|
      if @contratosprenimagen.update(contratosprenimagen_params)
        format.html { redirect_to @contratosprenimagen, notice: 'Contratosprenimagen was successfully updated.' }
        format.json { render :show, status: :ok, location: @contratosprenimagen }
      else
        format.html { render :edit }
        format.json { render json: @contratosprenimagen.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contratosprenimagenes/1
  # DELETE /contratosprenimagenes/1.json
  def destroy
    @contratosprenimagen.destroy
    respond_to do |format|
      format.html { redirect_to contratosprenimagenes_url, notice: 'Contratosprenimagen was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosprenimagen
    @contratosprenimagen = Contratosprenimagen.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosprenimagen_params
    params.require(:contratosprenimagen).permit!
  end
end
