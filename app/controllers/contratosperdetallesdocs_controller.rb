class ContratosperdetallesdocsController < ApplicationController
  before_action :set_contratosperdetallesdoc, only: [:update]

  def new
    @contratosperinvdetalle = Contratosperinvdetalle.find(params[:contratosperinvdetalle_id])
    @contratosperdetallesdoc = Contratosperdetallesdoc.new
  end

  def create
    @contratosperinvdetalle = Contratosperinvdetalle.find(params[:contratosperinvdetalle_id])
    @contratosperdetallesdoc = Contratosperdetallesdoc.new(contratosperdetallesdoc_params)
    @contratosperdetallesdoc.contratosperinvdetalle_id = @contratosperinvdetalle.id
    @contratosperdetallesdoc.user_id = is_admin
    respond_to do |format|
      if @contratosperdetallesdoc.save
        flash['success'] = "Documento cargado con exito"
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperdetallesdoc } }
      end
    end
  end


  def update
    respond_to do |format|
      if @contratosperdetallesdoc.update(contratosperdetallesdoc_params)
        format.html { redirect_to @contratosperdetallesdoc, notice: 'Contratosperdetallesdoc was successfully updated.' }
        format.json { render :show, status: :ok, location: @contratosperdetallesdoc }
      else
        format.html { render :edit }
        format.json { render json: @contratosperdetallesdoc.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @contratosperinvdetalle = Contratosperinvdetalle.find(params[:contratosperinvdetalle_id])
    @contratosperdetallesdoc = Contratosperdetallesdoc.find(params[:id])
    @contratosperdetallesdoc.destroy
    respond_to do |format|
      format.html { redirect_to complemento_contratosperinventarios_path(id: @contratosperinvdetalle.contratosperinventario_id, etapa: 'A'), notice: 'Se ha eliminado con exito!!!' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contratosperdetallesdoc
    @contratosperdetallesdoc = Contratosperdetallesdoc.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosperdetallesdoc_params
    params.require(:contratosperdetallesdoc).permit!
  end
end
