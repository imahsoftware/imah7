class MigracionespersonasController < ApplicationController
  before_action :set_migracionespersona, only: [:show, :edit, :update, :destroy]

  # GET /migracionespersonas
  # GET /migracionespersonas.json
  def index
    @migracionespersonas = Migracionespersona.all
  end

  def generar

  end

  # GET /migracionespersonas/1
  # GET /migracionespersonas/1.json
  def show
  end

  # GET /migracionespersonas/new
  def new
    @migracionespersona = Migracionespersona.new
  end

  # GET /migracionespersonas/1/edit
  def edit
  end

  # POST /migracionespersonas
  # POST /migracionespersonas.json
  def create
    @migracionespersona = Migracionespersona.new(migracionespersona_params)

    respond_to do |format|
      if @migracionespersona.save
        format.html { redirect_to @migracionespersona, notice: 'Migracionespersona was successfully created.' }
        format.json { render :show, status: :created, location: @migracionespersona }
      else
        format.html { render :new }
        format.json { render json: @migracionespersona.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /migracionespersonas/1
  # PATCH/PUT /migracionespersonas/1.json
  def update
    respond_to do |format|
      if @migracionespersona.update(migracionespersona_params)
        format.html { redirect_to @migracionespersona, notice: 'Migracionespersona was successfully updated.' }
        format.json { render :show, status: :ok, location: @migracionespersona }
      else
        format.html { render :edit }
        format.json { render json: @migracionespersona.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /migracionespersonas/1
  # DELETE /migracionespersonas/1.json
  def destroy
    @migracionespersona.destroy
    respond_to do |format|
      format.html { redirect_to migracionespersonas_url, notice: 'Migracionespersona was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_migracionespersona
      @migracionespersona = Migracionespersona.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def migracionespersona_params
      params.require(:migracionespersona).permit(:user_id, :archivo_id, :lote, :identificacion, :nombre, :celular, :correo, :cargo_id, :observacion, :municipio, :departamento, :colegio, :estado_sms, :estado_correo, :estado_cargue, :error)
    end
end
