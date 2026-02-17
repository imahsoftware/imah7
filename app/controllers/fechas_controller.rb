class FechasController < ApplicationController
  before_action :set_fecha, only: [:show, :edit, :update, :destroy]

  # GET /fechas
  # GET /fechas.json
  def index
    @fechas = Fecha.all
  end

  # GET /fechas/1
  # GET /fechas/1.json
  def show
  end

  # GET /fechas/new
  def new
    @fecha = Fecha.new
  end

  # GET /fechas/1/edit
  def edit
  end

  # POST /fechas
  # POST /fechas.json
  def create
    @fecha = Fecha.new(fecha_params)

    respond_to do |format|
      if @fecha.save
        format.html { redirect_to @fecha, notice: 'Fecha was successfully created.' }
        format.json { render :show, status: :created, location: @fecha }
      else
        format.html { render :new }
        format.json { render json: @fecha.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fechas/1
  # PATCH/PUT /fechas/1.json
  def update
    respond_to do |format|
      if @fecha.update(fecha_params)
        format.html { redirect_to @fecha, notice: 'Fecha was successfully updated.' }
        format.json { render :show, status: :ok, location: @fecha }
      else
        format.html { render :edit }
        format.json { render json: @fecha.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fechas/1
  # DELETE /fechas/1.json
  def destroy
    @fecha.destroy
    respond_to do |format|
      format.html { redirect_to fechas_url, notice: 'Fecha was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fecha
      @fecha = Fecha.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fecha_params
      params.require(:fecha).permit(:fecha)
    end
end
