class ContratosperinvdetallesController < ApplicationController
  before_action :set_contratosperinvdetalle, only: [:show, :destroy]

  def index
    @contratosperinvdetalles = Contratosperinvdetalle.all
  end

  def update2
    @contratosperinvdetalle = Contratosperinvdetalle.find(params[:id])
    @contratosperinvdetalle.valida_devolucion(params[:devolucion])
    @contratosperinvdetalle.consecutivo_acta = params[:consecutivo]
    @contratosperinvdetalle.user_devolucion = is_admin
    @contratosperinvdetalle.fecha_devolucion = Time.now
    respond_to do |format|
      if @contratosperinvdetalle.update(contratosperinvdetalle_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperinvdetalle } }
      end
    end
  end

  def show
    respond_to { |format| format.js }
  end

  def marcar
    @contratosperinvdetalle = Contratosperinvdetalle.find(params[:id])
    @consecutivo = params[:consecutivo]
  end

  def new
    @active_record = Contratosperinvdetalle.find(params[:active_id]) if params[:active_id].present?
    @contratosperinventario = Contratosperinventario.find(params[:contratosperinventario_id])
    @contratosperinvdetalle = Contratosperinvdetalle.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosperinvdetalle.find(params[:active_id]) if params[:active_id].present?
    @contratosperinvdetalle = Contratosperinvdetalle.find(params[:id])
    @contratosperinventario = @contratosperinvdetalle.contratosperinventario
    respond_to { |format| format.js }
  end

  def show_detalle
    @ruta = params[:ruta]
    @contratosperinvdetalle = Contratosperinvdetalle.find(params[:id])
  end

  def fotoweb
    @image = Contratosperdetallesdoc.new
    @contratosperinvdetalle = Contratosperinvdetalle.find(params[:id])
  end

  def create
    @contratosperinventario = Contratosperinventario.find(params[:contratosperinventario_id])
    @contratosperinvdetalle = Contratosperinvdetalle.new(contratosperinvdetalle_params)
    @contratosperinvdetalle.contratosperinventario_id = @contratosperinventario.id
    @contratosperinvdetalle.user_id = is_admin
    respond_to do |format|
      if @contratosperinvdetalle.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperinvdetalle } }
      end
    end
  end

  def update
    @contratosperinvdetalle = Contratosperinvdetalle.find(params[:id])
    @contratosperinventario = @contratosperinvdetalle.contratosperinventario
    respond_to do |format|
      if @contratosperinvdetalle.update(contratosperinvdetalle_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperinvdetalle } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosperinvdetalle.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contratosperinvdetalle
    @contratosperinventario = Contratosperinventario.find(params[:contratosperinventario_id])
    @contratosperinvdetalle = Contratosperinvdetalle.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosperinvdetalle_params
    params.require(:contratosperinvdetalle).permit!
  end
end
