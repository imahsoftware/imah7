class Contratoscapapersona < ApplicationRecord
  belongs_to :contratospersona
  belongs_to :contratosperfecha
  belongs_to :contrato
  belongs_to :capacitacion
  belongs_to :contratoscapacitacion

  validates_presence_of :contratosperfecha_id

  def descripcion_empleado
    return Contratosperfecha.find(self.contratosperfecha_id).contratospersona.autobuscar rescue nil
  end

  def cantidad_preguntas_ok
    vlr_aprobado = capacitacion.valor_aprobado.present? ? capacitacion.valor_aprobado.to_i : 0
    if Contratoscaparesultado.where("contratoscapapersona_id = #{self.id} and resultado = 1").count.to_i >= vlr_aprobado.to_i
      return 'APROBADO'
    else
      return 'REPROBADO'
    end
  end
end
