class EgresosdetallesController < ApplicationController
  before_action :set_egresosdetalle, only: [:show, :edit, :update, :destroy]

  # GET /egresosdetalles
  # GET /egresosdetalles.json
  def index
    @egresosdetalles = Egresosdetalle.all
  end

  # GET /egresosdetalles/1
  # GET /egresosdetalles/1.json
  def show
  end

  # GET /egresosdetalles/new
  def new
    @egresosdetalle = Egresosdetalle.new
  end

  # GET /egresosdetalles/1/edit
  def edit
  end

  # POST /egresosdetalles
  # POST /egresosdetalles.json
  def create
    @egresosdetalle = Egresosdetalle.new(egresosdetalle_params)

    respond_to do |format|
      if @egresosdetalle.save
        format.html { redirect_to @egresosdetalle, notice: 'Egresosdetalle was successfully created.' }
        format.json { render :show, status: :created, location: @egresosdetalle }
      else
        format.html { render :new }
        format.json { render json: @egresosdetalle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /egresosdetalles/1
  # PATCH/PUT /egresosdetalles/1.json
  def update
    respond_to do |format|
      if @egresosdetalle.update(egresosdetalle_params)
        format.html { redirect_to @egresosdetalle, notice: 'Egresosdetalle was successfully updated.' }
        format.json { render :show, status: :ok, location: @egresosdetalle }
      else
        format.html { render :edit }
        format.json { render json: @egresosdetalle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /egresosdetalles/1
  # DELETE /egresosdetalles/1.json
  def destroy
    @egresosdetalle.destroy
    respond_to do |format|
      format.html { redirect_to egresosdetalles_url, notice: 'Egresosdetalle was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_egresosdetalle
      @egresosdetalle = Egresosdetalle.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def egresosdetalle_params
      params.require(:egresosdetalle).permit(:egreso_id, :concepto, :cantidad, :valor_unitario, :iva, :valor_iva, :subtotal, :total, :user_id, :retencion, :retecre, :claseretencion, :centroscosto_id, :eproveedorescompra_id)
    end
end
