class MigracionesprorrogasController < ApplicationController
  before_action :set_migracionesprorroga, only: [:show, :edit, :update, :destroy]

  # GET /migracionesprorrogas
  # GET /migracionesprorrogas.json
  def index
    @migracionesprorrogas = Migracionesprorroga.all
  end

  # GET /migracionesprorrogas/1
  # GET /migracionesprorrogas/1.json
  def show
  end

  # GET /migracionesprorrogas/new
  def new
    @migracionesprorroga = Migracionesprorroga.new
  end

  # GET /migracionesprorrogas/1/edit
  def edit
  end

  # POST /migracionesprorrogas
  # POST /migracionesprorrogas.json
  def create
    @migracionesprorroga = Migracionesprorroga.new(migracionesprorroga_params)

    respond_to do |format|
      if @migracionesprorroga.save
        format.html { redirect_to @migracionesprorroga, notice: 'Migracionesprorroga was successfully created.' }
        format.json { render :show, status: :created, location: @migracionesprorroga }
      else
        format.html { render :new }
        format.json { render json: @migracionesprorroga.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /migracionesprorrogas/1
  # PATCH/PUT /migracionesprorrogas/1.json
  def update
    respond_to do |format|
      if @migracionesprorroga.update(migracionesprorroga_params)
        format.html { redirect_to @migracionesprorroga, notice: 'Migracionesprorroga was successfully updated.' }
        format.json { render :show, status: :ok, location: @migracionesprorroga }
      else
        format.html { render :edit }
        format.json { render json: @migracionesprorroga.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /migracionesprorrogas/1
  # DELETE /migracionesprorrogas/1.json
  def destroy
    @migracionesprorroga.destroy
    respond_to do |format|
      format.html { redirect_to migracionesprorrogas_url, notice: 'Migracionesprorroga was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_migracionesprorroga
      @migracionesprorroga = Migracionesprorroga.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def migracionesprorroga_params
      params.require(:migracionesprorroga).permit(:user_id, :archivo_id, :estado, :identificacion, :contratosperfecha_id, :contratospersona_id, :fecha_fin)
    end
end
