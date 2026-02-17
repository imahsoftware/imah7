class MigracionescuentasController < ApplicationController
  before_action :set_migracionescuenta, only: [:show, :edit, :update, :destroy]

  # GET /migracionescuentas
  # GET /migracionescuentas.json
  def index
    @migracionescuentas = Migracionescuenta.all
  end

  # GET /migracionescuentas/1
  # GET /migracionescuentas/1.json
  def show
  end

  # GET /migracionescuentas/new
  def new
    @migracionescuenta = Migracionescuenta.new
  end

  # GET /migracionescuentas/1/edit
  def edit
  end

  # POST /migracionescuentas
  # POST /migracionescuentas.json
  def create
    @migracionescuenta = Migracionescuenta.new(migracionescuenta_params)

    respond_to do |format|
      if @migracionescuenta.save
        format.html { redirect_to @migracionescuenta, notice: 'Migracionescuenta was successfully created.' }
        format.json { render :show, status: :created, location: @migracionescuenta }
      else
        format.html { render :new }
        format.json { render json: @migracionescuenta.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /migracionescuentas/1
  # PATCH/PUT /migracionescuentas/1.json
  def update
    respond_to do |format|
      if @migracionescuenta.update(migracionescuenta_params)
        format.html { redirect_to @migracionescuenta, notice: 'Migracionescuenta was successfully updated.' }
        format.json { render :show, status: :ok, location: @migracionescuenta }
      else
        format.html { render :edit }
        format.json { render json: @migracionescuenta.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /migracionescuentas/1
  # DELETE /migracionescuentas/1.json
  def destroy
    @migracionescuenta.destroy
    respond_to do |format|
      format.html { redirect_to migracionescuentas_url, notice: 'Migracionescuenta was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_migracionescuenta
      @migracionescuenta = Migracionescuenta.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def migracionescuenta_params
      params.require(:migracionescuenta).permit(:user_id, :archivo_id, :estado, :identificacion, :nro_cuenta)
    end
end
