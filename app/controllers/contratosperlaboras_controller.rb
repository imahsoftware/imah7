class ContratosperlaborasController < ApplicationController
  before_action :set_contratosperlabora, only: [:show, :edit, :update, :destroy]

  # GET /contratosperlaboras
  # GET /contratosperlaboras.json
  def index
    @contratosperlaboras = Contratosperlabora.all
  end

  def update_labora
    anno = params[:anno]
    mes = params[:mes]
    isadmin = is_admin
    @contratosperfecha = Contratosperfecha.find(params[:id])
    if !Contratosperlabora.where("anno = '#{anno}' and mes = '#{mes}' and user_asigna = #{isadmin} and contratosperfecha_id = #{@contratosperfecha.id}").present?
      contratosperlabora = Contratosperlabora.new
      contratosperlabora.anno = anno
      contratosperlabora.mes = mes
      contratosperlabora.user_asigna = isadmin
      contratosperlabora.contratospersona_id = @contratosperfecha.contratospersona_id
      contratosperlabora.contratosperfecha_id = @contratosperfecha.id
      contratosperlabora.labora =  params[:contratosperlabora][:labora]
      contratosperlabora.codigo_firma = SecureRandom.hex
      contratosperlabora.save(validate: false)
    else
      contratosperlabora = Contratosperlabora.where("anno = '#{anno}' and mes = '#{mes}' and user_asigna = #{isadmin} and contratosperfecha_id = #{@contratosperfecha.id}").first
      contratosperlabora.update(labora: params[:contratosperlabora][:labora], codigo_firma: SecureRandom.hex)
    end
  end

  # GET /contratosperlaboras/new
  def new
    @contratosperlabora = Contratosperlabora.new
  end

  # GET /contratosperlaboras/1/edit
  def edit
  end

  # POST /contratosperlaboras
  # POST /contratosperlaboras.json
  def create
    @contratosperlabora = Contratosperlabora.new(contratosperlabora_params)

    respond_to do |format|
      if @contratosperlabora.save
        format.html { redirect_to @contratosperlabora, notice: 'Contratosperlabora was successfully created.' }
        format.json { render :show, status: :created, location: @contratosperlabora }
      else
        format.html { render :new }
        format.json { render json: @contratosperlabora.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contratosperlaboras/1
  # PATCH/PUT /contratosperlaboras/1.json
  def update
    respond_to do |format|
      if @contratosperlabora.update(contratosperlabora_params)
        format.html { redirect_to @contratosperlabora, notice: 'Contratosperlabora was successfully updated.' }
        format.json { render :show, status: :ok, location: @contratosperlabora }
      else
        format.html { render :edit }
        format.json { render json: @contratosperlabora.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contratosperlaboras/1
  # DELETE /contratosperlaboras/1.json
  def destroy
    @contratosperlabora.destroy
    respond_to do |format|
      format.html { redirect_to contratosperlaboras_url, notice: 'Contratosperlabora was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contratosperlabora
    @contratosperlabora = Contratosperlabora.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def contratosperlabora_params
    params.require(:contratosperlabora).permit(:contratosperfecha_id, :contratospersona_id, :anno, :mes, :labora, :user_asigna)
  end
end
