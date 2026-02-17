class ContratosprefacturasController < ApplicationController
  before_action :set_contratosprefactura, only: [:show,:visualizar,:edit, :update, :destroy, :destroy2, :mostrare]

  layout :set_layout
  #before_action :checkaccess
  #
  def generar_factura
    ActiveRecord::Base.connection.execute("update contratosprefacturas set fecha_vencimiento = date_add(now(),INTERVAL 30 DAY) where id = #{params[:id].to_s}")
    contratosprefactura = Contratosprefactura.find(params[:id])
    if contratosprefactura.siigo_id.to_s == ""
      code = WsController.crear_factura(contratosprefactura.id)
      flash[:success] = 'Factura de siigo generada con exito !!!'
      redirect_to edit_contrato_path(id: contratosprefactura.contrato_id, etapa: 'PR'), notice: "La factura ha sido registrado con Exito en SIIGO."
    else
      redirect_to edit_contrato_path(id: contratosprefactura.contrato_id, etapa: 'PR'), notice: "No se puede enviar de nuevo la factura."
    end
  end

  def generar_facturalocal
    ActiveRecord::Base.connection.execute("update contratosprefacturas set fecha_vencimiento = date_add(now(),INTERVAL 30 DAY) where id = #{params[:id].to_s}")
    contratosprefactura = Contratosprefactura.find(params[:id])
    if contratosprefactura.siigo_id.to_s == ""
      code = WsController.crear_factura(contratosprefactura.id)
      flash[:success] = 'Factura de siigo generada con exito !!!'
      redirect_to edit_contrato_path(id: contratosprefactura.contrato_id, etapa: 'PR'), notice: "La factura ha sido registrado con Exito en SIIGO."
    else
      redirect_to edit_contrato_path(id: contratosprefactura.contrato_id, etapa: 'PR'), notice: "No se puede enviar de nuevo la factura."
    end
  end


  def firma
    @contratosprefactura = Contratosprefactura.find(params[:id])
  end

  def update_firma
    @contratosprefactura = Contratosprefactura.find(params[:contratosprefactura_id])
    @contratosprefactura.firma = params[:contratosprefactura][:firma]
    @contratosprefactura.estado = 'APROBADO'
    @contratosprefactura.fecha_firma = Time.now
    @contratosprefactura.save(validate: false)
    flash[:notice] = "Firma Guardada con Exito !!!!!"
    redirect_to root_path
  end

  def checkaccess
    return is_permit('contratosprefacturas')
  end

  def new
    contratosprefactura = Contratosprefactura.new
    contratosprefactura.estado = 'PENDIENTE'
    contratosprefactura.user_id = is_admin
    contratosprefactura.etapa = 'A'
    contratosprefactura.contrato_id = params[:contrato_id]
    contratosprefactura.save
    redirect_to edit_contratosprefactura_path(etapa: "A", id: contratosprefactura.id), notice: "La prefactura ha sido iniciada con Exito."
  end

  def cambioestado
    is_auth_c_prefacturaesespecial = is_auth_c('prefacturaesespecial')
    @contratosprefactura = Contratosprefactura.find(params[:id])
    @contratosprefactura.estado = params[:estado]
    @contratosprefactura.save
    ActiveRecord::Base.connection.execute("CALL prc_prefact_saldos(#{@contratosprefactura.id})")
    if params[:estado].to_s == 'ENVIADO'
      redirect_to edit_contratosprefactura_path(etapa: "A", id: @contratosprefactura.id), notice: "Realizada con exito"
    elsif params[:estado].to_s == 'PENDIENTE'
      redirect_to edit_contrato_path(etapa: "PR", id: @contratosprefactura.contrato_id), notice: "Realizada con exito"
    else
      if is_auth_c_prefacturaesespecial
        redirect_to edit_contratosprefactura_path(etapa: "A", id: @contratosprefactura.id), notice: "Realizada con exito"
      else
        redirect_to root_path
      end
    end
  end

  def edit
    respond_to do |format|
      format.html { render :action => "contratosprefactura_form" }
    end
  end
=begin
  def create
    @contratosprefactura = Contratosprefactura.new(contratosprefactura_params)
    @contratosprefactura.etapa = 'A'
    @contratosprefactura.user_id = is_admin
    respond_to do |format|
      if @contratosprefactura.save
        format.html { redirect_to edit_contratosprefactura_path(etapa: "A", id: @contratosprefactura.id), notice: "El registro ha sido registrado con Exito." }
        format.json { render :show, status: :created, location: @contratosprefactura }
      else
        format.html { render :action => "contratosprefactura_form" }
        format.json { render json: @contratosprefactura.errors, status: :unprocessable_entity }
      end
    end
  end
=end
  def update
    #@contratosprefactura.user_act = is_admin
    if @contratosprefactura.update(contratosprefactura_params)
      flash['danger'] = "Usuario actualizado"
      redirect_to edit_contratosprefactura_path(id: @contratosprefactura.id, etapa: 'A')
    else
      render "contratosprefactura_form"
    end
  end

  def destroy
    idContrato = @contratosprefactura.contrato_id
    if @contratosprefactura.estado.to_s == 'PENDIENTE'
      @contratosprefactura.destroy
      flash[:notice] = "El registro ha sido borrado con Exito."
    else
      flash[:notice] = "El registro NO PUEDE SER ELIMINADO"
    end
    redirect_to edit_contrato_path(id: idContrato, etapa: 'PR')
  end

  def visualizar
    @contratosprefactura = Contratosprefactura.find(params[:id])
    fname = "AsearPrefactura_#{@contratosprefactura.id}"
    respond_to do |format|
      format.pdf { render pdf:"#{fname}.pdf", template:"contratosprefacturas/visualizar", encoding: "UTF-8", page_size: 'Letter',disposition: 'attachment'}
      format.xlsx { response.headers['Content-Disposition'] = "attachment; filename=#{fname}.xlsx"}
    end
  end

  def visualizare
    @contratosprefactura = Contratosprefactura.find(params[:id])
    fname = "AsearSolicitud_E_#{@contratosprefactura.id}"
    respond_to do |format|
      format.pdf { render pdf:"#{fname}.pdf", template:"contratosprefacturas/visualizare", encoding: "UTF-8", page_size: 'Letter',disposition: 'attachment'}
      format.xlsx { response.headers['Content-Disposition'] = "attachment; filename=#{fname}.xlsx"}
    end
  end

  def replicar
    contratosprefactura = Contratosprefactura.new
    contratosprefactura.estado = 'PENDIENTE'
    contratosprefactura.user_id = is_admin
    contratosprefactura.etapa = 'A'
    contratosprefactura.contrato_id = params[:contrato_id]
    contratosprefactura.save
    ActiveRecord::Base.connection.execute("CALL prc_duplicarprefactura(#{contratosprefactura.id},#{params[:id].to_i})")
    redirect_to edit_contratosprefactura_path(etapa: "A", id: contratosprefactura.id), notice: "El registro ha sido registrado con Exito."
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

  def set_contratosprefactura
    params[:etapa].to_s != "" ? Contratosprefactura.find(params[:id]).update_columns(etapa: params[:etapa].to_s) : nil
    @contratosprefactura = Contratosprefactura.find(params[:id])
    @contrato = Contrato.find(@contratosprefactura.contrato_id)
  end

  def contratosprefactura_params
    params.require(:contratosprefactura).permit!
  end
end

