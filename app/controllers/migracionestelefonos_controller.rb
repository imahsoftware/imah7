class MigracionestelefonosController < ApplicationController
  before_action :set_migracionestelefono, only: [:show, :edit, :update, :destroy]

  # GET /migracionestelefonos
  # GET /migracionestelefonos.json
  def index
    @migracionestelefonos = Migracionestelefono.all
  end

  # GET /migracionestelefonos/1
  # GET /migracionestelefonos/1.json
  def show
  end

  # GET /migracionestelefonos/new
  def new
    @migracionestelefono = Migracionestelefono.new
  end

  # GET /migracionestelefonos/1/edit
  def edit
  end

  # POST /migracionestelefonos
  # POST /migracionestelefonos.json
  def create
    @migracionestelefono = Migracionestelefono.new(migracionestelefono_params)

    respond_to do |format|
      if @migracionestelefono.save
        format.html { redirect_to @migracionestelefono, notice: 'Migracionestelefono was successfully created.' }
        format.json { render :show, status: :created, location: @migracionestelefono }
      else
        format.html { render :new }
        format.json { render json: @migracionestelefono.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /migracionestelefonos/1
  # PATCH/PUT /migracionestelefonos/1.json
  def update
    respond_to do |format|
      if @migracionestelefono.update(migracionestelefono_params)
        format.html { redirect_to @migracionestelefono, notice: 'Migracionestelefono was successfully updated.' }
        format.json { render :show, status: :ok, location: @migracionestelefono }
      else
        format.html { render :edit }
        format.json { render json: @migracionestelefono.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /migracionestelefonos/1
  # DELETE /migracionestelefonos/1.json
  def destroy
    @migracionestelefono.destroy
    respond_to do |format|
      format.html { redirect_to migracionestelefonos_url, notice: 'Migracionestelefono was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_migracionestelefono
      @migracionestelefono = Migracionestelefono.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def migracionestelefono_params
      params.require(:migracionestelefono).permit!
    end
end
