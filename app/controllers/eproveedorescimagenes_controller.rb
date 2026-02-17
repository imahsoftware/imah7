class EproveedorescimagenesController < ApplicationController
  before_action :set_eproveedorescimagen, only: [:show, :edit, :update, :destroy]

  def index
    @eproveedorescimagenes = Eproveedorescimagen.all
  end

  def show
  end

  def new
    @eproveedorescimagen = Eproveedorescimagen.new
    @eproveedorescimagen.eproveedorescompra_id = params[:eproveedorescompra_id].to_i
  end

  def edit
  end

  def create
    @eproveedorescimagen = Eproveedorescimagen.new(eproveedorescimagen_params)
    @eproveedorescimagen.user_id = is_admin
    respond_to do |format|
      if @eproveedorescimagen.save
        flash['success'] = "Documento cargado con exito"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @eproveedorescimagen } }
      end
    end
  end

  def update
    respond_to do |format|
      if @eproveedorescimagen.update(eproveedorescimagen_params)
        format.html { redirect_to @eproveedorescimagen, notice: 'Eproveedorescimagen was successfully updated.' }
        format.json { render :show, status: :ok, location: @eproveedorescimagen }
      else
        format.html { render :edit }
        format.json { render json: @eproveedorescimagen.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @eproveedorescimagen.destroy
    respond_to do |format|
      format.html { redirect_to eproveedorescimagenes_url, notice: 'Eproveedorescimagen was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_eproveedorescimagen
    @eproveedorescimagen = Eproveedorescimagen.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def eproveedorescimagen_params
    params.require(:eproveedorescimagen).permit!
  end
end
