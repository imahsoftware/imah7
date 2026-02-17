class MigracionescamposController < ApplicationController
  before_action :set_migracionescampo, only: [:show, :edit, :update, :destroy]

  # GET /migracionescampos
  # GET /migracionescampos.json
  def index
    @migracionescampos = Migracionescampo.all
  end

  # GET /migracionescampos/1
  # GET /migracionescampos/1.json
  def show
  end

  # GET /migracionescampos/new
  def new
    @migracionescampo = Migracionescampo.new
  end

  # GET /migracionescampos/1/edit
  def edit
  end

  # POST /migracionescampos
  # POST /migracionescampos.json
  def create
    @migracionescampo = Migracionescampo.new(migracionescampo_params)

    respond_to do |format|
      if @migracionescampo.save
        format.html { redirect_to @migracionescampo, notice: 'Migracionescampo was successfully created.' }
        format.json { render :show, status: :created, location: @migracionescampo }
      else
        format.html { render :new }
        format.json { render json: @migracionescampo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /migracionescampos/1
  # PATCH/PUT /migracionescampos/1.json
  def update
    respond_to do |format|
      if @migracionescampo.update(migracionescampo_params)
        format.html { redirect_to @migracionescampo, notice: 'Migracionescampo was successfully updated.' }
        format.json { render :show, status: :ok, location: @migracionescampo }
      else
        format.html { render :edit }
        format.json { render json: @migracionescampo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /migracionescampos/1
  # DELETE /migracionescampos/1.json
  def destroy
    @migracionescampo.destroy
    respond_to do |format|
      format.html { redirect_to migracionescampos_url, notice: 'Migracionescampo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_migracionescampo
      @migracionescampo = Migracionescampo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def migracionescampo_params
      params.require(:migracionescampo).permit(:migracion_id, :orden, :encabezado, :campo, :tipo)
    end
end
