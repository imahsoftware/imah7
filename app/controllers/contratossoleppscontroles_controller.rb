class ContratossoleppscontrolesController < ApplicationController
  before_action :set_contratossoleppscontrol, only: [:show, :edit, :update, :destroy]

  # GET /contratossoleppscontroles
  # GET /contratossoleppscontroles.json
  def index
    @contratossoleppscontroles = Contratossoleppscontrol.all
  end

  # GET /contratossoleppscontroles/1
  # GET /contratossoleppscontroles/1.json
  def show
  end

  # GET /contratossoleppscontroles/new
  def new
    @contratossoleppscontrol = Contratossoleppscontrol.new
  end

  # GET /contratossoleppscontroles/1/edit
  def edit
  end

  # POST /contratossoleppscontroles
  # POST /contratossoleppscontroles.json
  def create
    @contratossoleppscontrol = Contratossoleppscontrol.new(contratossoleppscontrol_params)

    respond_to do |format|
      if @contratossoleppscontrol.save
        format.html { redirect_to @contratossoleppscontrol, notice: 'Contratossoleppscontrol was successfully created.' }
        format.json { render :show, status: :created, location: @contratossoleppscontrol }
      else
        format.html { render :new }
        format.json { render json: @contratossoleppscontrol.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contratossoleppscontroles/1
  # PATCH/PUT /contratossoleppscontroles/1.json
  def update
    respond_to do |format|
      if @contratossoleppscontrol.update(contratossoleppscontrol_params)
        format.html { redirect_to @contratossoleppscontrol, notice: 'Contratossoleppscontrol was successfully updated.' }
        format.json { render :show, status: :ok, location: @contratossoleppscontrol }
      else
        format.html { render :edit }
        format.json { render json: @contratossoleppscontrol.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contratossoleppscontroles/1
  # DELETE /contratossoleppscontroles/1.json
  def destroy
    @contratossoleppscontrol.destroy
    respond_to do |format|
      format.html { redirect_to contratossoleppscontroles_url, notice: 'Contratossoleppscontrol was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contratossoleppscontrol
      @contratossoleppscontrol = Contratossoleppscontrol.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def contratossoleppscontrol_params
      params.require(:contratossoleppscontrol).permit(:item, :cantidad_aprobada, :cantidad_restante)
    end
end
