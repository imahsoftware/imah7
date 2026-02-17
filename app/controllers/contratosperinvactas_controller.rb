class ContratosperinvactasController < ApplicationController
  before_action :set_contratosperinvacta, only: [:show, :edit, :update, :destroy]

  # GET /contratosperinvactas
  # GET /contratosperinvactas.json
  def index
    @contratosperinvactas = Contratosperinvacta.all
  end

  # GET /contratosperinvactas/1
  # GET /contratosperinvactas/1.json
  def show
  end

  # GET /contratosperinvactas/new
  def new
    @contratosperinvacta = Contratosperinvacta.new
  end

  # GET /contratosperinvactas/1/edit
  def edit
  end

  # POST /contratosperinvactas
  # POST /contratosperinvactas.json
  def create
    @contratosperinvacta = Contratosperinvacta.new(contratosperinvacta_params)

    respond_to do |format|
      if @contratosperinvacta.save
        format.html { redirect_to @contratosperinvacta, notice: 'Contratosperinvacta was successfully created.' }
        format.json { render :show, status: :created, location: @contratosperinvacta }
      else
        format.html { render :new }
        format.json { render json: @contratosperinvacta.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contratosperinvactas/1
  # PATCH/PUT /contratosperinvactas/1.json
  def update
    respond_to do |format|
      if @contratosperinvacta.update(contratosperinvacta_params)
        format.html { redirect_to @contratosperinvacta, notice: 'Contratosperinvacta was successfully updated.' }
        format.json { render :show, status: :ok, location: @contratosperinvacta }
      else
        format.html { render :edit }
        format.json { render json: @contratosperinvacta.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contratosperinvactas/1
  # DELETE /contratosperinvactas/1.json
  def destroy
    @contratosperinvacta.destroy
    respond_to do |format|
      format.html { redirect_to contratosperinvactas_url, notice: 'Contratosperinvacta was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contratosperinvacta
      @contratosperinvacta = Contratosperinvacta.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def contratosperinvacta_params
      params.require(:contratosperinvacta).permit(:contratosperinventario_id, :consecutivo_acta)
    end
end
