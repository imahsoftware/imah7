class ParcagosdocsController < ApplicationController
  before_action :set_parcagosdoc, only: [:show, :edit, :update, :destroy]

  # GET /parcagosdocs
  # GET /parcagosdocs.json
  def index
    @parcagosdocs = Parcagosdoc.all
  end

  # GET /parcagosdocs/1
  # GET /parcagosdocs/1.json
  def show
  end

  # GET /parcagosdocs/new
  def new
    @parcagosdoc = Parcagosdoc.new
  end

  # GET /parcagosdocs/1/edit
  def edit
  end

  # POST /parcagosdocs
  # POST /parcagosdocs.json
  def create
    @parcagosdoc = Parcagosdoc.new(parcagosdoc_params)

    respond_to do |format|
      if @parcagosdoc.save
        format.html { redirect_to @parcagosdoc, notice: 'Parcagosdoc was successfully created.' }
        format.json { render :show, status: :created, location: @parcagosdoc }
      else
        format.html { render :new }
        format.json { render json: @parcagosdoc.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /parcagosdocs/1
  # PATCH/PUT /parcagosdocs/1.json
  def update
    respond_to do |format|
      if @parcagosdoc.update(parcagosdoc_params)
        format.html { redirect_to @parcagosdoc, notice: 'Parcagosdoc was successfully updated.' }
        format.json { render :show, status: :ok, location: @parcagosdoc }
      else
        format.html { render :edit }
        format.json { render json: @parcagosdoc.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parcagosdocs/1
  # DELETE /parcagosdocs/1.json
  def destroy
    @parcagosdoc.destroy
    respond_to do |format|
      format.html { redirect_to parcagosdocs_url, notice: 'Parcagosdoc was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_parcagosdoc
      @parcagosdoc = Parcagosdoc.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def parcagosdoc_params
      params.require(:parcagosdoc).permit(:parcargo_id, :user_id, :obligatorio, :observacion, :estado)
    end
end
