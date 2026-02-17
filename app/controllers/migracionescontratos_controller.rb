class MigracionescontratosController < ApplicationController
  before_action :set_migracionescontrato, only: [:show, :edit, :update, :destroy]

  # GET /migracionescontratos
  # GET /migracionescontratos.json
  def index
    @migracionescontratos = Migracionescontrato.all
  end

  # GET /migracionescontratos/1
  # GET /migracionescontratos/1.json
  def show
  end

  # GET /migracionescontratos/new
  def new
    @migracionescontrato = Migracionescontrato.new
  end

  # GET /migracionescontratos/1/edit
  def edit
  end

  # POST /migracionescontratos
  # POST /migracionescontratos.json
  def create
    @migracionescontrato = Migracionescontrato.new(migracionescontrato_params)

    respond_to do |format|
      if @migracionescontrato.save
        format.html { redirect_to @migracionescontrato, notice: 'Migracionescontrato was successfully created.' }
        format.json { render :show, status: :created, location: @migracionescontrato }
      else
        format.html { render :new }
        format.json { render json: @migracionescontrato.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /migracionescontratos/1
  # PATCH/PUT /migracionescontratos/1.json
  def update
    respond_to do |format|
      if @migracionescontrato.update(migracionescontrato_params)
        format.html { redirect_to @migracionescontrato, notice: 'Migracionescontrato was successfully updated.' }
        format.json { render :show, status: :ok, location: @migracionescontrato }
      else
        format.html { render :edit }
        format.json { render json: @migracionescontrato.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /migracionescontratos/1
  # DELETE /migracionescontratos/1.json
  def destroy
    @migracionescontrato.destroy
    respond_to do |format|
      format.html { redirect_to migracionescontratos_url, notice: 'Migracionescontrato was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_migracionescontrato
      @migracionescontrato = Migracionescontrato.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def migracionescontrato_params
      params.require(:migracionescontrato).permit(:user_id, :archivo_id, :estado, :identificacion, :contratoscargo_id, :contratosgrupo_id, :fecha_inicio)
    end
end
