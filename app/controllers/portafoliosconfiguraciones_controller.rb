class PortafoliosconfiguracionesController < ApplicationController
  before_action :set_portafoliosconfiguracion, only: [:show, :edit, :update, :destroy]

  # GET /portafoliosconfiguraciones
  # GET /portafoliosconfiguraciones.json
  def index
    @portafoliosconfiguraciones = Portafoliosconfiguracion.all
  end

  # GET /portafoliosconfiguraciones/1
  # GET /portafoliosconfiguraciones/1.json
  def show
  end

  # GET /portafoliosconfiguraciones/new
  def new
    @portafoliosconfiguracion = Portafoliosconfiguracion.new
  end

  # GET /portafoliosconfiguraciones/1/edit
  def edit
  end

  # POST /portafoliosconfiguraciones
  # POST /portafoliosconfiguraciones.json
  def create
    @portafoliosconfiguracion = Portafoliosconfiguracion.new(portafoliosconfiguracion_params)

    respond_to do |format|
      if @portafoliosconfiguracion.save
        format.html { redirect_to @portafoliosconfiguracion, notice: 'Portafoliosconfiguracion was successfully created.' }
        format.json { render :show, status: :created, location: @portafoliosconfiguracion }
      else
        format.html { render :new }
        format.json { render json: @portafoliosconfiguracion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /portafoliosconfiguraciones/1
  # PATCH/PUT /portafoliosconfiguraciones/1.json
  def update
    respond_to do |format|
      if @portafoliosconfiguracion.update(portafoliosconfiguracion_params)
        format.html { redirect_to @portafoliosconfiguracion, notice: 'Portafoliosconfiguracion was successfully updated.' }
        format.json { render :show, status: :ok, location: @portafoliosconfiguracion }
      else
        format.html { render :edit }
        format.json { render json: @portafoliosconfiguracion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /portafoliosconfiguraciones/1
  # DELETE /portafoliosconfiguraciones/1.json
  def destroy
    @portafoliosconfiguracion.destroy
    respond_to do |format|
      format.html { redirect_to portafoliosconfiguraciones_url, notice: 'Portafoliosconfiguracion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_portafoliosconfiguracion
      @portafoliosconfiguracion = Portafoliosconfiguracion.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def portafoliosconfiguracion_params
      params.require(:portafoliosconfiguracion).permit(:portafolio_id, :descripcion, :valor)
    end
end
