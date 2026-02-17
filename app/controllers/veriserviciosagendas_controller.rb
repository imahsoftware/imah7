class VeriserviciosagendasController < ApplicationController
  before_action :set_veriserviciosagenda, only: [:show, :destroy]

  def index
    @veriserviciosagendas = Veriserviciosagenda.all
  end

  def prueba_pdf_hichart
    @veriserviciosagenda = Veriserviciosagenda.find(params[:id])
    @veriservicio = @veriserviciosagenda.veriservicio
    portafolio = Portafolio.find(1)
    @logo = portafolio.logo_empresa_assets
    respond_to do |format|
      format.pdf do
        render pdf: "prueba",
               template: "veriserviciosagendas/prueba_pdf_hichart.html.erb",
               encoding: "UTF-8", page_size: 'Letter', :margin => { top: 50, :bottom => 25, :left => 0, :right => 0 },
               :header => { spacing: 10, :html => { :template => 'veriservicios/headerPdf/header_acta_servicio.html.erb',  locals: { logo: @logo } } },
               encoding: "UTF-8",
               page_size: 'Letter'
      end
    end
  end


  def usuarios
    @veriserviciosagenda = Veriserviciosagenda.find(params[:id])
    @veriservicio = @veriserviciosagenda.veriservicio
    @veriserviciosuser = Veriserviciosuser.new
  end

  def conclusion
    @veriserviciosagenda = Veriserviciosagenda.find(params[:id])
    @veriservicio = @veriserviciosagenda.veriservicio
    @validacion = 'CONCLUSION'
  end


  def show_detalle
    @veriserviciosagenda = Veriserviciosagenda.find(params[:id])
    @ruta = params[:ruta]
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Veriserviciosagenda.find(params[:active_id]) if params[:active_id].present?
    @veriservicio = Veriservicio.find(params[:veriservicio_id])
    @veriserviciosagenda = Veriserviciosagenda.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Veriserviciosagenda.find(params[:active_id]) if params[:active_id].present?
    @veriserviciosagenda = Veriserviciosagenda.find(params[:id])
    @veriservicio = @veriserviciosagenda.veriservicio
    respond_to { |format| format.js }
  end

  def create
    @veriservicio  = Veriservicio.find(params[:veriservicio_id])
    @veriserviciosagenda = Veriserviciosagenda.new(veriserviciosagenda_params)
    @veriserviciosagenda.veriservicio_id = @veriservicio.id
    @veriserviciosagenda.user_id = is_admin
    respond_to do |format|
      if @veriserviciosagenda.save
        @veriservicio.estado_proceso = 'EN PROCESO'
        @veriservicio.save(validate: false)

        Veriserviciosuser.create!(veriservicio_id: @veriservicio.id, user_id: is_admin, veriserviciosagenda_id: @veriserviciosagenda.id)

        flash[:notice] = "#{t :notice_crea_msj}"
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @veriserviciosagenda } }
      end
    end
  end

  def update
    validacion = params[:validacion] rescue nil
    @veriserviciosagenda = Veriserviciosagenda.find(params[:id])
    @veriservicio = @veriserviciosagenda.veriservicio
    @veriserviciosagenda.validacion_conclusion(validacion)
    respond_to do |format|
      if @veriserviciosagenda.update(veriserviciosagenda_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @veriserviciosagenda } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @veriserviciosagenda.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_veriserviciosagenda
    @veriservicio = Veriservicio.find(params[:veriservicio_id])
    @veriserviciosagenda = Veriserviciosagenda.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def veriserviciosagenda_params
    params.require(:veriserviciosagenda).permit!
  end
end
