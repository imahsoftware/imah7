class MigracionesController < ApplicationController
  before_action :set_migracion, only: [:show, :edit, :update, :destroy]
  before_action :checkaccess

  def checkaccess
    return is_permit('migraciones/index_convocatorias')
  end

  def index
    @query = Migracion.where(["id in (select migracion_id from migracionesusers where user_id = #{is_admin} and migraciones.estado = 'ACTIVO' and migraciones.publicado = 'SI')"]).map { |m| [m.nombre, m.nombre_resultado, m.id] }
  end

  def index_convocatorias
    isadmin = is_admin
    user_asignado = -1
    @etapap = params[:etapap].present? ? params[:etapap] : '1'
    if Personasformulario.where("(user_asignado = #{isadmin} or user_asignado2 = #{isadmin} or user_asignado3 = #{isadmin} or user_asignado4 = #{isadmin} or user_asignado5 = #{isadmin})").present?
      user_asignado = isadmin
      @query = Migracion.where(["migraciones.estado = 'ACTIVO' and migraciones.publicado = 'CO' and id in (11,12)"]).order("orden asc").map { |m| [m.nombre, m.nombre_resultado, m.id] }
    else
      @query = Migracion.where(["migraciones.estado = 'ACTIVO' and migraciones.publicado = 'CO'"]).order("orden asc").map { |m| [m.nombre, m.nombre_resultado, m.id] }
    end
    if is_auth_c("consultarallconv")
      user_asignado = -1 #condiciones especial para supervisores
    end
    @personasformularios = nil
    @estado = params[:estado].present? ? params[:estado] : 'PENDIENTE'
    @tipo = params[:tipo].present? ? params[:tipo] : nil
    if user_asignado == -1
      sqlAdd = ""
      if @estado.to_s == 'CONTRATACION'
        sqlAdd = " and (id in (select distinct personasformulario_id from contratosperfechas where codigo_firma is null and personasformulario_id is not null)
                       or id not in (select distinct personasformulario_id from contratosperfechas where estado = 'ACTIVO' AND personasformulario_id is not null))"
      end
      @personasformularios = Personasformulario.select("personasformularios.*, (select descripcion from parcargos where id = personasformularios.parcargo_id) cargo_descripcion,
                                                       (select username from users where id = personasformularios.user_id ) username,
                                                       (select id from contratospersonas where identificacion = personasformularios.identificacion limit 1 ) idpersona,
                                                       (select distinct 'X' from contratosperfechas where codigo_firma is not null and estado = 'ACTIVO' and contratospersona_id = (select id from contratospersonas where identificacion = personasformularios.identificacion limit 1 )) idvalidacioncontratocreado")
                                               .where("estado = '#{@estado}'").paginate(:page => params[:page], :per_page => 15).order("id desc")
      puts 'Aiooooooo Fabian'
    else
      @personasformularios = Personasformulario.select("personasformularios.*, (select descripcion from parcargos where id = personasformularios.parcargo_id) cargo_descripcion,
                                                       (select username from users where id = personasformularios.user_id ) username,
                                                       (select id from contratospersonas where identificacion = personasformularios.identificacion limit 1 ) idpersona,
                                                       (select distinct 'X' from contratosperfechas where codigo_firma is not null and estado = 'ACTIVO' and contratospersona_id = (select id from contratospersonas where identificacion = personasformularios.identificacion limit 1 )) idvalidacioncontratocreado")
                                               .where("estado = '#{@estado}' and (user_asignado = #{user_asignado} or user_asignado2 = #{user_asignado} or user_asignado3 = #{user_asignado} or user_asignado4 = #{user_asignado} or user_asignado5 = #{user_asignado})").paginate(:page => params[:page], :per_page => 15).order("id desc")
    end
  end

  def buscador
    isadmin = is_admin
    user_asignado = -1
    if is_auth_c("consultarallconv")
      user_asignado = -1
    else
      if Personasformulario.select("personasformularios.*, (select descripcion from parcargos where id = personasformularios.parcargo_id) cargo_descripcion,
                                                         (select username from users where id = personasformularios.user_id ) username,
                                                         (select id from contratospersonas where identificacion = personasformularios.identificacion limit 1 ) idpersona,
                                                         (select distinct 'X' from contratosperfechas where codigo_firma is not null and estado = 'ACTIVO' and contratospersona_id = (select id from contratospersonas where identificacion = personasformularios.identificacion limit 1 )) idvalidacioncontratocreado")
                           .where("(user_asignado = #{isadmin} or user_asignado2 = #{isadmin} or user_asignado3 = #{isadmin} or user_asignado4 = #{isadmin} or user_asignado5 = #{isadmin})").present?
        user_asignado = isadmin
      end
    end
    nroreg = params[:format] == 'xlsx' ? 100000 : 10
    @personasformulariosb = Personasformulario.select("personasformularios.*, (select descripcion from parcargos where id = personasformularios.parcargo_id) cargo_descripcion,
                                                       (select username from users where id = personasformularios.user_id ) username,
                                                       (select id from contratospersonas where identificacion = personasformularios.identificacion limit 1 ) idpersona,
                                                       (select distinct 'X' from contratosperfechas where codigo_firma is not null and estado = 'ACTIVO' and contratospersona_id = (select id from contratospersonas where identificacion = personasformularios.identificacion limit 1 )) idvalidacioncontratocreado")
                                             .search(params[:identificacion], params[:nombre], params[:archivo_id], params[:celular], params[:page], nroreg,user_asignado)
    respond_to do |format|
      format.js
    end
  end

  def etapar
    if params[:etapa].to_s != ""
      User.where(id: is_admin).update_all(etapa: params[:etapa].to_s, updated_at: Time.now)
    end
    redirect_to migraciones_path
  end

  def etaparformulario
    if params[:etapa].to_s != ""
      User.where(id: is_admin).update_all(etapa: params[:etapa].to_s, updated_at: Time.now)
    end
    redirect_to index_convocatorias_migraciones_path
  end

=begin
  def show
  end

  def new
    @migracion = Migracion.new
  end

  def edit
  end

  def create
    @migracion = Migracion.new(migracion_params)

    respond_to do |format|
      if @migracion.save
        format.html { redirect_to @migracion, notice: 'Migracion was successfully created.' }
        format.json { render :show, status: :created, location: @migracion }
      else
        format.html { render :new }
        format.json { render json: @migracion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /migraciones/1
  # PATCH/PUT /migraciones/1.json
  def update
    respond_to do |format|
      if @migracion.update(migracion_params)
        format.html { redirect_to @migracion, notice: 'Migracion was successfully updated.' }
        format.json { render :show, status: :ok, location: @migracion }
      else
        format.html { render :edit }
        format.json { render json: @migracion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /migraciones/1
  # DELETE /migraciones/1.json
  def destroy
    @migracion.destroy
    respond_to do |format|
      format.html { redirect_to migraciones_url, notice: 'Migracion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
=end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_migracion
    @migracion = Migracion.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def migracion_params
    params.require(:migracion).permit!
  end
end
