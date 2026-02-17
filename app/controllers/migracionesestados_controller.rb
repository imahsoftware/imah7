class MigracionesestadosController < ApplicationController
  before_action :set_migracionesestado, only: [:show, :edit, :update, :destroy]

  # GET /migracionesestados
  # GET /migracionesestados.json
  def index
    @migracionesestados = Migracionesestado.all
  end

  # GET /migracionesestados/1
  # GET /migracionesestados/1.json
  def show
  end

  # GET /migracionesestados/new
  def new
    @migracionesestado = Migracionesestado.new
  end

  # GET /migracionesestados/1/edit
  def edit
  end

  # POST /migracionesestados
  # POST /migracionesestados.json
  def create
    @migracionesestado = Migracionesestado.new(migracionesestado_params)

    respond_to do |format|
      if @migracionesestado.save
        format.html { redirect_to @migracionesestado, notice: 'Migracionesestado was successfully created.' }
        format.json { render :show, status: :created, location: @migracionesestado }
      else
        format.html { render :new }
        format.json { render json: @migracionesestado.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /migracionesestados/1
  # PATCH/PUT /migracionesestados/1.json
  def update
    respond_to do |format|
      if @migracionesestado.update(migracionesestado_params)
        format.html { redirect_to @migracionesestado, notice: 'Migracionesestado was successfully updated.' }
        format.json { render :show, status: :ok, location: @migracionesestado }
      else
        format.html { render :edit }
        format.json { render json: @migracionesestado.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /migracionesestados/1
  # DELETE /migracionesestados/1.json
  def destroy
    @migracionesestado.destroy
    respond_to do |format|
      format.html { redirect_to migracionesestados_url, notice: 'Migracionesestado was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_migracionesestado
      @migracionesestado = Migracionesestado.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def migracionesestado_params
      params.require(:migracionesestado).permit(:personasformulario_id, :user_id, :archivo_id, :estado, :observacion_eps, :estado_cargue, :error, :tipo)
    end
end
