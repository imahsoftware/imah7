class Contratoscaparesultado < ApplicationRecord
  belongs_to :capacitacion
  belongs_to :contratosperfecha
  belongs_to :contratoscapapersona
  belongs_to :capacitacionevaluacion
  belongs_to :contrato

  def descripcion_resultado
    if self.resultado.to_s == '1'
      return 'CORRECTA'
    elsif self.resultado.to_s == '0'
      return 'INCORRECTA'
    else
      return 'SIN RESPONDER'
    end
  end
end
