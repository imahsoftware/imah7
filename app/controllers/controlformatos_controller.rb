class ControlformatosController < ApplicationController
  before_action :set_controlformato, only: [:show, :edit, :update, :destroy]

  # GET /controlformatos
  # GET /controlformatos.json
  def index
    @controlformatos = Controlformato.all
  end

  # GET /controlformatos/1
  # GET /controlformatos/1.json
  def show
  end

  # GET /controlformatos/new
  def new
    @controlformato = Controlformato.new
  end

  # GET /controlformatos/1/edit
  def edit
  end

  # POST /controlformatos
  # POST /controlformatos.json
  def create
    @controlformato = Controlformato.new(controlformato_params)

    respond_to do |format|
      if @controlformato.save
        format.html { redirect_to @controlformato, notice: 'Controlformato was successfully created.' }
        format.json { render :show, status: :created, location: @controlformato }
      else
        format.html { render :new }
        format.json { render json: @controlformato.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /controlformatos/1
  # PATCH/PUT /controlformatos/1.json
  def update
    respond_to do |format|
      if @controlformato.update(controlformato_params)
        format.html { redirect_to @controlformato, notice: 'Controlformato was successfully updated.' }
        format.json { render :show, status: :ok, location: @controlformato }
      else
        format.html { render :edit }
        format.json { render json: @controlformato.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /controlformatos/1
  # DELETE /controlformatos/1.json
  def destroy
    @controlformato.destroy
    respond_to do |format|
      format.html { redirect_to controlformatos_url, notice: 'Controlformato was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_controlformato
      @controlformato = Controlformato.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def controlformato_params
      params.require(:controlformato).permit(:proceso, :controlador, :modelo, :url, :tipo_documento, :estado)
    end
end
