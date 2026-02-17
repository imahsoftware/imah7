class ContratossolicitudesController < ApplicationController
  before_action :set_contratossolicitud, only: [:show,:visualizar,:edit, :update, :destroy, :destroy2, :mostrare]

  layout :set_layout
  #before_action :checkaccess

  def firma
    @contratossolicitud = Contratossolicitud.find(params[:id])
  end

  def update_firma
    @contratossolicitud = Contratossolicitud.find(params[:contratossolicitud_id])
    @contratossolicitud.firma = params[:contratossolicitud][:firma]
    @contratossolicitud.fecha_firma = Time.now
    @contratossolicitud.save(validate: false)
    flash[:notice] = "Firma Guardada con Exito !!!!!"
    redirect_to root_path
  end

  def checkaccess
    return is_permit('contratossolicitudes')
  end

  def new
    contratossolicitud = Contratossolicitud.new
    contratossolicitud.etapa = 'A'
    contratossolicitud.estado = 'PENDIENTE'
    contratossolicitud.user_id = is_admin
    contratossolicitud.contrato_id = params[:contrato_id]
    contratossolicitud.periodo = is_fechaperiodo(Time.now,1)
    contratossolicitud.save
    ActiveRecord::Base.connection.execute("CALL prc_creasolicitud(#{contratossolicitud.id})")
    redirect_to edit_contratossolicitud_path(etapa: "A", id: contratossolicitud.id), notice: "El registro ha sido registrado con Exito."
  end

  def cambioestado
    @contratossolicitud = Contratossolicitud.find(params[:id])
    if @contratossolicitud.budget.to_s == 'OK'
      if params[:estado].to_s == 'SOLAPROBACION'
        @contratossolicitud.solicitud_aprobacion = Time.now
        @contratossolicitud.save
        Contratossolbitacora.create(contratossolicitud_id: @contratossolicitud.id, user_id: is_admin, estado: 'SOLICITUD APROBACION')
        redirect_to edit_contratossolicitud_path(etapa: "A", id: @contratossolicitud.id), notice: "Realizada con exito"
      else
        @contratossolicitud.estado = params[:estado]
        if params[:estado].to_s == 'DESPACHADOS'
          @contratossolicitud.fecha_despacho = Time.now
        end
        @contratossolicitud.save
        if params[:estado].to_s == 'ENVIADO'
          Contratossolbitacora.create(contratossolicitud_id: @contratossolicitud.id, user_id: is_admin, estado: params[:estado].to_s)
          # CON ESTO RECONFIRMA LOS DATOS
          ActiveRecord::Base.connection.execute("CALL prc_pruebarecursos(#{@contratossolicitud.contrato_id},#{@contratossolicitud.user_id},#{@contratossolicitud.id})")
          redirect_to edit_contratossolicitud_path(etapa: "A", id: @contratossolicitud.id), notice: "Realizada con exito"
        elsif params[:estado].to_s == 'PENDIENTE'
          Contratossolbitacora.create(contratossolicitud_id: @contratossolicitud.id, user_id: is_admin, estado: 'RESTABLECE ESTADO')
          redirect_to edit_contrato_path(etapa: "S", id: @contratossolicitud.contrato_id), notice: "Realizada con exito"
        else
          Contratossolbitacora.create(contratossolicitud_id: @contratossolicitud.id, user_id: is_admin, estado: params[:estado].to_s)
          redirect_to root_path
        end
      end
    else
      redirect_to edit_contratossolicitud_path(etapa: "A", id: @contratossolicitud.id), notice: "Problemas para enviar la solicitud."
    end
  end

  def edit
    respond_to do |format|
      format.html { render :action => "contratossolicitud_form" }
    end
  end

  def create
    @contratossolicitud = Contratossolicitud.new(contratossolicitud_params)
    @contratossolicitud.etapa = 'A'
    @contratossolicitud.user_id = is_admin
    respond_to do |format|
      if @contratossolicitud.save
        format.html { redirect_to edit_contratossolicitud_path(etapa: "A", id: @contratossolicitud.id), notice: "El registro ha sido registrado con Exito." }
        format.json { render :show, status: :created, location: @contratossolicitud }
      else
        format.html { render :action => "contratossolicitud_form" }
        format.json { render json: @contratossolicitud.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    #@contratossolicitud.user_act = is_admin
    if @contratossolicitud.update(contratossolicitud_params)
      flash['warning'] = "Registro Actualizado"
      redirect_to edit_contratossolicitud_path(id: @contratossolicitud.id, etapa: 'A')
    else
      render "contratossolicitud_form"
    end
  end

  def destroy
    idContrato = @contratossolicitud.contrato_id
    if @contratossolicitud.estado.to_s == 'PENDIENTE'
      @contratossolicitud.destroy
      flash[:notice] = "El registro ha sido borrado con Exito."
    else
      flash[:notice] = "El registro NO PUEDE SER ELIMINADO"
    end
    redirect_to root_path
    #redirect_to edit_contrato_path(id: idContrato, etapa: 'S')
  end

  def destroy2
    idContrato = @contratossolicitud.contrato_id
    if @contratossolicitud.estado.to_s == 'PENDIENTE'
      @contratossolicitud.destroy
      flash[:notice] = "El registro ha sido borrado con Exito."
    else
      flash[:notice] = "El registro NO PUEDE SER ELIMINADO"
    end
    redirect_to root_path
  end

  def visualizar
    @contratossolicitud = Contratossolicitud.find(params[:id])
    fname = "AsearSolicitud_#{@contratossolicitud.id}"
    respond_to do |format|
      format.pdf { render pdf:"#{fname}.pdf", template:"contratossolicitudes/visualizar", encoding: "UTF-8", page_size: 'Letter',disposition: 'attachment'}
      format.xlsx { response.headers['Content-Disposition'] = "attachment; filename=#{fname}.xlsx"}
    end
  end

  def visualizare
    @contratossolicitud = Contratossolicitud.find(params[:id])
    fname = "AsearSolicitud_E_#{@contratossolicitud.id}"
    respond_to do |format|
      format.pdf { render pdf:"#{fname}.pdf", template:"contratossolicitudes/visualizare", encoding: "UTF-8", page_size: 'Letter',disposition: 'attachment'}
      format.xlsx { response.headers['Content-Disposition'] = "attachment; filename=#{fname}.xlsx"}
    end
  end

  def replicar
    contratossolicitud = Contratossolicitud.new
    contratossolicitud.etapa = 'A'
    contratossolicitud.estado = 'PENDIENTE'
    contratossolicitud.user_id = is_admin
    contratossolicitud.contrato_id = params[:contrato_id]
    contratossolicitud.periodo = is_fechaperiodo(Time.now,1)
    contratossolicitud.save
    ActiveRecord::Base.connection.execute("CALL prc_duplicarsolicitud(#{contratossolicitud.id},#{params[:id].to_i})")
    redirect_to edit_contratossolicitud_path(etapa: "A", id: contratossolicitud.id), notice: "El registro ha sido registrado con Exito."
  end

  def insumosinforme
    @periodo = params[:annomes].to_s
    ActiveRecord::Base.connection.execute("CALL prc_insumosinforme('#{@periodo}')")
    fname = "InsumosPeriodo_#{@periodo}"
    respond_to do |format|
      format.xlsx { response.headers['Content-Disposition'] = "attachment; filename=#{fname}.xlsx"}
    end
  end

  private

  def set_layout
    if ['index', 'new'].include?(action_name)
      'application_admin'
    elsif ['edit'].include?(action_name)
      'application_admin'
    elsif ['show','visualizar','mostrare','insumosinforme'].include?(action_name)
      'blank'
    else
      "application_admin"
    end
  end

  def set_contratossolicitud
    params[:etapa].to_s != "" ? Contratossolicitud.find(params[:id]).update_columns(etapa: params[:etapa].to_s) : nil
    @contratossolicitud = Contratossolicitud.find(params[:id])
    @contrato = Contrato.find(@contratossolicitud.contrato_id)
  end

  def contratossolicitud_params
    params.require(:contratossolicitud).permit!
  end
end

