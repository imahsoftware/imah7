class PersonasformulariosmensajesController < ApplicationController
  before_action :set_personasformulariosmensaje, only: [:show, :edit, :update, :destroy]

  # GET /personasformulariosmensajes
  # GET /personasformulariosmensajes.json
  def index
    @personasformulariosmensajes = Personasformulariosmensaje.all
  end

  # GET /personasformulariosmensajes/1
  # GET /personasformulariosmensajes/1.json
  def show
  end

  # GET /personasformulariosmensajes/new
  def new
    @personasformulariosmensaje = Personasformulariosmensaje.new
  end

  # GET /personasformulariosmensajes/1/edit
  def edit
  end

  # POST /personasformulariosmensajes
  # POST /personasformulariosmensajes.json
  def create
    @personasformulariosmensaje = Personasformulariosmensaje.new(personasformulariosmensaje_params)

    respond_to do |format|
      if @personasformulariosmensaje.save
        format.html { redirect_to @personasformulariosmensaje, notice: 'Personasformulariosmensaje was successfully created.' }
        format.json { render :show, status: :created, location: @personasformulariosmensaje }
      else
        format.html { render :new }
        format.json { render json: @personasformulariosmensaje.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /personasformulariosmensajes/1
  # PATCH/PUT /personasformulariosmensajes/1.json
  def update
    respond_to do |format|
      if @personasformulariosmensaje.update(personasformulariosmensaje_params)
        format.html { redirect_to @personasformulariosmensaje, notice: 'Personasformulariosmensaje was successfully updated.' }
        format.json { render :show, status: :ok, location: @personasformulariosmensaje }
      else
        format.html { render :edit }
        format.json { render json: @personasformulariosmensaje.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /personasformulariosmensajes/1
  # DELETE /personasformulariosmensajes/1.json
  def destroy
    @personasformulariosmensaje.destroy
    respond_to do |format|
      format.html { redirect_to personasformulariosmensajes_url, notice: 'Personasformulariosmensaje was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_personasformulariosmensaje
      @personasformulariosmensaje = Personasformulariosmensaje.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def personasformulariosmensaje_params
      params.require(:personasformulariosmensaje).permit(:personasformulario_id, :tipo, :estado, :user_envia)
    end
end
