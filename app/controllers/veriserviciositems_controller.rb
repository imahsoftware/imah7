class VeriserviciositemsController < ApplicationController
  before_action :set_veriserviciositem, only: [:show, :destroy]
  skip_before_action :verify_authenticity_token, only: [:update_items]

  def index
    @veriserviciositems = Veriserviciositem.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Veriserviciositem.find(params[:active_id]) if params[:active_id].present?
    @veriservicio = Veriservicio.find(params[:veriservicio_id])
    @veriserviciositem = Veriserviciositem.new
    respond_to { |format| format.js }
  end

  def nota
    @veriserviciosinota = Veriserviciosinota.new
    @veriserviciositem = Veriserviciositem.find(params[:id])
    @veriservicio = @veriserviciositem.veriservicio
  end

  def compromiso
    @veriserviciosicompromiso = Veriserviciosicompromiso.new
    @veriserviciositem = Veriserviciositem.find(params[:id])
    @veriservicio = @veriserviciositem.veriservicio
  end

  def documento
    @veriserviciosiimagen = Veriserviciosiimagen.new
    @veriserviciositem = Veriserviciositem.find(params[:id])
    @veriservicio = @veriserviciositem.veriservicio
  end

  def show_detalle
    @veriserviciositem = Veriserviciositem.find(params[:id])
    @ruta = params[:ruta]
  end

  def item
    @etapa = params[:etapa].present? ? params[:etapa] : 'A'
    @veriserviciositem = Veriserviciositem.find(params[:id])
  end

  def captura_imagen
    @veriserviciositem = Veriserviciositem.find(params[:veriserviciositem_id])

    data = params[:veriserviciosiimagen][:veriimagen]
    image_data = Base64.decode64(data)
    new_file = File.new("public/webcam/capturaItem_#{Time.now.strftime('%d%m%Y%X')}.png", 'wb')
    new_file.write(image_data)
    file = File.open(new_file, 'rb')

    @veriserviciosiimagen = Veriserviciosiimagen.new(
      veriserviciositem_id: @veriserviciositem.id,
      user_id: is_admin, # Asegúrate de usar el método correcto para obtener el ID del usuario actual
      descripcion: params[:veriserviciosiimagen][:descripcion],
      veriimagen: file
    )

      if @veriserviciosiimagen.save(validate: false)
        flash[:notice] = "Se creó con éxito!"
        redirect_to item_veriserviciositems_path(id: @veriserviciositem.id)
      end
  end

  def update_items
    @veriserviciositem = Veriserviciositem.find(params[:id])
    veriservicio = @veriserviciositem.veriservicio
    total_items = Veriserviciositem.where(veriservicio_id: @veriserviciositem.veriservicio.id).count rescue 0
    @evaluador = false
    @mensaje = false
    if ['EN PROCESO', 'PENDIENTE'].include?(veriservicio.estado_proceso)
      if @veriserviciositem.update(veriserviciositem_params)
        if total_items.to_i == Veriserviciositem.where("veriservicio_id = #{@veriserviciositem.veriservicio.id} AND calificacion IS NOT NULL and calificacion NOT IN (1,2,3)").count.to_i
          @evaluador = true
        end
        if Veriserviciositem.where("veriservicio_id = #{@veriserviciositem.veriservicio.id} AND calificacion IS NOT NULL and calificacion IN (1,2,3)").present? and
          total_items.to_i == Veriserviciositem.where("veriservicio_id = #{@veriserviciositem.veriservicio.id} AND calificacion IS NOT NULL").count.to_i
          @mensaje = true
        end
        Rails.logger.debug "Enviando JSON: #{ { success: true, evaluador: @evaluador, mensaje: @mensaje }.to_json }"
        respond_to do |format|
          format.json { render json: { success: true, evaluador: @evaluador, mensaje: @mensaje }, status: :ok }
        end
      else
        Rails.logger.debug "Error JSON: #{ { success: false, errors: @veriserviciositem.errors.full_messages }.to_json }"
        respond_to do |format|
          format.json { render json: { success: false, errors: @veriserviciositem.errors.full_messages }, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.json { render json: { success: true }, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @active_record = Veriserviciositem.find(params[:active_id]) if params[:active_id].present?
    @veriserviciositem = Veriserviciositem.find(params[:id])
    @veriservicio = @veriserviciositem.veriservicio
    respond_to { |format| format.js }
  end

  def create
    @veriservicio = Veriservicio.find(params[:veriservicio_id])
    @veriserviciositem = Veriserviciositem.new(veriserviciositem_params)
    @veriserviciositem.veriservicio_id = @veriservicio.id
    respond_to do |format|
      if @veriserviciositem.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @veriserviciositem } }
      end
    end
  end

  def update
    @veriserviciositem = Veriserviciositem.find(params[:id])
    @veriservicio = @veriserviciositem.veriservicio
    respond_to do |format|
      if @veriserviciositem.update(veriserviciositem_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @veriserviciositem } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @veriserviciositem.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_veriserviciositem
    @veriservicio = Veriservicio.find(params[:veriservicio_id])
    @veriserviciositem = Veriserviciositem.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def veriserviciositem_params
    params.require(:veriserviciositem).permit!
  end
end
