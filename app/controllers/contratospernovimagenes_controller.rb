class ContratospernovimagenesController < ApplicationController
  before_action :set_contratospernovimagen, only: [:show, :edit, :update, :destroy]

  def index
    @contratospernovimagenes = Contratospernovimagen.all
  end

  def show
  end

  def new
    @contratospernovimagen = Contratospernovimagen.new
    @contratospernovimagen.contratospernovedad_id = params[:contratospernovedad_id].to_i
  end

  def edit
  end

  def create
    @contratospernovimagen = Contratospernovimagen.new(contratospernovimagen_params)
    @contratospernovimagen.user_id = is_admin
    respond_to do |format|
      if @contratospernovimagen.save
        flash['success'] = "Documento cargado con exito"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratospernovimagen } }
      end
    end
  end

  def update
    respond_to do |format|
      if @contratospernovimagen.update(contratospernovimagen_params)
        format.html { redirect_to @contratospernovimagen, notice: 'Contratospernovimagen was successfully updated.' }
        format.json { render :show, status: :ok, location: @contratospernovimagen }
      else
        format.html { render :edit }
        format.json { render json: @contratospernovimagen.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contratospernovimagenes/1
  # DELETE /contratospernovimagenes/1.json
  def destroy
    @contratospernovimagen.destroy
    respond_to do |format|
      format.html { redirect_to contratospernovimagenes_url, notice: 'Contratospernovimagen was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratospernovimagen
    @contratospernovimagen = Contratospernovimagen.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratospernovimagen_params
    params.require(:contratospernovimagen).permit!
  end
end
