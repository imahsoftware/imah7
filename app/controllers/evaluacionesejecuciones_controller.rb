class EvaluacionesejecucionesController < ApplicationController
  before_action :set_evaluacionesejecucion, only: [:show, :edit, :update, :destroy]

  require 'gruff'

  def update_resultado
    @evaluacionesejecucion = Evaluacionesejecucion.find(params[:id])
    if @evaluacionesejecucion.update(resultado: params[:resultado].upcase, user_id: is_admin)
      render json: { status: 'success', message: 'Resultado actualizada correctamente' }
    else
      render json: { status: 'error', message: 'Error al actualizar el resultado' }
    end
  end

  def agregar_a_contrato
    @evaluacionescontrato_id = params[:evaluacionescontrato_id]
    @user = User.find(params[:user_id])
    @evaluacion = Evaluacion.find(params[:evaluacion_id])

    @contratosperfecha = Contratosperfecha.joins(:contratospersona).select("contratosperfechas.*").where(["contratospersonas.identificacion = '#{@user.identificacion.to_s}' and contratosperfechas.estado ='ACTIVO'"])[0]

    @contratospersona = @contratosperfecha.contratospersona

    fname = "Evaluacion_#{@user.identificacion.to_s}_#{Time.now.strftime("%d%m%Y_%X")}"
    rutafact = "#{::Rails.root}/public/archivos/pdf/"
    rutanamefile = "#{::Rails.root}/public/archivos/pdf/#{fname}.pdf"


    pdf = ApplicationController.render pdf: "#{fname}", template: "evaluacionesejecuciones/actividades_pdf.html.erb", :save_to_file => rutanamefile, :save_only => true,
                                       encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 5, :right => 5 },
                                       locals: { logo: @logo, ruta: 'X',  evaluacionescontrato_id: params[:evaluacionescontrato_id], user_id: @user.id, evaluacion_id: @evaluacion.id}




    save_path = Rails.root.join(rutafact, "#{fname}.pdf")
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
    file = File.open("#{::Rails.root}/public/archivos/pdf/#{fname}.pdf", 'rb')

    @contratosperimagen = Contratosperimagen.new
    @contratosperimagen.contratospersona_id = @contratospersona.id
    @contratosperimagen.contratosperfecha_id = @contratosperfecha.id
    @contratosperimagen.user_id = is_admin
    @contratosperimagen.personasimagen = file
    @contratosperimagen.descripcion = "EVALUACION DESEMPEÑO"
    @contratosperimagen.estado = 'APROBADO'
    @contratosperimagen.created_at = Time.now
    @contratosperimagen.updated_at = Time.now
    @contratosperimagen.save(validate: false)
    system("rm -r #{rutanamefile}")

    respond_to do |format|
      flash[:notice] = "Evaluación Cargada con exito"
      format.js { render inline: "location.reload();" }
    end
  end

  def actividades_pdf
    @user = User.find(params[:user_id])
    @evaluacion = Evaluacion.find(params[:evaluacion_id])
    @evaluacionescontrato_id = params[:evaluacionescontrato_id]
    @contratosperfecha = Contratosperfecha.joins(:contratospersona).select("contratosperfechas.*").where(["contratospersonas.identificacion = '#{@user.identificacion.to_s}' and contratosperfechas.estado ='ACTIVO'"])[0]
    @logo = @user.portafolio.logoportafolio.to_s


    @evaluacionesejecuciones = Evaluacionesejecucion.joins(:evaluacionescontrato, :evaluacionesdetalle)
                                                    .select("evaluacionescontratos.user_responsable user_responsable_id,
                                                            (select ltrim(rtrim(nombre)) from users where id = evaluacionescontratos.user_responsable) nombresuser,
                                                            (select nombre from users where id = evaluacionesejecuciones.user_marca) nombresusermarca,
                                                            (select email from users where id = evaluacionescontratos.user_responsable) emailuser, evaluacionesejecuciones.*")
                                                    .where("evaluacionesejecuciones.evaluacion_id = ? and evaluacionescontratos.user_responsable = ?", @evaluacion.id, @user.id)
                                                    .order('evaluacionesdetalles.clase asc')

    if @evaluacion.tipo == 'EVALUACION PERIODO PRUEBA'
      @resultados = Objeto.find_by_sql("SELECT
                                        u.nombre,
                                        ed.clase,
                                        COUNT(ev.id) AS cnt_items,
                                        COUNT(ee.id) AS cnt_evaluada,
                                        (COUNT(ee.id) * 100 / COUNT(ev.id)) AS resultado
                                    FROM evaluacionescontratos ec
                                    LEFT JOIN evaluacionesejecuciones ev ON ev.evaluacionescontrato_id = ec.id
                                    LEFT JOIN evaluacionesdetalles ed ON ed.evaluacion_id = ec.evaluacion_id AND ed.id = ev.evaluacionesdetalle_id
                                    LEFT JOIN users u ON u.id = ec.user_responsable
                                    LEFT JOIN evaluacionesejecuciones ee ON ee.evaluacionescontrato_id = ec.id AND ee.evaluacionesdetalle_id = ed.id AND IFNULL(ee.estado, '0') IN ('1', '2','3','4')
                                    WHERE ec.evaluacion_id = #{@evaluacion.id}
                                    AND ec.user_responsable = #{@user.id}
                                    GROUP BY u.nombre,ed.clase, ec.user_responsable
                                    ORDER BY 1, 2 DESC;")
    else
      @resultados = Objeto.find_by_sql("SELECT
                                        CASE
                                            WHEN evaluacionesejecuciones.estado = '' THEN 'Pendiente'
                                            WHEN evaluacionesejecuciones.estado = '1' THEN 'Cumple'
                                            WHEN evaluacionesejecuciones.estado = '1.0' THEN 'No Aplica'
                                            WHEN evaluacionesejecuciones.estado = '0.5' THEN 'Parcialmente'
                                            WHEN evaluacionesejecuciones.estado = '0' THEN 'No Cumple'
                                        END AS clase,
                                        COUNT(evaluacionesejecuciones.estado) AS cnt_evaluada
                                    FROM `evaluacionesejecuciones`
                                    INNER JOIN `evaluacionescontratos` ON `evaluacionescontratos`.`id` = `evaluacionesejecuciones`.`evaluacionescontrato_id`
                                    INNER JOIN `evaluacionesdetalles` ON `evaluacionesdetalles`.`id` = `evaluacionesejecuciones`.`evaluacionesdetalle_id`
                                    WHERE evaluacionesejecuciones.evaluacion_id = #{@evaluacion.id}
                                    AND   evaluacionescontratos.user_responsable = #{@user.id}
                                    GROUP BY evaluacionesejecuciones.estado")
    end



    g = Gruff::Pie.new
    g.title = "Resultado"
    g.theme = {
      :colors => %w(orange purple green white red),
      :marker_color => 'blue',
      :background_colors => %w(white white)
    }

    @resultados.each do |p|
      g.data p.clase.to_s, p.cnt_evaluada.to_i
    end

    # Guardar el gráfico en un archivo temporal
    temp_file = Tempfile.new([@evaluacionescontrato_id, '.png'])
    g.write(temp_file.path)

    # Buscar y eliminar el registro de la tabla Graph
    Graph.where(tabla: 'EVALUACIONESCONTRATOS', id_registro: @evaluacionescontrato_id).destroy_all

    # Crear un nuevo objeto Graph y adjuntar la imagen
    @graph = Graph.new
    @graph.tabla = 'EVALUACIONESCONTRATOS'
    @graph.id_registro = @evaluacionescontrato_id
    @graph.graphimage = temp_file
    @graph.save

    # Eliminar el archivo temporal
    temp_file.close
    temp_file.unlink

    fname = "Evaluacion_#{@user.identificacion}"
    # Renderizar el PDF
    respond_to do |format|
      format.pdf do
        render pdf: fname,
               template: "evaluacionesejecuciones/actividades_pdf.html.erb",
               encoding: "UTF-8",
               page_size: 'Letter',
               :margin => { top: 15, :bottom => 20, :left => 5, :right => 5 },
               disposition: 'inline',
               locals: { ruta: nil }
      end
    end
  end

  def actividades_pdf_completo
    @user = User.find(params[:user_id])
    @evaluacion = Evaluacion.find(params[:evaluacion_id])
    @evaluacionescontrato_id = params[:evaluacionescontrato_id]
    @contratosperfecha = Contratosperfecha.joins(:contratospersona).select("contratosperfechas.*").where(["contratospersonas.identificacion = '#{@user.identificacion.to_s}' and contratosperfechas.estado ='ACTIVO'"])[0]
    @contrato = @contratosperfecha.contrato
    @logo = @user.portafolio.logoportafolio.to_s
    @evaluacionesejecuciones = Evaluacionesejecucion.joins(:evaluacionescontrato, :evaluacionesdetalle)
                                                    .select("DISTINCT evaluacionesejecuciones.evaluacion_id as evaluacion_id, evaluacionescontratos.user_responsable user_responsable_id, evaluacionesejecuciones.fecha_marca as fecha_marca")
                                                    .where("evaluacionesejecuciones.evaluacion_id = ? and evaluacionescontratos.user_responsable IN (SELECT id FROM users WHERE identificacion IN (SELECT identificacion FROM contratospersonas WHERE id IN (SELECT contratospersona_id FROM contratosperfechas WHERE contrato_id = ? AND estado = 'ACTIVO')))", @evaluacion.id, @contrato.id)
                                                    .order('evaluacionesdetalles.clase asc')

    fname = "Evaluaciones_#{@evaluacion.id}"

    respond_to do |format|
      format.pdf do
        render pdf: fname,
               template: "evaluacionesejecuciones/actividades_pdf_completo.html.erb",
               encoding: "UTF-8",
               page_size: 'Letter',
               disposition: 'inline'
      end
    end
  end

  def cargar
    @evaluacionesejecucion = Evaluacionesejecucion.find(params[:id])
    @evaluacionesejecucionesdoc = Evaluacionesejecucionesdoc.new
  end

  def proceso
    @user_responsable = params[:user_responsable]
    @evaluacion = Evaluacion.find(params[:evaluacion_id])
    render "proceso_form"
  end

  def finalizar_prueba
    @estado = params[:estado] rescue nil
    @contratosperfecha = Contratosperfecha.find(params[:contratosperfecha_id]) rescue nil
    @user_responsable = params[:user_responsable_id] rescue nil
    @evaluacionesejecucion = Evaluacionesejecucion.find(params[:id])
    if [ '2', '1'].include?(@estado) and @evaluacionesejecucion.resultado.present?
      @evaluacionesejecucion.estado = @estado
      @evaluacionesejecucion.user_marca = is_admin
      @evaluacionesejecucion.fecha_marca = Time.now
      @evaluacionesejecucion.save(validate: false)
    elsif ['3', '4'].include?(@estado)
      @evaluacionesejecucion.estado = @estado
      @evaluacionesejecucion.user_marca = is_admin
      @evaluacionesejecucion.fecha_marca = Time.now
      @evaluacionesejecucion.save(validate: false)
    end

    respond_to do |format|
      flash[:notice] = "Marcada con exito!!!"
      format.js
    end
  end

  def finalizar
    @estado = params[:estado] rescue nil
    @user_responsable = params[:user_responsable_id] rescue nil
    @evaluacionesejecucion = Evaluacionesejecucion.find(params[:id])
    if ['1.0', '0.5', '0'].include?(@estado) and @evaluacionesejecucion.resultado.present?
      @evaluacionesejecucion.estado = @estado
      @evaluacionesejecucion.user_marca = is_admin
      @evaluacionesejecucion.fecha_marca = Time.now
      @evaluacionesejecucion.save(validate: false)
    elsif ['1'].include?(@estado)
      @evaluacionesejecucion.estado = @estado
      @evaluacionesejecucion.user_marca = is_admin
      @evaluacionesejecucion.fecha_marca = Time.now
      @evaluacionesejecucion.save(validate: false)
    end

    respond_to do |format|
      flash[:notice] = "Marcada con exito!!!"
      format.js
    end
  end

  # GET /evaluacionesejecuciones
  # GET /evaluacionesejecuciones.json
  def index
    @evaluacionesejecuciones = Evaluacionesejecucion.all
  end

  # GET /evaluacionesejecuciones/1
  # GET /evaluacionesejecuciones/1.json
  def show
  end

  # GET /evaluacionesejecuciones/new
  def new
    @evaluacionesejecucion = Evaluacionesejecucion.new
  end

  # GET /evaluacionesejecuciones/1/edit
  def edit
  end

  # POST /evaluacionesejecuciones
  # POST /evaluacionesejecuciones.json
  def create
    @evaluacionesejecucion = Evaluacionesejecucion.new(evaluacionesejecucion_params)

    respond_to do |format|
      if @evaluacionesejecucion.save
        format.html { redirect_to @evaluacionesejecucion, notice: 'Evaluacionesejecucion was successfully created.' }
        format.json { render :show, status: :created, location: @evaluacionesejecucion }
      else
        format.html { render :new }
        format.json { render json: @evaluacionesejecucion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /evaluacionesejecuciones/1
  # PATCH/PUT /evaluacionesejecuciones/1.json
  def update
    respond_to do |format|
      if @evaluacionesejecucion.update(evaluacionesejecucion_params)
        format.html { redirect_to @evaluacionesejecucion, notice: 'Evaluacionesejecucion was successfully updated.' }
        format.json { render :show, status: :ok, location: @evaluacionesejecucion }
      else
        format.html { render :edit }
        format.json { render json: @evaluacionesejecucion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /evaluacionesejecuciones/1
  # DELETE /evaluacionesejecuciones/1.json
  def destroy
    @evaluacionesejecucion.destroy
    respond_to do |format|
      format.html { redirect_to evaluacionesejecuciones_url, notice: 'Evaluacionesejecucion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_evaluacionesejecucion
    @evaluacionesejecucion = Evaluacionesejecucion.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def evaluacionesejecucion_params
    params.require(:evaluacionesejecucion).permit(:evaluacionescontrato_id, :evaluacion_id, :evalacionesdetalle_id, :estado, :user_id, :resultado)
  end
end
