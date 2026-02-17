class TiposnaportesController < ApplicationController
  before_action :set_tiposnaporte, only: [:show, :edit, :update, :destroy]

  # GET /tiposnaportes
  # GET /tiposnaportes.json
  def index
    @tiposnaportes = Tiposnaporte.all
  end

  # GET /tiposnaportes/1
  # GET /tiposnaportes/1.json
  def show
  end

  # GET /tiposnaportes/new
  def new
    @tiposnaporte = Tiposnaporte.new
  end

  # GET /tiposnaportes/1/edit
  def edit
  end

  # POST /tiposnaportes
  # POST /tiposnaportes.json
  def create
    @tiposnaporte = Tiposnaporte.new(tiposnaporte_params)

    respond_to do |format|
      if @tiposnaporte.save
        format.html { redirect_to @tiposnaporte, notice: 'Tiposnaporte was successfully created.' }
        format.json { render :show, status: :created, location: @tiposnaporte }
      else
        format.html { render :new }
        format.json { render json: @tiposnaporte.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tiposnaportes/1
  # PATCH/PUT /tiposnaportes/1.json
  def update
    respond_to do |format|
      if @tiposnaporte.update(tiposnaporte_params)
        format.html { redirect_to @tiposnaporte, notice: 'Tiposnaporte was successfully updated.' }
        format.json { render :show, status: :ok, location: @tiposnaporte }
      else
        format.html { render :edit }
        format.json { render json: @tiposnaporte.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tiposnaportes/1
  # DELETE /tiposnaportes/1.json
  def destroy
    @tiposnaporte.destroy
    respond_to do |format|
      format.html { redirect_to tiposnaportes_url, notice: 'Tiposnaporte was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tiposnaporte
      @tiposnaporte = Tiposnaporte.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tiposnaporte_params
      params.require(:tiposnaporte).permit(:tipo, :subtipo, :descripcion)
    end
end
