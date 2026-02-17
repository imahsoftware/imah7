class ContratoscaractividadesController < ApplicationController
  before_action :set_contratoscaractividad, only: [:show, :destroy, :new]

  def index
    @contratoscaractividades = Contratoscaractividad.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratoscaractividad.find(params[:active_id]) if params[:active_id].present?
    @contratoscargo = Contratoscargo.find(params[:contratoscargo_id])
    @contratoscaractividad = Contratoscaractividad.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratoscaractividad.find(params[:active_id]) if params[:active_id].present?
    @contratoscaractividad = Contratoscaractividad.find(params[:id])
    @contratoscargo = @contratoscaractividad.contratoscargo
    respond_to { |format| format.js }
  end

  def create
    @contratoscargo  = Contratoscargo.find(params[:contratoscargo_id])
    @contratoscaractividad = Contratoscaractividad.new(contratoscaractividad_params)
    @contratoscaractividad.contratoscargo_id = @contratoscargo.id
    @contratoscaractividad.user_id = is_admin
    if @contratoscaractividad.actividad.include? "*."
      valor = @contratoscaractividad.actividad.split('*.')
      vlrexiste = "S"
    else
      vlrexiste = "N"
    end
    if vlrexiste.to_s == 'S'
      i = 1
      while i < valor.size
        #logger.error(" valor...."+valor[i].to_s)
        @contratoscaractividad = Contratoscaractividad.new
        @contratoscaractividad.actividad = valor[i].to_s
        @contratoscaractividad.contratoscargo_id = @contratoscargo.id
        @contratoscaractividad.user_id = is_admin
        @contratoscaractividad.save
        i = i + 1
      end
      respond_to do |format|
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      end
    else
      respond_to do |format|
        if @contratoscaractividad.save
          flash[:notice] = "#{t :notice_crea_msj}"
          format.js
        else
          format.js { render 'layouts/errors', locals: { object: @contratoscaractividad } }
        end
      end
    end
  end

  def update
    @contratoscaractividad = Contratoscaractividad.find(params[:id])
    @contratoscargo = @contratoscaractividad.contratoscargo
    respond_to do |format|
      if @contratoscaractividad.update(contratoscaractividad_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratoscaractividad } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratoscaractividad.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratoscaractividad
    @contratoscargo = Contratoscargo.find(params[:contratoscargo_id])
    @contratoscaractividad = Contratoscaractividad.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratoscaractividad_params
    params.require(:contratoscaractividad).permit!
  end
end
