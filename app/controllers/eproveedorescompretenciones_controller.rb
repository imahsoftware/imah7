class EproveedorescompretencionesController < ApplicationController
  before_action :set_eproveedorescompretencion, only: [:show, :edit, :update, :destroy]

  # GET /eproveedorescompretenciones
  # GET /eproveedorescompretenciones.json
  def index
    @eproveedorescompretenciones = Eproveedorescompretencion.all
  end

  # GET /eproveedorescompretenciones/1
  # GET /eproveedorescompretenciones/1.json
  def show
  end

  # GET /eproveedorescompretenciones/new
  def new
    @eproveedorescompretencion = Eproveedorescompretencion.new
  end

  # GET /eproveedorescompretenciones/1/edit
  def edit
  end

  # POST /eproveedorescompretenciones
  # POST /eproveedorescompretenciones.json
  def create
    @eproveedorescompretencion = Eproveedorescompretencion.new(eproveedorescompretencion_params)

    respond_to do |format|
      if @eproveedorescompretencion.save
        format.html { redirect_to @eproveedorescompretencion, notice: 'Eproveedorescompretencion was successfully created.' }
        format.json { render :show, status: :created, location: @eproveedorescompretencion }
      else
        format.html { render :new }
        format.json { render json: @eproveedorescompretencion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /eproveedorescompretenciones/1
  # PATCH/PUT /eproveedorescompretenciones/1.json
  def update
    respond_to do |format|
      if @eproveedorescompretencion.update(eproveedorescompretencion_params)
        format.html { redirect_to @eproveedorescompretencion, notice: 'Eproveedorescompretencion was successfully updated.' }
        format.json { render :show, status: :ok, location: @eproveedorescompretencion }
      else
        format.html { render :edit }
        format.json { render json: @eproveedorescompretencion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /eproveedorescompretenciones/1
  # DELETE /eproveedorescompretenciones/1.json
  def destroy
    @eproveedorescompretencion.destroy
    respond_to do |format|
      format.html { redirect_to eproveedorescompretenciones_url, notice: 'Eproveedorescompretencion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_eproveedorescompretencion
      @eproveedorescompretencion = Eproveedorescompretencion.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def eproveedorescompretencion_params
      params.require(:eproveedorescompretencion).permit(:eproveedorescompra_id, :tipospretencion_id, :valor)
    end
end
