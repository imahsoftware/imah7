class ContratosnodosController < ApplicationController
  before_action :set_contratosnodo, only: [:show, :edit, :update, :destroy]

  # GET /contratosnodos
  # GET /contratosnodos.json
  def index
    @contratosnodos = Contratosnodo.all
  end

  # GET /contratosnodos/1
  # GET /contratosnodos/1.json
  def show
  end

  # GET /contratosnodos/new
  def new
    @contratosnodo = Contratosnodo.new
  end

  # GET /contratosnodos/1/edit
  def edit
  end

  # POST /contratosnodos
  # POST /contratosnodos.json
  def create
    @contratosnodo = Contratosnodo.new(contratosnodo_params)

    respond_to do |format|
      if @contratosnodo.save
        format.html { redirect_to @contratosnodo, notice: 'Contratosnodo was successfully created.' }
        format.json { render :show, status: :created, location: @contratosnodo }
      else
        format.html { render :new }
        format.json { render json: @contratosnodo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contratosnodos/1
  # PATCH/PUT /contratosnodos/1.json
  def update
    respond_to do |format|
      if @contratosnodo.update(contratosnodo_params)
        format.html { redirect_to @contratosnodo, notice: 'Contratosnodo was successfully updated.' }
        format.json { render :show, status: :ok, location: @contratosnodo }
      else
        format.html { render :edit }
        format.json { render json: @contratosnodo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contratosnodos/1
  # DELETE /contratosnodos/1.json
  def destroy
    @contratosnodo.destroy
    respond_to do |format|
      format.html { redirect_to contratosnodos_url, notice: 'Contratosnodo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contratosnodo
      @contratosnodo = Contratosnodo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def contratosnodo_params
      params.require(:contratosnodo).permit(:contrato_id, :user_id, :contratossede_id, :user_act, :estado, :nombre, :clase_aseo, :clase_aseo2, :clase_aseo3, :clase_aseo4, :clase_aseo5)
    end
end
