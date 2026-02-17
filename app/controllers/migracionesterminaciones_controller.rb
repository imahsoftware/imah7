class MigracionesterminacionesController < ApplicationController
  before_action :set_migracionesterminacion, only: [:show, :edit, :update, :destroy]

  # GET /migracionesterminaciones
  # GET /migracionesterminaciones.json
  def index
    @migracionesterminaciones = Migracionesterminacion.all
  end

  # GET /migracionesterminaciones/1
  # GET /migracionesterminaciones/1.json
  def show
  end

  # GET /migracionesterminaciones/new
  def new
    @migracionesterminacion = Migracionesterminacion.new
  end

  # GET /migracionesterminaciones/1/edit
  def edit
  end

  # POST /migracionesterminaciones
  # POST /migracionesterminaciones.json
  def create
    @migracionesterminacion = Migracionesterminacion.new(migracionesterminacion_params)

    respond_to do |format|
      if @migracionesterminacion.save
        format.html { redirect_to @migracionesterminacion, notice: 'Migracionesterminacion was successfully created.' }
        format.json { render :show, status: :created, location: @migracionesterminacion }
      else
        format.html { render :new }
        format.json { render json: @migracionesterminacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /migracionesterminaciones/1
  # PATCH/PUT /migracionesterminaciones/1.json
  def update
    respond_to do |format|
      if @migracionesterminacion.update(migracionesterminacion_params)
        format.html { redirect_to @migracionesterminacion, notice: 'Migracionesterminacion was successfully updated.' }
        format.json { render :show, status: :ok, location: @migracionesterminacion }
      else
        format.html { render :edit }
        format.json { render json: @migracionesterminacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /migracionesterminaciones/1
  # DELETE /migracionesterminaciones/1.json
  def destroy
    @migracionesterminacion.destroy
    respond_to do |format|
      format.html { redirect_to migracionesterminaciones_url, notice: 'Migracionesterminacion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_migracionesterminacion
      @migracionesterminacion = Migracionesterminacion.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def migracionesterminacion_params
      params.require(:migracionesterminacion).permit(:user_id, :archivo_id, :estado, :identificacion, :contratosperfecha_id, :contratospersona_id, :fecha_fin, :contratospervalidacion)
    end
end
