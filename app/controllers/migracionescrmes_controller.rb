class MigracionescrmesController < ApplicationController
  before_action :set_migracionescrm, only: [:show, :edit, :update, :destroy]

  # GET /migracionescrmes
  # GET /migracionescrmes.json
  def index
    @migracionescrmes = Migracionescrm.all
  end

  # GET /migracionescrmes/1
  # GET /migracionescrmes/1.json
  def show
  end

  # GET /migracionescrmes/new
  def new
    @migracionescrm = Migracionescrm.new
  end

  # GET /migracionescrmes/1/edit
  def edit
  end

  # POST /migracionescrmes
  # POST /migracionescrmes.json
  def create
    @migracionescrm = Migracionescrm.new(migracionescrm_params)

    respond_to do |format|
      if @migracionescrm.save
        format.html { redirect_to @migracionescrm, notice: 'Migracionescrm was successfully created.' }
        format.json { render :show, status: :created, location: @migracionescrm }
      else
        format.html { render :new }
        format.json { render json: @migracionescrm.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /migracionescrmes/1
  # PATCH/PUT /migracionescrmes/1.json
  def update
    respond_to do |format|
      if @migracionescrm.update(migracionescrm_params)
        format.html { redirect_to @migracionescrm, notice: 'Migracionescrm was successfully updated.' }
        format.json { render :show, status: :ok, location: @migracionescrm }
      else
        format.html { render :edit }
        format.json { render json: @migracionescrm.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /migracionescrmes/1
  # DELETE /migracionescrmes/1.json
  def destroy
    @migracionescrm.destroy
    respond_to do |format|
      format.html { redirect_to migracionescrmes_url, notice: 'Migracionescrm was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_migracionescrm
      @migracionescrm = Migracionescrm.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def migracionescrm_params
      params.require(:migracionescrm).permit(:user_id, :consecutivo, :persona_id, :detalle, :checksum, :fecha_modificacion, :primer, :site, :autor, :nombre, :oportunidad, :tipo_oportunidad, :estudiante, :identificacion, :telefono, :correo, :enrollment, :sub_enrollment, :carrera, :tipo_carrera, :modalidad, :origen_carga, :periodo, :sub_periodo, :fecha_creacion, :estado)
    end
end
