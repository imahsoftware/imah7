class ContratosperimagenesController < ApplicationController
  before_action :set_contratosperimagen, only: [:show, :destroy]

  def index
    @contratosperimagenes = Contratosperimagen.all
  end

  def show
    respond_to { |format| format.js }
  end

  def update_observacion
    @contratosperimagen =  Contratosperimagen.find(params[:id])
    @contratosperimagen.observacion_aprobacion = params[:contratosperimagen][:observacion_aprobacion]
    @contratosperimagen.save(validate: false)
  end

  def create2
    @compromiso = Compromiso.find(params[:compromiso_id])
    @contratosperfecha = Contratosperfecha.find(params[:contratosperfecha_id])
    @contratosperimagen = Contratosperimagen.new(contratosperimagen_params)
    @contratosperimagen.contratospersona_id = @contratosperfecha.contratospersona_id
    @contratosperimagen.contratosperfecha_id = @contratosperfecha.id
    @contratosperimagen.user_id = is_admin
    @contratosperimagen.estado = 'PENDIENTE'
    @contratosperimagen.compromiso_id = @compromiso.id
    @contratosperimagen.descripcion = @compromiso.parcargosdoc.descripcion
    respond_to do |format|
      if @contratosperimagen.save
        @compromiso.contratosperfecha_id = @contratosperfecha.id
        @compromiso.contratospersona_id = @contratosperfecha.contratospersona_id rescue nil
        @compromiso.save(validate: false)
        flash[:notice] = "Observacion Registrada con exito."
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperimagen } }
      end
    end
  end

  def decision
    @estado = params[:estado]
    @contratosperimagen =  Contratosperimagen.find(params[:id])
    @contratosperimagen.estado = @estado
    @contratosperimagen.save(validate: false)
  end

  def new
    @ruta = params[:ruta] rescue nil
    @active_record = Contratosperimagen.find(params[:active_id]) if params[:active_id].present?
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratosperimagen = Contratosperimagen.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosperimagen.find(params[:active_id]) if params[:active_id].present?
    @contratosperimagen = Contratosperimagen.find(params[:id])
    @contratospersona = @contratosperimagen.contratospersona
    respond_to { |format| format.js }
  end

  def create
    @ruta = params[:ruta] rescue nil
    @contratospersona  = Contratospersona.find(params[:contratospersona_id])
    @contratosperimagen = Contratosperimagen.new(contratosperimagen_params)
    if @ruta.present?
      contratosperfecha = Contratosperfecha.where("estado = 'ACTIVO' and contratospersona_id = (select id from contratospersonas where identificacion = '#{current_user.identificacion}' and (fecha_fin is null or fecha_fin >= curdate()))")[0]
      @contratosperimagen.contratosperfecha_id = contratosperfecha.id
    end
    @contratosperimagen.contratospersona_id = @contratospersona.id
    @contratosperimagen.user_id = is_admin
    @contratosperimagen.estado = 'PENDIENTE'
    respond_to do |format|
      if @contratosperimagen.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperimagen } }
      end
    end
  end

  def update
    @contratosperimagen = Contratosperimagen.find(params[:id])
    @contratospersona = @contratosperimagen.contratospersona
    respond_to do |format|
      if @contratosperimagen.update(contratosperimagen_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperimagen } }
      end
    end
  end

  def destroy
    if is_auth_e('depurarimagenes')
      flash['success'] = 'Eliminado correctamente'
      @contratosperimagen.destroy
    else
      if @contratosperimagen.estado.to_s == 'PENDIENTE'
        flash['success'] = 'Eliminado correctamente'
        @contratosperimagen.destroy
      else
        flash['danger'] = 'NO Eliminado'
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosperimagen
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratosperimagen = Contratosperimagen.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosperimagen_params
    params.require(:contratosperimagen).permit!
  end
end
