class ContratosinsimagenesController < ApplicationController
  before_action :set_contratosinsimagen, only: [:show, :edit, :update, :destroy]

  def index
    @contratosinsimagenes = Contratosinsimagen.all
  end

  def show
  end

  def new
    @contratosinsimagen = Contratosinsimagen.new
    @contratosinsimagen.contratosinsumo_id = params[:contratosinsumo_id].to_i
  end

  def edit
  end

  def create
    @contratosinsimagen = Contratosinsimagen.new(contratosinsimagen_params)
    @contratosinsimagen.user_id = is_admin
    respond_to do |format|
      if @contratosinsimagen.save
        # Borra el anterior....
        Contratosinsimagen.where(["contratosinsumo_id = #{@contratosinsimagen.contratosinsumo_id} and id != #{@contratosinsimagen.id}"]).delete_all
        flash['success'] = "Documento cargado con exito"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosinsimagen } }
      end
    end
  end

  def update
    respond_to do |format|
      if @contratosinsimagen.update(contratosinsimagen_params)
        format.html { redirect_to @contratosinsimagen, notice: 'Contratosinsimagen was successfully updated.' }
        format.json { render :show, status: :ok, location: @contratosinsimagen }
      else
        format.html { render :edit }
        format.json { render json: @contratosinsimagen.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contratosinsimagenes/1
  # DELETE /contratosinsimagenes/1.json
  def destroy
    @contratosinsimagen.destroy
    respond_to do |format|
      format.html { redirect_to contratosinsimagenes_url, notice: 'Eliminada con exito.' }
      format.json { head :no_content }
    end
  end

  def masivo
    datos = Objeto.find_by_sql(["select * from tmpimagenes"])
    datos.each do |g|
      file = File.open("/home/deploy/coquetin/public/img/#{g.imagen.to_s}", 'rb')
      a = Contratosinsimagen.new
      a.contratosinsumo_id = g.contratosinsumo_id
      a.user_id = 10002
      a.insumosimagen = file
      a.save
      file.close
    end
    redirect_to root_path
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosinsimagen
    @contratosinsimagen = Contratosinsimagen.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosinsimagen_params
    params.require(:contratosinsimagen).permit!
  end
end
