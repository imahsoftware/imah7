class SoportesController < ApplicationController
  before_action :set_soporte, only: [:show, :edit, :update, :destroy, :finalizar]

  layout :set_layout

  # GET /soportes
  # GET /soportes.json

  def finalizar
    @soporte.fecha_atencion = Time.now
    @soporte.estado = 'FINALIZADO'
    @soporte.save(validate: false)
    mensaje = "ASEAR: Estimad@ #{@soporte.user.nombre}, se te informa que se ha dado solucion al Ticket ##{@soporte.id}. ".html_safe
    Asearsms::SendsmsServices.new.send_sms_procesos(@soporte.mostrar_movil, mensaje)
    redirect_to soportes_path
  end

  def index
    @subetapa = params[:subetapa].present? ? params[:subetapa] : '1'
    nro_ticket = params[:nro_ticket].to_s rescue nil
    tipo = params[:ubicacion][:tipo] rescue nil
    if nro_ticket.to_s != "" or tipo.to_s != ""
      @soportes = Soporte.search(nro_ticket, tipo, params[:page], 10)
    else
      @soportes = Soporte.where(tipo: -1)
    end
    respond_to do |format|
      @soportes.present? ?
        flash[:notice] = "Total de registros encontrados #{@soportes.count}" :
        flash[:notice] = "No hay resultado de la busqueda"
      format.js
      format.html
    end
    if @subetapa == '2'
      if current_user.tipoconsulta == 'TODO'
        @q = Soporte.where("estado = 'PENDIENTE'").all
        @soportesPendientes = @q.paginate(:page => params[:page], :per_page => 15).order("id desc")
      else
        @q = Soporte.where("estado = 'PENDIENTE' and user_id = #{is_admin}").all
        @soportesPendientes = @q.paginate(:page => params[:page], :per_page => 15).order("id desc")
      end
    elsif @subetapa == '3'
      if current_user.tipoconsulta == 'TODO'
        @q = Soporte.where("estado = 'FINALIZADO'").all
        @soportesfinalizados = @q.paginate(:page => params[:page], :per_page => 15).order("id desc")
      else
        @q = Soporte.where("estado = 'FINALIZADO' and user_id = #{is_admin}").all
        @soportesfinalizados = @q.paginate(:page => params[:page], :per_page => 15).order("id desc")
      end
    end
  end

  # GET /soportes/1
  # GET /soportes/1.json
  def show
  end

  # GET /soportes/new
  def new
    @soporte = Soporte.new
    render "soporte_form"
  end

  # GET /soportes/1/edit
  def edit
    respond_to do |format|
      format.html { render :action => "soporte_form" }
    end
  end

  # POST /soportes
  # POST /soportes.json
  def create
    @soporte = Soporte.new(soporte_params)
    @soporte.user_id = is_admin
    @soporte.estado = 'PENDIENTE'
    respond_to do |format|
      if @soporte.save
        mensaje = "ASEAR: OEOEOEO Fabi, se ha creado un Ticket con el id #{@soporte.id} - Usuario Crea: #{@soporte.user.nombre rescue nil}".html_safe
        Asearsms::SendsmsServices.new.send_sms_procesos('3164637945', mensaje)
        format.html { redirect_to edit_soporte_path(id: @soporte.id), notice: "El registro ha sido registrado con Exito." }

        format.json { render :show, status: :created, location: @soporte }
      else
        format.html { render :action => "soporte_form" }
        format.json { render json: @soporte.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /soportes/1
  # PATCH/PUT /soportes/1.json
  def update
    respond_to do |format|
      if @soporte.update(soporte_params)
        format.html { redirect_to @soporte, notice: 'Soporte was successfully updated.' }
        format.json { render :show, status: :ok, location: @soporte }
      else
        format.html { render :edit }
        format.json { render json: @soporte.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /soportes/1
  # DELETE /soportes/1.json
  def destroy
    @soporte.destroy
    respond_to do |format|
      format.html { redirect_to soportes_url, notice: 'Soporte was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_layout
    if ['index', 'new'].include?(action_name)
      'application_admin'
    elsif ['edit'].include?(action_name)
      'application_admin'
    else
      "application_admin"
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_soporte
    @soporte = Soporte.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def soporte_params
    params.require(:soporte).permit!
  end
end
