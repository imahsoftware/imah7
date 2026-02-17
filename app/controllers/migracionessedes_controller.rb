class MigracionessedesController < ApplicationController
  before_action :set_migracionessede, only: [:show, :edit, :update, :destroy]

  # GET /migracionessedes
  # GET /migracionessedes.json
  def index
    @migracionessedes = Migracionessede.all
  end

  # GET /migracionessedes/1
  # GET /migracionessedes/1.json
  def show
  end

  # GET /migracionessedes/new
  def new
    @migracionessede = Migracionessede.new
  end

  # GET /migracionessedes/1/edit
  def edit
  end

  # POST /migracionessedes
  # POST /migracionessedes.json
  def create
    @migracionessede = Migracionessede.new(migracionessede_params)

    respond_to do |format|
      if @migracionessede.save
        format.html { redirect_to @migracionessede, notice: 'Migracionessede was successfully created.' }
        format.json { render :show, status: :created, location: @migracionessede }
      else
        format.html { render :new }
        format.json { render json: @migracionessede.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /migracionessedes/1
  # PATCH/PUT /migracionessedes/1.json
  def update
    respond_to do |format|
      if @migracionessede.update(migracionessede_params)
        format.html { redirect_to @migracionessede, notice: 'Migracionessede was successfully updated.' }
        format.json { render :show, status: :ok, location: @migracionessede }
      else
        format.html { render :edit }
        format.json { render json: @migracionessede.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /migracionessedes/1
  # DELETE /migracionessedes/1.json
  def destroy
    @migracionessede.destroy
    respond_to do |format|
      format.html { redirect_to migracionessedes_url, notice: 'Migracionessede was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_migracionessede
      @migracionessede = Migracionessede.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def migracionessede_params
      params.require(:migracionessede).permit(:user_id, :archivo_id, :estado, :contrato_id, :nombre, :direccion, :ordensede, :departamento, :municipio)
    end
end
