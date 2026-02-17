class MigracionesreportesController < ApplicationController
  before_action :set_migracionesreporte, only: [:show, :edit, :update, :destroy]

  # GET /migracionesreportes
  # GET /migracionesreportes.json
  def index
    @migracionesreportes = Migracionesreporte.all
  end

  # GET /migracionesreportes/1
  # GET /migracionesreportes/1.json
  def show
  end

  # GET /migracionesreportes/new
  def new
    @migracionesreporte = Migracionesreporte.new
  end

  # GET /migracionesreportes/1/edit
  def edit
  end

  # POST /migracionesreportes
  # POST /migracionesreportes.json
  def create
    @migracionesreporte = Migracionesreporte.new(migracionesreporte_params)

    respond_to do |format|
      if @migracionesreporte.save
        format.html { redirect_to @migracionesreporte, notice: 'Migracionesreporte was successfully created.' }
        format.json { render :show, status: :created, location: @migracionesreporte }
      else
        format.html { render :new }
        format.json { render json: @migracionesreporte.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /migracionesreportes/1
  # PATCH/PUT /migracionesreportes/1.json
  def update
    respond_to do |format|
      if @migracionesreporte.update(migracionesreporte_params)
        format.html { redirect_to @migracionesreporte, notice: 'Migracionesreporte was successfully updated.' }
        format.json { render :show, status: :ok, location: @migracionesreporte }
      else
        format.html { render :edit }
        format.json { render json: @migracionesreporte.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /migracionesreportes/1
  # DELETE /migracionesreportes/1.json
  def destroy
    @migracionesreporte.destroy
    respond_to do |format|
      format.html { redirect_to migracionesreportes_url, notice: 'Migracionesreporte was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_migracionesreporte
      @migracionesreporte = Migracionesreporte.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def migracionesreporte_params
      params.require(:migracionesreporte).permit(:user_id, :consecutivo, :persona_id, :identificacion, :cli_numdcto, :est_codigo, :cli_nombre_comp, :correo_personal, :correo_institucional, :telefono_residencia, :telefono_movil, :direccion, :nivel_academico, :programa, :niv_formacion, :metodologia, :liquidacion, :estado_liq, :valor_liq, :valor_matricula, :seccional, :tip_estudiante, :periodo_liq, :max_periodo_matric, :fecha_pago, :fecha_generacion, :tipo_aspirante, :est_sem_academico, :est_sem_aprobado, :promedio_acumulado, :promedio_semestre, :semestre_pensum, :caus_virtual, :genero, :ciudad_res, :depto, :barrio, :departamento, :cod_jornada, :jornada, :ano_grado_colegio, :periodo_real, :programa_ajustado, :cod_programa, :niv_formacion2, :facultad, :extrae_ta, :tipo_aspirante2, :seccional2, :tip_estudianteti, :est_sem_academico2, :depto_conca, :nombre_csu, :tipo_csu, :ciudad_csu, :departamento_csu, :region_csu, :estado_csu, :grupo_virtual, :edad, :red, :transferencias_internas)
    end
end
