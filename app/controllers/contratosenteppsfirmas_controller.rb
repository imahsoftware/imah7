class ContratosenteppsfirmasController < ApplicationController
  before_action :set_contratosenteppsfirma, only: [:show, :edit, :update, :destroy]

  # GET /contratosenteppsfirmas
  # GET /contratosenteppsfirmas.json
  def index
    @contratosenteppsfirmas = Contratosenteppsfirma.all
  end

  # GET /contratosenteppsfirmas/1
  # GET /contratosenteppsfirmas/1.json
  def show
  end

  # GET /contratosenteppsfirmas/new
  def new
    @contratosenteppsfirma = Contratosenteppsfirma.new
  end

  # GET /contratosenteppsfirmas/1/edit
  def edit
  end

  # POST /contratosenteppsfirmas
  # POST /contratosenteppsfirmas.json
  def create
    @contratosenteppsfirma = Contratosenteppsfirma.new(contratosenteppsfirma_params)

    respond_to do |format|
      if @contratosenteppsfirma.save
        format.html { redirect_to @contratosenteppsfirma, notice: 'Contratosenteppsfirma was successfully created.' }
        format.json { render :show, status: :created, location: @contratosenteppsfirma }
      else
        format.html { render :new }
        format.json { render json: @contratosenteppsfirma.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contratosenteppsfirmas/1
  # PATCH/PUT /contratosenteppsfirmas/1.json
  def update
    respond_to do |format|
      if @contratosenteppsfirma.update(contratosenteppsfirma_params)
        format.html { redirect_to @contratosenteppsfirma, notice: 'Contratosenteppsfirma was successfully updated.' }
        format.json { render :show, status: :ok, location: @contratosenteppsfirma }
      else
        format.html { render :edit }
        format.json { render json: @contratosenteppsfirma.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contratosenteppsfirmas/1
  # DELETE /contratosenteppsfirmas/1.json
  def destroy
    @contratosenteppsfirma.destroy
    respond_to do |format|
      format.html { redirect_to contratosenteppsfirmas_url, notice: 'Contratosenteppsfirma was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contratosenteppsfirma
      @contratosenteppsfirma = Contratosenteppsfirma.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def contratosenteppsfirma_params
      params.require(:contratosenteppsfirma).permit(:contratosentepp_id, :contratosperfecha_id, :codigo_firma, :fecha_firma, :codigo_env, :codigo_rec)
    end
end
