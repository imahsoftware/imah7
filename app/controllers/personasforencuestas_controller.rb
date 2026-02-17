class PersonasforencuestasController < ApplicationController
  before_action :set_personasforencuesta, only: [:show, :edit, :update, :destroy]

  def edit_individual
    para = params[:contratossolicitud_id].to_i
    @contratossolicitud = Contratossolicitud.find(para)
    @contratossoldetalles = @contratossolicitud.contratossoldetalles.order("contratosinsumo_id asc")
  end

  def update_individual
    id = 0
    JSON.parse(params[:personasforencuestas].to_json).each do |object|
      id = Personasforencuesta.find(object[0]).encuestaspregunta_id.to_s
      break if id != ""
    end
    Personasforencuesta.update(params[:personasforencuestas].keys, params[:personasforencuestas].values)
    ActiveRecord::Base.connection.execute("UPDATE personasforencuestas SET calificacion = (SELECT clase FROM encuestapreopciones WHERE id = personasforencuestas.encuestapreopcion_id)
                                            WHERE personasformulario_id = #{params[:personasformulario_id]}")
    flash[:notice] = "Actualizada con Exito."
    redirect_to registro_personasformularios_path(etapa: '3', personasformulario_id: params[:personasformulario_id])
  end

  def self.firma(contratosperfechaid,personasformularioId,isadmin)
    @contratosperfecha = Contratosperfecha.find(contratosperfechaid)
    fname = "Encuestaofimatica_" + @contratosperfecha.contratospersona.identificacion.to_s

    rutafact = "#{::Rails.root}/public/archivos/pdf/"
    rutanamefile = "#{::Rails.root}/public/archivos/pdf/#{fname}.pdf"

    pdf = ApplicationController.render pdf: "#{fname}", template: "personasforencuestas/encuesta", :save_to_file => rutanamefile, :save_only => true,
                                       encoding: "UTF-8", page_size: 'Letter', :margin => { top: 15, :bottom => 20, :left => 15, :right => 15 },
                                       locals: { object1: isadmin,
                                                 object2: personasformularioId }
    save_path = Rails.root.join(rutafact, "#{fname}.pdf")
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
    file = File.open("#{::Rails.root}/public/archivos/pdf/#{fname}.pdf", 'rb')
    @contratosperimagen = Contratosperimagen.new
    @contratosperimagen.contratospersona_id = @contratosperfecha.contratospersona_id
    @contratosperimagen.contratosperfecha_id = @contratosperfecha.id
    @contratosperimagen.user_id = isadmin
    @contratosperimagen.personasimagen = file
    @contratosperimagen.descripcion = 'ENCUESTA OFIMATICA'
    @contratosperimagen.estado = 'APROBADO'
    @contratosperimagen.created_at = @contratosperfecha.fecha_firma
    @contratosperimagen.updated_at = @contratosperfecha.fecha_firma
    @contratosperimagen.save(validate: false)
    system("rm -r #{rutanamefile}")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_personasforencuesta
      @personasforencuesta = Personasforencuesta.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def personasforencuesta_params
      params.require(:personasforencuesta).permit(:personasformulario_id, :encuesta_id, :encuestaspregunta_id, :encuestapreopcion_id, :calificacion)
    end
end
