class BitacoraprocesosController < ApplicationController
  before_action :set_bitacoraproceso, only: [:show, :edit, :update, :destroy]

  # GET /bitacoraprocesos
  # GET /bitacoraprocesos.json
  def index
    @bitacoraprocesos = Bitacoraproceso.all
  end

  # GET /bitacoraprocesos/1
  # GET /bitacoraprocesos/1.json
  def show
  end

  # GET /bitacoraprocesos/new
  def new
    @bitacoraproceso = Bitacoraproceso.new
  end

  # GET /bitacoraprocesos/1/edit
  def edit
  end

  # POST /bitacoraprocesos
  # POST /bitacoraprocesos.json
  def create
    @bitacoraproceso = Bitacoraproceso.new(bitacoraproceso_params)

    respond_to do |format|
      if @bitacoraproceso.save
        format.html { redirect_to @bitacoraproceso, notice: 'Bitacoraproceso was successfully created.' }
        format.json { render :show, status: :created, location: @bitacoraproceso }
      else
        format.html { render :new }
        format.json { render json: @bitacoraproceso.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bitacoraprocesos/1
  # PATCH/PUT /bitacoraprocesos/1.json
  def update
    respond_to do |format|
      if @bitacoraproceso.update(bitacoraproceso_params)
        format.html { redirect_to @bitacoraproceso, notice: 'Bitacoraproceso was successfully updated.' }
        format.json { render :show, status: :ok, location: @bitacoraproceso }
      else
        format.html { render :edit }
        format.json { render json: @bitacoraproceso.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bitacoraprocesos/1
  # DELETE /bitacoraprocesos/1.json
  def destroy
    @bitacoraproceso.destroy
    respond_to do |format|
      format.html { redirect_to bitacoraprocesos_url, notice: 'Bitacoraproceso was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bitacoraproceso
      @bitacoraproceso = Bitacoraproceso.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bitacoraproceso_params
      params.require(:bitacoraproceso).permit(:codigo, :user_id, :proceso, :codigo_recibido, :fecha_firma, :codigo_firma, :id_tabla, :controlador_tabla)
    end
end
