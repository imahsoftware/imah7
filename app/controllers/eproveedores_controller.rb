class EproveedoresController < ApplicationController
  before_action :set_eproveedor, only: [:show, :edit, :update, :destroy]

  layout :set_layout
  before_action :checkaccess

  def checkaccess
    return is_permit('eproveedores')
  end

  def show_detalle
    @ruta = params[:ruta]
    @consecutivo = params[:egreso_id]
    @datos = Egreso.find(@consecutivo)
  end

  def index
    isadmin = is_admin
    nroreg = 10
    @eproveedores = Eproveedor.search(params[:nombre],isadmin,params[:page],nroreg,@vcAutoCon,@vcAutoConb,@idContrato,params[:egreso])
    respond_to do |format|
      @eproveedores.present? ?
        flash[:notice] = "Total de registros encontrados #{@eproveedores.count}" :
        flash[:notice] = "No hay resultado de la busqueda"
      format.js
      format.html
    end
  end

  def new
    @eproveedor = Eproveedor.new
    @eproveedor.etapa = 'A'
    render "eproveedor_form"
  end

  def edit
    if @etapa == 'B'
      @eproveedorescompras = @eproveedor.eproveedorescompras.order("created_at desc").paginate(:page => params[:eproveedorescompras], :per_page => 10)
    elsif @etapa == 'C'
      @eproveedorestempcompras = @eproveedor.eproveedorestempcompras.order("created_at desc").paginate(:page => params[:eproveedorestempcompras], :per_page => 10)
    end
    respond_to do |format|
      format.html { render :action => "eproveedor_form" }
    end
  end

  def create
    @eproveedor = Eproveedor.new(eproveedor_params)
    @eproveedor.etapa = 'A'
    @eproveedor.user_id = is_admin
    respond_to do |format|
      if @eproveedor.save
        format.html { redirect_to edit_eproveedor_path(etapa: "A", id: @eproveedor.id), notice: "Creado con Exito." }
        format.json { render :show, status: :created, location: @eproveedor }
      else
        format.html { render :action => "eproveedor_form" }
        format.json { render json: @eproveedor.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @eproveedor.user_act = is_admin
    if @eproveedor.update(eproveedor_params)
      flash[:notice] = "Actualizado con Exito"
      redirect_to edit_eproveedor_path(id: @eproveedor.id, etapa: 'A')
    else
      render "eproveedor_form"
    end
  end

  def destroy
    @eproveedor.destroy
    flash[:notice] = "El registro ha sido borrado con Exito."
    redirect_to eproveedores_path;
  end

=begin
  def egreso
    iscliente = is_cliente
    if Proveedorestemegreso.exists?(["cliente_id = #{iscliente} and proveedor_id = #{params[:proveedor_id]}"])
      ededuc = "NO"
      fechainferior = 'NO'
      fchegreso = ""
      fch = Egreso.maximum('fecha', :conditions=>["cliente_id = #{iscliente} and estado != 'ANULADO'"])
      @proveedorestemegresos   = Proveedorestemegreso.find(:all, :conditions=>["cliente_id = #{iscliente} and proveedor_id = #{params[:proveedor_id]}"])
      @proveedorestemegresos.each do |proveedorestemegreso|
        if fch.to_s != ""
          if fch > proveedorestemegreso.fecha
            fechainferior = 'SI'
          else
            fchegreso = proveedorestemegreso.fecha
          end
        else
          fchegreso = proveedorestemegreso.fecha
        end
      end
      if fechainferior.to_s == 'NO'
        nroegreso = is_egreso
        #logger.error("1")
        # Crea la Factura
        egreso = Egreso.new
        egreso.nro_egreso = nroegreso
        egreso.proveedor_id = params[:proveedor_id].to_i
        egreso.fecha = fchegreso
        egreso.user_id = is_admin
        egreso.total = Proveedorestemegreso.sum("total", :conditions=>["cliente_id = #{iscliente} and proveedor_id = #{params[:proveedor_id]}"])
        egreso.estado  = 'PENDIENTE'
        egreso.cliente_id = iscliente
        egreso.save
        #logger.error("2")
        last_id = egreso.id
        #last_id = Egreso.maximum('id')
        #logger.error("3")
        @proveedorestemegresos.each do |empresastemporal|
          if empresastemporal.cuenta_id.to_s != ""
            ActiveRecord::Base.connection.execute("update egresos set nro_cheque = '#{empresastemporal.nro_cheque.to_s}', forma_pago = '#{empresastemporal.forma_pago.to_s}', cuenta_id = #{empresastemporal.cuenta_id.to_i} where id = #{last_id}")
          end
          egresosdetalle = Egresosdetalle.new
          egresosdetalle.egreso_id = last_id
          egresosdetalle.concepto = empresastemporal.concepto
          egresosdetalle.total = empresastemporal.total
          egresosdetalle.user_id = is_admin
          egresosdetalle.codigoscontable_id = empresastemporal.codigoscontable_id
          egresosdetalle.centroscosto_id = empresastemporal.centroscosto_id
          egresosdetalle.cliente_id = iscliente
          egresosdetalle.save
        end
        ActiveRecord::Base.connection.execute("update egresos set saldo = total_final where cliente_id = #{iscliente} and id = #{last_id}")
        ActiveRecord::Base.connection.execute("delete from proveedorestemegresos where cliente_id = #{iscliente} and proveedor_id = #{params[:proveedor_id]}")
        flash[:notice] = "Egreso Nro. #{nroegreso} Creada con exito."
        redirect_to :controller=>'proveedores', :action => 'edit', :id =>params[:proveedor_id].to_i
      else
        flash[:warning] = "La fecha de los registros deben ser iguales o superior a "+fch.to_s
        redirect_to :controller=>'proveedores', :action => 'edit', :id =>params[:proveedor_id].to_i
      end
    else
      flash[:warning] = "NO hay datos para generar egresos directos"
      redirect_to :controller=>'proveedores', :action => 'edit', :id =>params[:proveedor_id].to_i
    end
  end
=end

  def egresoe
    eproveedorId = params[:eproveedor_id].to_i
    if Eproveedorestempcompra.where(eproveedor_id: eproveedorId).exists?
      ActiveRecord::Base.connection.execute("call prc_eproveedores_causacion(#{eproveedorId},#{is_admin});")
      flash[:warning] = "Egreso generado con exito.."
      redirect_to edit_eproveedor_path(id: eproveedorId, etapa: 'C')
    else
      flash[:warning] = "No hay datos para el Egreso.."
      redirect_to edit_eproveedor_path(id: eproveedorId, etapa: 'C')
    end
  end

  def egresod
    eproveedorId = params[:eproveedor_id].to_i
    if Eproveedorestemegreso.where(eproveedor_id: eproveedorId, estado: nil).exists?
      ActiveRecord::Base.connection.execute("call prc_eproveedores_causaciondirecto(#{eproveedorId},#{is_admin});")
      flash[:warning] = "Egreso generado con exito.."
      redirect_to edit_eproveedor_path(id: eproveedorId, etapa: 'D')
    else
      flash[:warning] = "No hay datos para el Egreso.."
      redirect_to edit_eproveedor_path(id: eproveedorId, etapa: 'D')
    end
  end

  private

  def set_layout
    if ['edit'].include?(action_name)
      'application_eproveedores'
    else
      "application_admin"
    end
  end

  def set_eproveedor
    params[:etapa].to_s != "" ? Eproveedor.find(params[:id]).update_columns(etapa: params[:etapa].to_s) : nil
    @etapa = params[:etapa].to_s rescue nil
    @eproveedor = Eproveedor.find(params[:id])
  end

  def eproveedor_params
    params.require(:eproveedor).permit!
  end
end

