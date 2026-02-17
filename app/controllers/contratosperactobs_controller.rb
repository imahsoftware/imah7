class ContratosperactobsController < ApplicationController
  before_action :set_contratosperactob, only: [:show, :edit, :update, :destroy]

  # GET /contratosperactobs
  # GET /contratosperactobs.json
  def index
    @contratosperactobs = Contratosperactob.all
  end

  def marcar
    @resultado = params[:resultado]
    @contratosperactob = Contratosperactob.find(params[:id])
    @contratosperactob.update(resultado: @resultado)
  end

  def update_individual
    id = 0
    JSON.parse(params[:contratosperactobs].to_json).each do |object|
      id = Contratosperactob.find(object[0]).contratospersona_id.to_s
      break if id != ""
    end
    flash[:notice] = "Actualizada con Exito."
    @contratosperactob = Contratosperactob.update(params[:contratosperactobs].keys, params[:contratosperactobs].values)
  end

  # GET /contratosperactobs/1
  # GET /contratosperactobs/1.json
  def show
  end

  # GET /contratosperactobs/new
  def new
    @contratosperactob = Contratosperactob.new
  end

  # GET /contratosperactobs/1/edit
  def edit
  end

  # POST /contratosperactobs
  # POST /contratosperactobs.json
  def create
    @contratosperactob = Contratosperactob.new(contratosperactob_params)

    respond_to do |format|
      if @contratosperactob.save
        format.html { redirect_to @contratosperactob, notice: 'Contratosperactob was successfully created.' }
        format.json { render :show, status: :created, location: @contratosperactob }
      else
        format.html { render :new }
        format.json { render json: @contratosperactob.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contratosperactobs/1
  # PATCH/PUT /contratosperactobs/1.json
  def update
    @contratosperactob.observacion = params[:contratosperactob][:observacion] rescue nil
    respond_to do |format|
      if @contratosperactob.update(contratosperactob_params)
        format.html { redirect_to @contratosperactob, notice: 'Contratosperactob was successfully updated.' }
        format.json { render :show, status: :ok, location: @contratosperactob }
      else
        format.html { render :edit }
        format.json { render json: @contratosperactob.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contratosperactobs/1
  # DELETE /contratosperactobs/1.json
  def destroy
    @contratosperactob.destroy
    respond_to do |format|
      format.html { redirect_to contratosperactobs_url, notice: 'Contratosperactob was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contratosperactob
      @contratosperactob = Contratosperactob.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def contratosperactob_params
      params.require(:contratosperactob).permit(:contratospersona_id, :contratosperfecha_id, :contratoscargo_id, :resultado, :user_interventor, :anno, :mes)
    end
end
