class MigracionesexamenesController < ApplicationController
  before_action :set_migracionesexamen, only: [:show, :edit, :update, :destroy]

  # GET /migracionesexamenes
  # GET /migracionesexamenes.json
  def index
    @migracionesexamenes = Migracionesexamen.all
  end

  # GET /migracionesexamenes/1
  # GET /migracionesexamenes/1.json
  def show
  end

  # GET /migracionesexamenes/new
  def new
    @migracionesexamen = Migracionesexamen.new
  end

  # GET /migracionesexamenes/1/edit
  def edit
  end

  # POST /migracionesexamenes
  # POST /migracionesexamenes.json
  def create
    @migracionesexamen = Migracionesexamen.new(migracionesexamen_params)

    respond_to do |format|
      if @migracionesexamen.save
        format.html { redirect_to @migracionesexamen, notice: 'Migracionesexamen was successfully created.' }
        format.json { render :show, status: :created, location: @migracionesexamen }
      else
        format.html { render :new }
        format.json { render json: @migracionesexamen.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /migracionesexamenes/1
  # PATCH/PUT /migracionesexamenes/1.json
  def update
    respond_to do |format|
      if @migracionesexamen.update(migracionesexamen_params)
        format.html { redirect_to @migracionesexamen, notice: 'Migracionesexamen was successfully updated.' }
        format.json { render :show, status: :ok, location: @migracionesexamen }
      else
        format.html { render :edit }
        format.json { render json: @migracionesexamen.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /migracionesexamenes/1
  # DELETE /migracionesexamenes/1.json
  def destroy
    @migracionesexamen.destroy
    respond_to do |format|
      format.html { redirect_to migracionesexamenes_url, notice: 'Migracionesexamen was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_migracionesexamen
      @migracionesexamen = Migracionesexamen.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def migracionesexamen_params
      params.require(:migracionesexamen).permit(:personasformulario_id, :user_id, :archivo_id, :descripcion, :direccion, :recomendaciones, :fecha, :hora, :estado, :observacion_eps, :estado_cargue, :error)
    end
end
