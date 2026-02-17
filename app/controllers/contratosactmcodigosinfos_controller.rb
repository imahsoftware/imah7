class ContratosactmcodigosinfosController < ApplicationController
  before_action :set_contratosactmcodigosinfo, only: [:show, :edit, :update, :destroy]

  # GET /contratosactmcodigosinfos
  # GET /contratosactmcodigosinfos.json
  def index
    @contratosactmcodigosinfos = Contratosactmcodigosinfo.all
  end

  # GET /contratosactmcodigosinfos/1
  # GET /contratosactmcodigosinfos/1.json
  def show
  end

  # GET /contratosactmcodigosinfos/new
  def new
    @contratosactmcodigosinfo = Contratosactmcodigosinfo.new
  end

  # GET /contratosactmcodigosinfos/1/edit
  def edit
  end

  # POST /contratosactmcodigosinfos
  # POST /contratosactmcodigosinfos.json
  def create
    @contratosactmcodigosinfo = Contratosactmcodigosinfo.new(contratosactmcodigosinfo_params)

    respond_to do |format|
      if @contratosactmcodigosinfo.save
        format.html { redirect_to @contratosactmcodigosinfo, notice: 'Contratosactmcodigosinfo was successfully created.' }
        format.json { render :show, status: :created, location: @contratosactmcodigosinfo }
      else
        format.html { render :new }
        format.json { render json: @contratosactmcodigosinfo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contratosactmcodigosinfos/1
  # PATCH/PUT /contratosactmcodigosinfos/1.json
  def update
    respond_to do |format|
      if @contratosactmcodigosinfo.update(contratosactmcodigosinfo_params)
        format.html { redirect_to @contratosactmcodigosinfo, notice: 'Contratosactmcodigosinfo was successfully updated.' }
        format.json { render :show, status: :ok, location: @contratosactmcodigosinfo }
      else
        format.html { render :edit }
        format.json { render json: @contratosactmcodigosinfo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contratosactmcodigosinfos/1
  # DELETE /contratosactmcodigosinfos/1.json
  def destroy
    @contratosactmcodigosinfo.destroy
    respond_to do |format|
      format.html { redirect_to contratosactmcodigosinfos_url, notice: 'Contratosactmcodigosinfo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contratosactmcodigosinfo
      @contratosactmcodigosinfo = Contratosactmcodigosinfo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def contratosactmcodigosinfo_params
      params.require(:contratosactmcodigosinfo).permit(:contratossede_id, :nodo, :user_id, :fecha, :rsteva_2, :rsteva_3, :rsteva_4, :rsteva_5, :rsteva_6, :rsteva_7, :rsteva_8, :rsteva_9, :rsteva_10, :rsteva_11, :rsteva_12, :rsteva_13, :rsteva_14, :rsteva_15, :rsteva_16, :rsteva_17, :rsteva_18, :rsteva_19, :rsteva_20, :rsteva_21, :rsteva_22, :rsteva_23, :rsteva_24, :rsteva_25, :rsteva_26, :rsteva_27, :rsteva_28, :rsteva_29, :rsteva_30, :rsteva_31, :rsteva_32, :rsteva_33, :rsteva_34, :rsteva_35, :rsteva_36, :rsteva_37, :rsteva_38, :rsteva_39, :rsteva_40, :rsteva_41, :rsteva_42, :rsteva_43, :rsteva_44, :rsteva_45, :rsteva_46, :rsteva_47, :rsteva_48, :rsteva_49, :rsteva_50, :rsteva_51, :rsteva_52)
    end
end
