class MigracionesactividadesController < ApplicationController
  before_action :set_migracionesactividad, only: [:show, :edit, :update, :destroy]

  # GET /migracionesactividades
  # GET /migracionesactividades.json
  def index
    @migracionesactividades = Migracionesactividad.all
  end

  # GET /migracionesactividades/1
  # GET /migracionesactividades/1.json
  def show
  end

  # GET /migracionesactividades/new
  def new
    @migracionesactividad = Migracionesactividad.new
  end

  # GET /migracionesactividades/1/edit
  def edit
  end

  # POST /migracionesactividades
  # POST /migracionesactividades.json
  def create
    @migracionesactividad = Migracionesactividad.new(migracionesactividad_params)

    respond_to do |format|
      if @migracionesactividad.save
        format.html { redirect_to @migracionesactividad, notice: 'Migracionesactividad was successfully created.' }
        format.json { render :show, status: :created, location: @migracionesactividad }
      else
        format.html { render :new }
        format.json { render json: @migracionesactividad.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /migracionesactividades/1
  # PATCH/PUT /migracionesactividades/1.json
  def update
    respond_to do |format|
      if @migracionesactividad.update(migracionesactividad_params)
        format.html { redirect_to @migracionesactividad, notice: 'Migracionesactividad was successfully updated.' }
        format.json { render :show, status: :ok, location: @migracionesactividad }
      else
        format.html { render :edit }
        format.json { render json: @migracionesactividad.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /migracionesactividades/1
  # DELETE /migracionesactividades/1.json
  def destroy
    @migracionesactividad.destroy
    respond_to do |format|
      format.html { redirect_to migracionesactividades_url, notice: 'Migracionesactividad was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_migracionesactividad
      @migracionesactividad = Migracionesactividad.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def migracionesactividad_params
      params.require(:migracionesactividad).permit(:user_id, :archivo_id, :estado, :tareasactividad_id, :dias, :estado_actividad, :user_persona)
    end
end
