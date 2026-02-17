class ContratossolimagenesController < ApplicationController
  before_action :set_contratossolimagen, only: [:show, :edit, :update, :destroy]

  # GET /contratossolimagenes
  # GET /contratossolimagenes.json
  def index
    @contratossolimagenes = Contratossolimagen.all
  end

  # GET /contratossolimagenes/1
  # GET /contratossolimagenes/1.json
  def show
  end

  # GET /contratossolimagenes/new
  def new
    @contratossolimagen = Contratossolimagen.new
  end

  # GET /contratossolimagenes/1/edit
  def edit
  end

  # POST /contratossolimagenes
  # POST /contratossolimagenes.json
  def create
    @contratossolimagen = Contratossolimagen.new(contratossolimagen_params)

    respond_to do |format|
      if @contratossolimagen.save
        format.html { redirect_to @contratossolimagen, notice: 'Contratossolimagen was successfully created.' }
        format.json { render :show, status: :created, location: @contratossolimagen }
      else
        format.html { render :new }
        format.json { render json: @contratossolimagen.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contratossolimagenes/1
  # PATCH/PUT /contratossolimagenes/1.json
  def update
    respond_to do |format|
      if @contratossolimagen.update(contratossolimagen_params)
        format.html { redirect_to @contratossolimagen, notice: 'Contratossolimagen was successfully updated.' }
        format.json { render :show, status: :ok, location: @contratossolimagen }
      else
        format.html { render :edit }
        format.json { render json: @contratossolimagen.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contratossolimagenes/1
  # DELETE /contratossolimagenes/1.json
  def destroy
    @contratossolimagen.destroy
    respond_to do |format|
      format.html { redirect_to contratossolimagenes_url, notice: 'Contratossolimagen was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contratossolimagen
      @contratossolimagen = Contratossolimagen.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def contratossolimagen_params
      params.require(:contratossolimagen).permit(:contratossolicitud_id, :user_id, :descripcion, :solimagenes)
    end
end
