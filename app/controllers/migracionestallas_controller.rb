class MigracionestallasController < ApplicationController
  before_action :set_migracionestalla, only: [:show, :edit, :update, :destroy]

  # GET /migracionestallas
  # GET /migracionestallas.json
  def index
    @migracionestallas = Migracionestalla.all
  end

  # GET /migracionestallas/1
  # GET /migracionestallas/1.json
  def show
  end

  # GET /migracionestallas/new
  def new
    @migracionestalla = Migracionestalla.new
  end

  # GET /migracionestallas/1/edit
  def edit
  end

  # POST /migracionestallas
  # POST /migracionestallas.json
  def create
    @migracionestalla = Migracionestalla.new(migracionestalla_params)

    respond_to do |format|
      if @migracionestalla.save
        format.html { redirect_to @migracionestalla, notice: 'Migracionestalla was successfully created.' }
        format.json { render :show, status: :created, location: @migracionestalla }
      else
        format.html { render :new }
        format.json { render json: @migracionestalla.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /migracionestallas/1
  # PATCH/PUT /migracionestallas/1.json
  def update
    respond_to do |format|
      if @migracionestalla.update(migracionestalla_params)
        format.html { redirect_to @migracionestalla, notice: 'Migracionestalla was successfully updated.' }
        format.json { render :show, status: :ok, location: @migracionestalla }
      else
        format.html { render :edit }
        format.json { render json: @migracionestalla.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /migracionestallas/1
  # DELETE /migracionestallas/1.json
  def destroy
    @migracionestalla.destroy
    respond_to do |format|
      format.html { redirect_to migracionestallas_url, notice: 'Migracionestalla was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_migracionestalla
      @migracionestalla = Migracionestalla.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def migracionestalla_params
      params.require(:migracionestalla).permit!
    end
end
