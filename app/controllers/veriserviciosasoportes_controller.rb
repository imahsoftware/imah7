class VeriserviciosasoportesController < ApplicationController
  before_action :set_veriserviciosasoporte, only: [:show, :edit, :update, :destroy]

  # GET /veriserviciosasoportes
  # GET /veriserviciosasoportes.json
  def index
    @veriserviciosasoportes = Veriserviciosasoporte.all
  end

  # GET /veriserviciosasoportes/1
  # GET /veriserviciosasoportes/1.json
  def show
  end

  # GET /veriserviciosasoportes/new
  def new
    @veriserviciosasoporte = Veriserviciosasoporte.new
  end

  # GET /veriserviciosasoportes/1/edit
  def edit
  end

  # POST /veriserviciosasoportes
  # POST /veriserviciosasoportes.json
  def create
    @veriserviciosasoporte = Veriserviciosasoporte.new(veriserviciosasoporte_params)

    respond_to do |format|
      if @veriserviciosasoporte.save
        format.html { redirect_to @veriserviciosasoporte, notice: 'Veriserviciosasoporte was successfully created.' }
        format.json { render :show, status: :created, location: @veriserviciosasoporte }
      else
        format.html { render :new }
        format.json { render json: @veriserviciosasoporte.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /veriserviciosasoportes/1
  # PATCH/PUT /veriserviciosasoportes/1.json
  def update
    respond_to do |format|
      if @veriserviciosasoporte.update(veriserviciosasoporte_params)
        format.html { redirect_to @veriserviciosasoporte, notice: 'Veriserviciosasoporte was successfully updated.' }
        format.json { render :show, status: :ok, location: @veriserviciosasoporte }
      else
        format.html { render :edit }
        format.json { render json: @veriserviciosasoporte.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /veriserviciosasoportes/1
  # DELETE /veriserviciosasoportes/1.json
  def destroy
    @veriserviciosasoporte.destroy
    respond_to do |format|
      format.html { redirect_to veriserviciosasoportes_url, notice: 'Veriserviciosasoporte was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_veriserviciosasoporte
      @veriserviciosasoporte = Veriserviciosasoporte.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def veriserviciosasoporte_params
      params.require(:veriserviciosasoporte).permit(:veriserviciosagenda_id, :user_id, :descripcion, :verisoporte)
    end
end
