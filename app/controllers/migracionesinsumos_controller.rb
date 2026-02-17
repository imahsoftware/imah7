class MigracionesinsumosController < ApplicationController
  before_action :set_migracionesinsumo, only: [:show, :edit, :update, :destroy]

  # GET /migracionesinsumos
  # GET /migracionesinsumos.json
  def index
    @migracionesinsumos = Migracionesinsumo.all
  end

  # GET /migracionesinsumos/1
  # GET /migracionesinsumos/1.json
  def show
  end

  # GET /migracionesinsumos/new
  def new
    @migracionesinsumo = Migracionesinsumo.new
  end

  # GET /migracionesinsumos/1/edit
  def edit
  end

  # POST /migracionesinsumos
  # POST /migracionesinsumos.json
  def create
    @migracionesinsumo = Migracionesinsumo.new(migracionesinsumo_params)

    respond_to do |format|
      if @migracionesinsumo.save
        format.html { redirect_to @migracionesinsumo, notice: 'Migracionesinsumo was successfully created.' }
        format.json { render :show, status: :created, location: @migracionesinsumo }
      else
        format.html { render :new }
        format.json { render json: @migracionesinsumo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /migracionesinsumos/1
  # PATCH/PUT /migracionesinsumos/1.json
  def update
    respond_to do |format|
      if @migracionesinsumo.update(migracionesinsumo_params)
        format.html { redirect_to @migracionesinsumo, notice: 'Migracionesinsumo was successfully updated.' }
        format.json { render :show, status: :ok, location: @migracionesinsumo }
      else
        format.html { render :edit }
        format.json { render json: @migracionesinsumo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /migracionesinsumos/1
  # DELETE /migracionesinsumos/1.json
  def destroy
    @migracionesinsumo.destroy
    respond_to do |format|
      format.html { redirect_to migracionesinsumos_url, notice: 'Migracionesinsumo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_migracionesinsumo
      @migracionesinsumo = Migracionesinsumo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def migracionesinsumo_params
      params.require(:migracionesinsumo).permit(:user_id, :archivo_id, :estado, :contrato_id, :insumo_id, :cantidad_mensual, :precio_unitario, :descuento, :precio_condescuento, :total)
    end
end
