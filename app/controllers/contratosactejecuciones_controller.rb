class ContratosactejecucionesController < ApplicationController
  before_action :set_contratosactejecucion, only: [:show, :edit, :update, :destroy]

=begin
  def new
    eje = Contratosactejecucion.new
    eje.contratosactividad_id = params[:contratosactividad_id]
    eje.contratossede_id = params[:contratossede_id]
    eje.user_id = is_admin
    eje.realizada = 'SI'
    eje.save
    redirect_to root_path, notice: "Se ha realizado exitosamente la marcación de la actividad."
  end
=end

  def new2
    @contratosactejecucion = Contratosactejecucion.new
    @contratosactejecucion.contratosactividad_id = params[:contratosactividad_id]
    @contratosactejecucion.contratosnodo_id = params[:contratosnodo_id]
  end

  def create2
    @contratosactejecucion = Contratosactejecucion.new(contratosactejecucion_params)
    @contratosactejecucion.contratosactividad_id = params[:contratosactividad_id]
    @contratosactejecucion.contratosnodo_id = params[:contratosnodo_id]
    @contratosactejecucion.user_id = is_admin
    @contratosactejecucion.realizada = 'NO'
    respond_to do |format|
      if @contratosactejecucion.save
        flash[:notice] = "Observacion Registrada con exito."
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @contratosactejecucion } }
      end
    end
  end

  def index
    isportafolio = is_portafolio
    isadmin = is_admin
    msj = ""
    if params[:etapa].to_s == ""
      @etapa = '11'
      ActiveRecord::Base.connection.execute("update users set etapa_persona = '11' where id = #{isadmin}")
    else
      @etapa = params[:etapa]
      ActiveRecord::Base.connection.execute("update users set etapa_persona = '#{params[:etapa]}' where id = #{isadmin}")
    end
    if @etapa.to_s == "11"
      contratosactividad_id = params[:ubicacion][:contratosactividad_id].to_s rescue ""
      contratossede_id = params[:ubicacion][:contratossede_id].to_s rescue ""
      user_id = params[:ubicacion][:user_id].to_s rescue ""
      realizada = params[:ubicacion][:realizada].to_s rescue ""
      clase = params[:ubicacion][:clase].to_s rescue ""
      if params[:format] == 'xlsx'
        nroreg = 100000
      else
        nroreg = 10
      end
      @contratosactejecuciones = Contratosactejecucion.joins(:contratosactividad, :contratossede, :user).search(contratosactividad_id,contratossede_id,user_id,params[:fchinicio],params[:fchfin],realizada,clase,params[:page],nroreg)
      if @contratosactejecuciones.present?
        flash[:warning] = "Debe seleccionar algun campo o no hay resultados de la consulta!!!"
      else
        respond_to do |format|
          format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="Asear_ejeact_'+"#{Time.now.strftime("%Y%m%d_%X")}"+'.xlsx"'}
          format.html # index.html.erb
        end
      end
    elsif @etapa.to_s == "12"
      detalle = params[:detalle].to_s rescue ""
      contratossede_id = params[:ubicacion][:contratossede_id].to_s rescue ""
      tipo = params[:ubicacion][:tipo].to_s rescue ""
      clase = params[:ubicacion][:clase].to_s rescue ""
      dia_semana = params[:ubicacion][:dia_semana].to_s rescue ""
      if detalle != "" or contratossede_id != "" or tipo != "" or clase != "" or dia_semana != ""
        msj ="No hay resultados de la consulta"
      end
      if params[:format] == 'xlsx'
        nroreg = 100000
      else
        nroreg = 10
      end
      @contratosactividades = Contratosactividad.search(detalle,contratossede_id,tipo,clase,dia_semana,params[:page],nroreg)
      if @contratosactividades.count.to_i == 0
        flash[:warning] = "Debe seleccionar algun campo o no hay resultados de la consulta!!!"
      else
        respond_to do |format|
          format.html # index.html.erb
          format.xml  { render :xml => @contratosactividades }
          format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="Asear_segact_'+"#{Time.now.strftime("%Y%m%d_%X")}"+'.xlsx"'}
        end
      end
    elsif @etapa.to_s == "13"
      contratossede_id = params[:ubicacion][:contratossede_id].to_s rescue ""
      user_id = params[:ubicacion][:user_id].to_s rescue ""
      @tipo = params[:ubicacion][:nodo].to_s rescue ""
      if (contratossede_id != "" or user_id != "" or params[:fchinicio].to_s != "" or params[:fchfin].to_s != "") and @tipo != ""
        msj ="No hay resultados de la consulta"
      end
      nroreg = 100000
      @contratosactcodigosinfos = Contratosactcodigosinfo.search(contratossede_id,@tipo,user_id,params[:fchinicio],params[:fchfin],params[:page],nroreg)
      @contratosactcodigos = Contratosactcodigo.search(contratossede_id,@tipo,user_id,params[:fchinicio],params[:fchfin],params[:page],nroreg)
      if @contratosactcodigosinfos.count.to_i == 0
        flash[:warning] = "Debe seleccionar siempre el Tipo o no hay resultados de la consulta!!!"
      else
        respond_to do |format|
          format.html # index.html.erb
          format.xml  { render :xml => @contratosactcodigosinfos }
          format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="Asear_SegDiario_'+"#{Time.now.strftime("%Y%m%d_%X")}"+'.xlsx"'}
        end
      end
    elsif @etapa.to_s == "14"
      contratossede_id = params[:ubicacion][:contratossede_id].to_s rescue ""
      user_id = params[:ubicacion][:user_id].to_s rescue ""
      @tipo = params[:ubicacion][:nodo].to_s rescue ""
      if (contratossede_id != "" or user_id != "" or params[:fchinicio].to_s != "" or params[:fchfin].to_s != "") and @tipo != ""
        msj ="No hay resultados de la consulta"
      end
      nroreg = 100000
      @contratosactmcodigosinfos = Contratosactmcodigosinfo.search(contratossede_id,@tipo,user_id,params[:fchinicio],params[:fchfin],params[:page],nroreg)
      @contratosactmcodigos = Contratosactmcodigo.search(contratossede_id,@tipo,user_id,params[:fchinicio],params[:fchfin],params[:page],nroreg)
      if @contratosactmcodigosinfos.count.to_i == 0
        flash[:warning] = "Debe seleccionar siempre el Tipo o no hay resultados de la consulta!!!"
      else
        respond_to do |format|
          format.html # index.html.erb
          format.xml  { render :xml => @contratosactmcodigosinfos }
          format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="Asear_SegMensual_'+"#{Time.now.strftime("%Y%m%d_%X")}"+'.xlsx"'}
        end
      end
    elsif @etapa.to_s == "15"
    end
  end


  # GET /contratosactejecuciones/1
  # GET /contratosactejecuciones/1.json
  def show
  end

  # GET /contratosactejecuciones/1/edit
  def edit
  end

  # POST /contratosactejecuciones
  # POST /contratosactejecuciones.json
  def create
    @contratosactejecucion = Contratosactejecucion.new(contratosactejecucion_params)

    respond_to do |format|
      if @contratosactejecucion.save
        format.html { redirect_to @contratosactejecucion, notice: 'Contratosactejecucion was successfully created.' }
        format.json { render :show, status: :created, location: @contratosactejecucion }
      else
        format.html { render :new }
        format.json { render json: @contratosactejecucion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contratosactejecuciones/1
  # PATCH/PUT /contratosactejecuciones/1.json
  def update
    respond_to do |format|
      if @contratosactejecucion.update(contratosactejecucion_params)
        format.html { redirect_to @contratosactejecucion, notice: 'Contratosactejecucion was successfully updated.' }
        format.json { render :show, status: :ok, location: @contratosactejecucion }
      else
        format.html { render :edit }
        format.json { render json: @contratosactejecucion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contratosactejecuciones/1
  # DELETE /contratosactejecuciones/1.json
  def destroy
    @contratosactejecucion.destroy
    respond_to do |format|
      format.html { redirect_to contratosactejecuciones_url, notice: 'Contratosactejecucion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contratosactejecucion
      @contratosactejecucion = Contratosactejecucion.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def contratosactejecucion_params
      params.require(:contratosactejecucion).permit!
    end
end
