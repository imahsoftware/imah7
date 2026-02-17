class ArchivosController < ApplicationController
  before_action :set_archivo, only: [:show, :edit, :update, :destroy]

  require 'csv'
  require 'find'
  require 'zip'
  require 'fileutils'
  require 'rubygems'
  require 'rubygems'
  require 'roo'

  def new
    @archivo = Archivo.new
  end

  def edit
    
  end

  def download_ctl
    @archivo = Archivo.find(params[:id])
    name = @archivo.documentos_file_name
    ruta = "#{::Rails.root}/public/system/documentos/#{@archivo.id}/original/#{name}"
    send_file ruta, x_sendfile: true
  end

  def create
    isportafolio = is_portafolio
    isadmin = is_admin
    @archivo = Archivo.new(archivo_params)
    @archivo.user_id = isadmin
    @archivo.portafolio_id = isportafolio
    if @archivo.save
      archivo = @archivo.documentos_file_name
      name = archivo
      directory = "#{::Rails.root}/public/system/documentos/#{@archivo.id}/original/"
      path2 = File.join(directory, name)
      if @archivo.migracion.to_s == 'migracionesinsumos'
        ActiveRecord::Base.connection.execute("truncate table #{@archivo.migracion.to_s}")
        ImportFileJob.perform_later(path2, isportafolio, @archivo.id, 'INSUMOSCCE')
      elsif @archivo.migracion.to_s == 'migracionesinsumosnocce'
        ActiveRecord::Base.connection.execute("truncate table migracionesinsumos")
        ImportFileJob.perform_later(path2, isportafolio, @archivo.id, 'INSUMOSNCCE')
      elsif @archivo.migracion.to_s == 'migracionesrodamientos'
        ActiveRecord::Base.connection.execute("truncate table migracionesrodamientos")
        ImportFileJob.perform_later(path2, isportafolio, @archivo.id, 'RODAMIENTOS')
      elsif @archivo.migracion.to_s == 'migracionesnovedades'
        ActiveRecord::Base.connection.execute("truncate table migracionesnovedades")
        ImportFileJob.perform_later(path2, isportafolio, @archivo.id, 'NOVEDADES')
      elsif @archivo.migracion.to_s == 'migracionespersonas'
        ImportFileJob.perform_later(path2, isportafolio, @archivo.id, 'CARGUE CANDIDATOS')
      elsif @archivo.migracion.to_s == 'migracionespersonas2'
        ImportFileJob.perform_later(path2, isportafolio, @archivo.id, 'CARGUE MINICONTRATACION')
      elsif @archivo.migracion.to_s == 'migracionesexamenes'
        ImportFileJob.perform_later(path2, isportafolio, @archivo.id, 'EXAMENES')
      elsif @archivo.migracion.to_s == 'migracionesestados'
        ImportFileJob.perform_later(path2, isportafolio, @archivo.id, 'EXAMENESESTADOS')
      elsif @archivo.migracion.to_s == 'migracionesactividades'
        ImportFileJob.perform_later(path2, isportafolio, @archivo.id, 'TAREASACTIVIDADES', params[:tarea_id])
      elsif @archivo.migracion.to_s == 'migracionessedes'
        ImportFileJob.perform_later(path2, isportafolio, @archivo.id, 'SEDES')
      else
        ActiveRecord::Base.connection.execute("truncate table #{@archivo.migracion.to_s}")
        ImportFileJob.perform_later(path2, isportafolio, @archivo.id)
      end

      if @archivo.datoid.to_s != "" and @archivo.migracion.to_s == 'migracionesinsumos'
        ActiveRecord::Base.connection.execute("CALL migracionesinsumos_cce(#{@archivo.id})")
        flash[:notice] = 'Archivo Cargado con Exito...'
        if @archivo.clase.to_s == 'INSUMO'
          redirect_to edit_contrato_path(id: @archivo.datoid.to_i, etapa: 'F')
        elsif @archivo.clase.to_s == 'MAQUINARIA'
          redirect_to edit_contrato_path(id: @archivo.datoid.to_i, etapa: 'M')
        end
      elsif @archivo.datoid.to_s != "" and @archivo.migracion.to_s == 'migracionesinsumosnocce'
        ActiveRecord::Base.connection.execute("CALL migracionesinsumos_nocce(#{@archivo.id})")
        flash[:notice] = 'Archivo Cargado con Exito...'
        redirect_to edit_contrato_path(id: @archivo.datoid.to_i, etapa: 'F')
      elsif @archivo.migracion.to_s == 'migracionesrodamientos'
        ActiveRecord::Base.connection.execute("CALL migracionesrodamientos(#{@archivo.id})")
        flash[:notice] = 'Archivo Cargado con Exito...'
        redirect_to migraciones_path
      elsif @archivo.migracion.to_s == 'migracionesnovedades'
        ActiveRecord::Base.connection.execute("CALL migracionesnovedades(#{@archivo.id})")
        flash[:notice] = 'Archivo Cargado con Exito...'
        redirect_to migraciones_path
      elsif @archivo.migracion.to_s == 'migracionespersonas'
        if @archivo.datoid.present?
          ActiveRecord::Base.connection.execute("CALL migracionespersonas(#{@archivo.id}, #{@archivo.datoid})")
          Personasformulario.creacion_estudiantes(@archivo.id)
          flash[:notice] = 'Archivo Cargado con Exito...'
        else
          Migracionespersona.where("archivo_id = #{@archivo.id}").update_all(error: " * EL NRO DEL CONTRATO NO FUE CARGADO", estado: 'NO APLICADO')
          flash[:notice] = 'Debes Seleccionar un Contrato !!!!!'
        end
        redirect_to index_convocatorias_migraciones_path
      elsif @archivo.migracion.to_s == 'migracionespersonas2'
        if @archivo.datoid.present?
          ActiveRecord::Base.connection.execute("CALL migracionespersonas_minicontratacion(#{@archivo.id}, #{@archivo.datoid})")
          Personasformulario.creacion_minicontratacion(@archivo.id)
          flash[:notice] = 'Archivo Cargado con Exito...'
        else
          Migracionespersona.where("archivo_id = #{@archivo.id}").update_all(error: " * EL NRO DEL CONTRATO NO FUE CARGADO", estado: 'NO APLICADO')
          flash[:notice] = 'Debes Seleccionar un Contrato !!!!!'
        end
        redirect_to index_convocatorias_migraciones_path
      elsif @archivo.migracion.to_s == 'migracionesexamenes' or @archivo.migracion.to_s == 'migracionesestados'
        ActiveRecord::Base.connection.execute("CALL migracionesexamenes(#{@archivo.id}, '#{params[:tipo]}')")
        flash[:notice] = 'Archivo Cargado con Exito...'
        redirect_to index_convocatorias_migraciones_path(etapa: 'EXAMENES')
      elsif @archivo.migracion.to_s == 'migracionescontratos'
        ActiveRecord::Base.connection.execute("CALL migracionescontratos(#{@archivo.id})")
        flash[:notice] = 'Archivo Cargado con Exito...'
        redirect_to migraciones_path
      elsif @archivo.migracion.to_s == 'migracionesprorrogas'
        ActiveRecord::Base.connection.execute("CALL migracionesprorrogas(#{@archivo.id})")
        flash[:notice] = 'Archivo Cargado con Exito...'
        redirect_to migraciones_path
      elsif @archivo.migracion.to_s == 'migracionesterminaciones'
        ActiveRecord::Base.connection.execute("CALL migracionesterminaciones(#{@archivo.id})")
        flash[:notice] = 'Archivo Cargado con Exito...'
        redirect_to migraciones_path
      elsif @archivo.migracion.to_s == 'migracionessupervisores'
        ActiveRecord::Base.connection.execute("CALL migracionessupervisores(#{@archivo.id})")
        flash[:notice] = 'Archivo Cargado con Exito...'
        redirect_to migraciones_path
      elsif @archivo.migracion.to_s == 'migracionescuentas'
        ActiveRecord::Base.connection.execute("CALL migracionescuentas(#{@archivo.id})")
        flash[:notice] = 'Archivo Cargado con Exito...'
        redirect_to migraciones_path
      elsif @archivo.migracion.to_s == 'migracionestelefonos'
        ActiveRecord::Base.connection.execute("CALL migracionestelefonos(#{@archivo.id})")
        flash[:notice] = 'Archivo Cargado con Exito...'
        redirect_to migraciones_path
      elsif @archivo.migracion.to_s == 'migracionestallas'
        ActiveRecord::Base.connection.execute("CALL migracionestallas(#{@archivo.id})")
        flash[:notice] = 'Archivo Cargado con Exito...'
        redirect_to migraciones_path
      elsif @archivo.migracion.to_s == 'migracionesactividades'
        ActiveRecord::Base.connection.execute("CALL migracionesactividades(#{@archivo.id})")
        flash[:notice] = 'Archivo Cargado con Exito...'
        redirect_to edit_tarea_path(id: params[:tarea_id])
      elsif @archivo.migracion.to_s == 'migracionessedes'
        ActiveRecord::Base.connection.execute("CALL migracionessedes(#{@archivo.id})")
        flash[:notice] = 'Archivo Cargado con Exito...'
        redirect_to edit_contrato_path(id: @archivo.datoid.to_i, etapa: 'H')
      else
        flash[:notice] = 'Archivo Cargado con Exito...'
        redirect_to migraciones_path
      end
    else
      flash[:notice] = 'Problemas con el archivo...'
      redirect_to migraciones_path
    end
  end

  def errores
    sql = ""
    archivoId = params[:archivo_id]
    tipo = params[:tipo] rescue nil
    candidato = params[:candidato] rescue nil
    @codigomigracion = params[:migracion_id]
    @archivo = Archivo.find(archivoId)
    if tipo.present?
      sql = " and tipo = '#{tipo}'"
    end
    mig = @archivo.migracion.to_s
    if mig == 'migracionespersonas2'
      mig = 'migracionespersonas'
    end
    if sql.present?
      @mconerror = Objeto.find_by_sql(["select * from #{mig} where estado_cargue = 'NO APLICADO' #{sql}"])
    elsif candidato.present?
      @mconerror = Objeto.find_by_sql(["select * from #{mig} where estado = 'NO APLICADO' and archivo_id = #{archivoId}"])
    else
      @mconerror = Objeto.find_by_sql(["select * from #{mig} where estado = 'NO APLICADO'"])
    end
    @moduloscampos = Migracionescampo.where(migracion_id: @codigomigracion).order("orden asc")
    @nombreinforme = Migracion.find(@codigomigracion).descripcion.to_s rescue nil
    respond_to do |format|
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="Asear_errores_' + "#{Time.now.strftime("%Y%m%d_%X")}" + '.xlsx"'
      }
    end
  end

  def get_tipoproceso
    @migracion = params[:archivo_migracion]
    respond_to { |format| format.js }
  end

  def get_archivo_clase
    @migracion = params[:clase]
    respond_to { |format| format.js }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_archivo
    @archivo = Archivo.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def archivo_params
    params.require(:archivo).permit!
  end
end
