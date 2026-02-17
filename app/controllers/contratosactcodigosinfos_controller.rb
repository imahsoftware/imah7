class ContratosactcodigosinfosController < ApplicationController
  before_action :set_contratosactcodigosinfo, only: [:show, :edit, :update, :destroy]

  # GET /contratosactcodigosinfos
  # GET /contratosactcodigosinfos.json
  def index
    @contratosactcodigosinfos = Contratosactcodigosinfo.all
  end

  # GET /contratosactcodigosinfos/1
  # GET /contratosactcodigosinfos/1.json
  def show
  end

  # GET /contratosactcodigosinfos/new
  def new
    @contratosactcodigosinfo = Contratosactcodigosinfo.new
  end

  # GET /contratosactcodigosinfos/1/edit
  def edit
  end

  # POST /contratosactcodigosinfos
  # POST /contratosactcodigosinfos.json
  def create
    @contratosactcodigosinfo = Contratosactcodigosinfo.new(contratosactcodigosinfo_params)

    respond_to do |format|
      if @contratosactcodigosinfo.save
        format.html { redirect_to @contratosactcodigosinfo, notice: 'Contratosactcodigosinfo was successfully created.' }
        format.json { render :show, status: :created, location: @contratosactcodigosinfo }
      else
        format.html { render :new }
        format.json { render json: @contratosactcodigosinfo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contratosactcodigosinfos/1
  # PATCH/PUT /contratosactcodigosinfos/1.json
  def update
    respond_to do |format|
      if @contratosactcodigosinfo.update(contratosactcodigosinfo_params)
        format.html { redirect_to @contratosactcodigosinfo, notice: 'Contratosactcodigosinfo was successfully updated.' }
        format.json { render :show, status: :ok, location: @contratosactcodigosinfo }
      else
        format.html { render :edit }
        format.json { render json: @contratosactcodigosinfo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contratosactcodigosinfos/1
  # DELETE /contratosactcodigosinfos/1.json
  def destroy
    @contratosactcodigosinfo.destroy
    respond_to do |format|
      format.html { redirect_to contratosactcodigosinfos_url, notice: 'Contratosactcodigosinfo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contratosactcodigosinfo
      @contratosactcodigosinfo = Contratosactcodigosinfo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def contratosactcodigosinfo_params
      params.require(:contratosactcodigosinfo).permit(:contratossede_id, :nodo, :user_id, :fecha, :rsteva_1, :rsteva_2, :rsteva_3, :rsteva_4, :rsteva_5, :rsteva_6, :rsteva_7, :rsteva_8, :rsteva_9, :rsteva_10, :rsteva_11, :rsteva_12, :rsteva_13, :rsteva_14, :rsteva_15, :rsteva_16, :rsteva_17, :rsteva_18, :rsteva_19, :rsteva_20, :rsteva_21, :rsteva_22, :rsteva_23, :rsteva_24, :rsteva_44, :rsteva_45, :rsteva_46, :rsteva_47, :rsteva_48, :rsteva_49, :rsteva_50, :rsteva_51)
    end
end
