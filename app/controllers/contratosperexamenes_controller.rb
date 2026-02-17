class ContratosperexamenesController < ApplicationController
  before_action :set_contratosperexamen, only: [:show, :destroy]

  def index
    @contratosperexamenes = Contratosperexamen.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Contratosperexamen.find(params[:active_id]) if params[:active_id].present?
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratosperexamen = Contratosperexamen.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Contratosperexamen.find(params[:active_id]) if params[:active_id].present?
    @contratosperexamen = Contratosperexamen.find(params[:id])
    @contratospersona = @contratosperexamen.contratospersona
    respond_to { |format| format.js }
  end

  def create
    @contratospersona  = Contratospersona.find(params[:contratospersona_id])
    @contratosperexamen = Contratosperexamen.new(contratosperexamen_params)
    @contratosperexamen.contratospersona_id = @contratospersona.id
    @contratosperexamen.user_id = is_admin
    @contratosperexamen.estado = 'PENDIENTE'
    respond_to do |format|
      if @contratosperexamen.save
        if @contratosperexamen.user_asignado.to_s != ""
          ActiveRecord::Base.connection.execute("update contratospersonas set user_asignado = #{@contratosperexamen.user_asignado} where id = #{@contratosperexamen.contratospersona_id}")
        end
        if @contratosperexamen.contrato_fecha.to_s != "" and @contratosperexamen.contrato_hora.to_s != ""
          ActiveRecord::Base.connection.execute("update contratospersonas set contrato_fecha = '#{@contratosperexamen.contrato_fecha.to_date}',
                                                                              contrato_hora = '#{@contratosperexamen.contrato_hora}' where id = #{@contratosperexamen.contratospersona_id}")
        end
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperexamen } }
      end
    end
  end

  def update
    @contratosperexamen = Contratosperexamen.find(params[:id])
    @contratosperexamen.user_act = is_admin
    @contratospersona = @contratosperexamen.contratospersona
    respond_to do |format|
      if @contratosperexamen.update(contratosperexamen_params)
        if is_auth_c('contratosperexamen') and @contratospersona.user_asignado.to_s == "" and @contratosperexamen.user_asignado.to_s != ""
          ActiveRecord::Base.connection.execute("update contratospersonas set user_asignado = #{@contratosperexamen.user_asignado} where id = #{@contratosperexamen.contratospersona_id}")
        end
        if @contratosperexamen.contrato_fecha.to_s != "" and @contratosperexamen.contrato_hora.to_s != ""
          ActiveRecord::Base.connection.execute("update contratospersonas set contrato_fecha = '#{@contratosperexamen.contrato_fecha.to_date}',
                                                                              contrato_hora = '#{@contratosperexamen.contrato_hora}' where id = #{@contratosperexamen.contratospersona_id}")
        end
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosperexamen } }
      end
    end
  end

  def destroy
    flash['success'] = 'Eliminado correctamente'
    @contratosperexamen.destroy
  end

  def cambioestado
    if params[:estado].to_s == 'RECORDATORIO'
      @contratosperexamen = Contratosperexamen.find(params[:id])
      @contratosperexamen.recordacion = 'SI'
      @contratosperexamen.save
      Contratosperbitacora.create(contratospersona_id: @contratosperexamen.contratospersona_id, user_id: is_admin, estado: 'RECORDACION DE CITA')
      redirect_to edit_contrato_path(etapa: "P1", id: @contratosperexamen.contratospersona.contrato_id), notice: "Realizada con exito"
    elsif params[:estado].to_s == 'RECORDATORIOE'
      @contratosperexamen = Contratosperexamen.find(params[:id])
      @contratosperexamen.recordacion = 'SI'
      @contratosperexamen.save
      Contratosperbitacora.create(contratospersona_id: @contratosperexamen.contratospersona_id, user_id: is_admin, estado: 'RECORDACION DE CITA')
      redirect_to root_path
    else
      @contratosperexamen = Contratosperexamen.find(params[:id])
      @contratosperexamen.estado = params[:estado]
      @contratosperexamen.user_act = is_admin
      @contratosperexamen.save
      if params[:estado].to_s == 'APROBADO'
        Contratosperbitacora.create(contratospersona_id: @contratosperexamen.contratospersona_id, user_id: is_admin, estado: 'APROBACION EXAMENES')
        redirect_to edit_contrato_path(etapa: "P1", id: @contratosperexamen.contratospersona.contrato_id), notice: "Realizada con exito"
      elsif params[:estado].to_s == 'RECHAZADO'
        Contratosperbitacora.create(contratospersona_id: @contratosperexamen.contratospersona_id, user_id: is_admin, estado: 'RECHAZO EXAMENES')
        redirect_to edit_contrato_path(etapa: "P1", id: @contratosperexamen.contratospersona.contrato_id), notice: "Realizada con exito"
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contratosperexamen
    @contratospersona = Contratospersona.find(params[:contratospersona_id])
    @contratosperexamen = Contratosperexamen.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contratosperexamen_params
    params.require(:contratosperexamen).permit!
  end
end
