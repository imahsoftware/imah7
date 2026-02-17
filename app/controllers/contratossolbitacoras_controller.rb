class ContratossolbitacorasController < ApplicationController
  before_action :set_contratossolbitacora, only: [:show, :edit, :update, :destroy]

  # GET /contratossolbitacoras
  # GET /contratossolbitacoras.json
  def index
    @contratossolbitacoras = Contratossolbitacora.all
  end

  # GET /contratossolbitacoras/1
  # GET /contratossolbitacoras/1.json
  def show
  end

  # GET /contratossolbitacoras/new
  def new
    @contratossolbitacora = Contratossolbitacora.new
  end

  # GET /contratossolbitacoras/1/edit
  def edit
  end

  # POST /contratossolbitacoras
  # POST /contratossolbitacoras.json
  def create
    @contratossolbitacora = Contratossolbitacora.new(contratossolbitacora_params)

    respond_to do |format|
      if @contratossolbitacora.save
        format.html { redirect_to @contratossolbitacora, notice: 'Contratossolbitacora was successfully created.' }
        format.json { render :show, status: :created, location: @contratossolbitacora }
      else
        format.html { render :new }
        format.json { render json: @contratossolbitacora.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contratossolbitacoras/1
  # PATCH/PUT /contratossolbitacoras/1.json
  def update
    respond_to do |format|
      if @contratossolbitacora.update(contratossolbitacora_params)
        format.html { redirect_to @contratossolbitacora, notice: 'Contratossolbitacora was successfully updated.' }
        format.json { render :show, status: :ok, location: @contratossolbitacora }
      else
        format.html { render :edit }
        format.json { render json: @contratossolbitacora.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contratossolbitacoras/1
  # DELETE /contratossolbitacoras/1.json
  def destroy
    @contratossolbitacora.destroy
    respond_to do |format|
      format.html { redirect_to contratossolbitacoras_url, notice: 'Contratossolbitacora was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contratossolbitacora
      @contratossolbitacora = Contratossolbitacora.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contratossolbitacora_params
      params.require(:contratossolbitacora).permit(:contratossolicitud_id, :user_id, :estado)
    end
end
