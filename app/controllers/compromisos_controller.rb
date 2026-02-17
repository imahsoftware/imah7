class CompromisosController < ApplicationController
  before_action :set_compromiso, only: [:show, :destroy]

  def finalizar
    @compromiso = Compromiso.find(params[:id])
    @compromiso.estado = 'FINALIZAR'
    @compromiso.fecha_real_compromiso = Time.now
    @compromiso.user_marca = is_admin
  end

  def ver_documentos
    @compromiso = Compromiso.find(params[:compromiso_id])
  end

  def estado
    @estado = params[:estado]
    @contratosperimagen = Contratosperimagen.find(params[:contratosperimagen_id])
    @compromiso = Compromiso.find(params[:compromiso_id])
    if @estado == 'FINALIZADO'
      @compromiso.estado = 'FINALIZADO'
      @compromiso.fecha_real_compromiso = Time.now
      @compromiso.user_marca = is_admin
      @compromiso.save(validate: false)
      @contratosperimagen.estado = 'APROBADO'
      @contratosperimagen.save(validate: false)
    elsif @estado == 'RECHAZADO' and Contratosperimagen.where("compromiso_id = #{@compromiso.id} and estado = 'APROBADO'").present?
      @contratosperimagen.estado = 'RECHAZADO'
      @contratosperimagen.save(validate: false)
    elsif @estado == 'RECHAZADO' and Contratosperimagen.where("compromiso_id = #{@compromiso.id} and estado = 'APROBADO'").blank?
      @compromiso.estado = 'RECHAZADO'
      @compromiso.fecha_real_compromiso = Time.now
      @compromiso.user_marca = is_admin
      @compromiso.save(validate: false)
      @contratosperimagen.estado = 'RECHAZADO'
      @contratosperimagen.save(validate: false)
    end
    respond_to do |format|
      format.js { render inline: "location.reload();" }
    end
  end

  def index
    @compromisos = Compromiso.all
  end

  def cargar
    @compromiso = Compromiso.find(params[:compromiso_id])
    @personasformulario = Personasformulario.find(params[:personasformulario_id])
    @parcargosdoc = Parcargosdoc.find(params[:parcargosdoc_id])
    @contratosperfecha = Contratosperfecha.find(params[:contratosperfecha_id])
    @contratosperimagen = Contratosperimagen.new
  end


  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Compromiso.find(params[:active_id]) if params[:active_id].present?
    @personasformulario = Personasformulario.find(params[:personasformulario_id])
    @compromiso = Compromiso.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Compromiso.find(params[:active_id]) if params[:active_id].present?
    @compromiso = Compromiso.find(params[:id])
    @personasformulario = @compromiso.personasformulario
    respond_to { |format| format.js }
  end

  def create
    @personasformulario  = Personasformulario.find(params[:personasformulario_id])
    @compromiso = Compromiso.new(compromiso_params)
    @compromiso.personasformulario_id = params[:personasformulario_id]
    @compromiso.parcargosdoc_id = params[:parcargosdoc_id]
    @compromiso.user_compromiso = is_admin
    respond_to do |format|
      if @compromiso.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @compromiso } }
      end
    end
  end

  def update
    @compromiso = Compromiso.find(params[:id])
    @personasformulario = @compromiso.personasformulario
    respond_to do |format|
      if @compromiso.update(compromiso_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @compromiso } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @compromiso.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_compromiso
    @personasformulario = Personasformulario.find(params[:personasformulario_id])
    @compromiso = Compromiso.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def compromiso_params
    params.require(:compromiso).permit!
  end
end
