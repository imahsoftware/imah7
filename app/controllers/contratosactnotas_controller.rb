class ContratosactnotasController < ApplicationController
  before_action :set_contratosactnota, only: [:show, :edit, :update, :destroy]

  # GET /contratosactnotas
  # GET /contratosactnotas.json
  def index
    @contratosactnotas = Contratosactnota.all
  end

  # GET /contratosactnotas/1
  # GET /contratosactnotas/1.json
  def show
  end

  # GET /contratosactnotas/new
  def new
    @contratosactnota = Contratosactnota.new
  end

  # GET /contratosactnotas/1/edit
  def edit
  end

  # POST /contratosactnotas
  # POST /contratosactnotas.json
  def create
    @contratosactnota = Contratosactnota.new(contratosactnota_params)

    respond_to do |format|
      if @contratosactnota.save
        format.html { redirect_to @contratosactnota, notice: 'Contratosactnota was successfully created.' }
        format.json { render :show, status: :created, location: @contratosactnota }
      else
        format.html { render :new }
        format.json { render json: @contratosactnota.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contratosactnotas/1
  # PATCH/PUT /contratosactnotas/1.json
  def update
    respond_to do |format|
      if @contratosactnota.update(contratosactnota_params)
        format.html { redirect_to @contratosactnota, notice: 'Contratosactnota was successfully updated.' }
        format.json { render :show, status: :ok, location: @contratosactnota }
      else
        format.html { render :edit }
        format.json { render json: @contratosactnota.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contratosactnotas/1
  # DELETE /contratosactnotas/1.json
  def destroy
    @contratosactnota.destroy
    respond_to do |format|
      format.html { redirect_to contratosactnotas_url, notice: 'Contratosactnota was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contratosactnota
      @contratosactnota = Contratosactnota.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def contratosactnota_params
      params.require(:contratosactnota).permit(:contratosactividad_id, :contratossede_id, :user_id, :nota)
    end
end
