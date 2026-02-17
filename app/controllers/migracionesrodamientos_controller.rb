class MigracionesrodamientosController < ApplicationController
  before_action :set_migracionesrodamiento, only: [:show, :edit, :update, :destroy]

  # GET /migracionesrodamientos
  # GET /migracionesrodamientos.json
  def index
    @migracionesrodamientos = Migracionesrodamiento.all
  end

  # GET /migracionesrodamientos/1
  # GET /migracionesrodamientos/1.json
  def show
  end

  # GET /migracionesrodamientos/new
  def new
    @migracionesrodamiento = Migracionesrodamiento.new
  end

  # GET /migracionesrodamientos/1/edit
  def edit
  end

  # POST /migracionesrodamientos
  # POST /migracionesrodamientos.json
  def create
    @migracionesrodamiento = Migracionesrodamiento.new(migracionesrodamiento_params)

    respond_to do |format|
      if @migracionesrodamiento.save
        format.html { redirect_to @migracionesrodamiento, notice: 'Migracionesrodamiento was successfully created.' }
        format.json { render :show, status: :created, location: @migracionesrodamiento }
      else
        format.html { render :new }
        format.json { render json: @migracionesrodamiento.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /migracionesrodamientos/1
  # PATCH/PUT /migracionesrodamientos/1.json
  def update
    respond_to do |format|
      if @migracionesrodamiento.update(migracionesrodamiento_params)
        format.html { redirect_to @migracionesrodamiento, notice: 'Migracionesrodamiento was successfully updated.' }
        format.json { render :show, status: :ok, location: @migracionesrodamiento }
      else
        format.html { render :edit }
        format.json { render json: @migracionesrodamiento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /migracionesrodamientos/1
  # DELETE /migracionesrodamientos/1.json
  def destroy
    @migracionesrodamiento.destroy
    respond_to do |format|
      format.html { redirect_to migracionesrodamientos_url, notice: 'Migracionesrodamiento was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_migracionesrodamiento
      @migracionesrodamiento = Migracionesrodamiento.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def migracionesrodamiento_params
      params.require(:migracionesrodamiento).permit(:user_id, :archivo_id, :estado, :contrato_id, :periodosliquidacion_id, :identificacion, :nombre, :detalle, :valor_dia, :nro_dias, :valor_total)
    end
end
