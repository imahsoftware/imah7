class MigracionesnovedadesController < ApplicationController
  before_action :set_migracionesnovedad, only: [:show, :edit, :update, :destroy]

  # GET /migracionesnovedades
  # GET /migracionesnovedades.json
  def index
    @migracionesnovedades = Migracionesnovedad.all
  end

  # GET /migracionesnovedades/1
  # GET /migracionesnovedades/1.json
  def show
  end

  # GET /migracionesnovedades/new
  def new
    @migracionesnovedad = Migracionesnovedad.new
  end

  # GET /migracionesnovedades/1/edit
  def edit
  end

  # POST /migracionesnovedades
  # POST /migracionesnovedades.json
  def create
    @migracionesnovedad = Migracionesnovedad.new(migracionesnovedad_params)

    respond_to do |format|
      if @migracionesnovedad.save
        format.html { redirect_to @migracionesnovedad, notice: 'Migracionesnovedad was successfully created.' }
        format.json { render :show, status: :created, location: @migracionesnovedad }
      else
        format.html { render :new }
        format.json { render json: @migracionesnovedad.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /migracionesnovedades/1
  # PATCH/PUT /migracionesnovedades/1.json
  def update
    respond_to do |format|
      if @migracionesnovedad.update(migracionesnovedad_params)
        format.html { redirect_to @migracionesnovedad, notice: 'Migracionesnovedad was successfully updated.' }
        format.json { render :show, status: :ok, location: @migracionesnovedad }
      else
        format.html { render :edit }
        format.json { render json: @migracionesnovedad.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /migracionesnovedades/1
  # DELETE /migracionesnovedades/1.json
  def destroy
    @migracionesnovedad.destroy
    respond_to do |format|
      format.html { redirect_to migracionesnovedades_url, notice: 'Migracionesnovedad was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_migracionesnovedad
      @migracionesnovedad = Migracionesnovedad.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def migracionesnovedad_params
      params.require(:migracionesnovedad).permit(:user_id, :archivo_id, :estado, :contrato_id, :periodosliquidacion_id, :contratospersona_id, :contratosgrupo_id, :identificacion, :nov_1, :nov_2, :nov_3, :nov_4, :nov_5, :nov_6, :nov_7, :nov_8, :nov_9, :nov_10, :nov_11, :nov_12, :nov_14, :nov_16, :nov_18, :nov_19, :nov_22, :nov_40, :nov_41, :nov_42, :nov_43, :nov_44, :nov_46, :nov_47, :nov_49, :nov_50, :nov_53, :nov_55, :nov_56, :nov_57, :observacion)
    end
end
