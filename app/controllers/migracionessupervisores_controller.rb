class MigracionessupervisoresController < ApplicationController
  before_action :set_migracionessupervisor, only: [:show, :edit, :update, :destroy]

  # GET /migracionessupervisores
  # GET /migracionessupervisores.json
  def index
    @migracionessupervisores = Migracionessupervisor.all
  end

  # GET /migracionessupervisores/1
  # GET /migracionessupervisores/1.json
  def show
  end

  # GET /migracionessupervisores/new
  def new
    @migracionessupervisor = Migracionessupervisor.new
  end

  # GET /migracionessupervisores/1/edit
  def edit
  end

  # POST /migracionessupervisores
  # POST /migracionessupervisores.json
  def create
    @migracionessupervisor = Migracionessupervisor.new(migracionessupervisor_params)

    respond_to do |format|
      if @migracionessupervisor.save
        format.html { redirect_to @migracionessupervisor, notice: 'Migracionessupervisor was successfully created.' }
        format.json { render :show, status: :created, location: @migracionessupervisor }
      else
        format.html { render :new }
        format.json { render json: @migracionessupervisor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /migracionessupervisores/1
  # PATCH/PUT /migracionessupervisores/1.json
  def update
    respond_to do |format|
      if @migracionessupervisor.update(migracionessupervisor_params)
        format.html { redirect_to @migracionessupervisor, notice: 'Migracionessupervisor was successfully updated.' }
        format.json { render :show, status: :ok, location: @migracionessupervisor }
      else
        format.html { render :edit }
        format.json { render json: @migracionessupervisor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /migracionessupervisores/1
  # DELETE /migracionessupervisores/1.json
  def destroy
    @migracionessupervisor.destroy
    respond_to do |format|
      format.html { redirect_to migracionessupervisores_url, notice: 'Migracionessupervisor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_migracionessupervisor
      @migracionessupervisor = Migracionessupervisor.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def migracionessupervisor_params
      params.require(:migracionessupervisor).permit(:user_id, :archivo_id, :estado, :identificacion, :userasig_id)
    end
end
