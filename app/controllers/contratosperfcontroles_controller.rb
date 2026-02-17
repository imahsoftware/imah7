class ContratosperfcontrolesController < ApplicationController
  before_action :set_contratosperfcontrol, only: [:show, :edit, :update, :destroy]

  # GET /contratosperfcontroles
  # GET /contratosperfcontroles.json
  def index
    @contratosperfcontroles = Contratosperfcontrol.all
  end

  # GET /contratosperfcontroles/1
  # GET /contratosperfcontroles/1.json
  def show
  end

  # GET /contratosperfcontroles/new
  def new
    @contratosperfcontrol = Contratosperfcontrol.new
  end

  # GET /contratosperfcontroles/1/edit
  def edit
  end

  # POST /contratosperfcontroles
  # POST /contratosperfcontroles.json
  def create
    @contratosperfcontrol = Contratosperfcontrol.new(contratosperfcontrol_params)

    respond_to do |format|
      if @contratosperfcontrol.save
        format.html { redirect_to @contratosperfcontrol, notice: 'Contratosperfcontrol was successfully created.' }
        format.json { render :show, status: :created, location: @contratosperfcontrol }
      else
        format.html { render :new }
        format.json { render json: @contratosperfcontrol.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contratosperfcontroles/1
  # PATCH/PUT /contratosperfcontroles/1.json
  def update
    respond_to do |format|
      if @contratosperfcontrol.update(contratosperfcontrol_params)
        format.html { redirect_to @contratosperfcontrol, notice: 'Contratosperfcontrol was successfully updated.' }
        format.json { render :show, status: :ok, location: @contratosperfcontrol }
      else
        format.html { render :edit }
        format.json { render json: @contratosperfcontrol.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contratosperfcontroles/1
  # DELETE /contratosperfcontroles/1.json
  def destroy
    @contratosperfcontrol.destroy
    respond_to do |format|
      format.html { redirect_to contratosperfcontroles_url, notice: 'Contratosperfcontrol was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contratosperfcontrol
      @contratosperfcontrol = Contratosperfcontrol.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def contratosperfcontrol_params
      params.require(:contratosperfcontrol).permit(:contratosperfecha_id, :fecha, :estado, :contratospervacacion_id)
    end
end
