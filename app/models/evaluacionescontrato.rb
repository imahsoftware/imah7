class Evaluacionescontrato < ApplicationRecord
  belongs_to :evaluacion
  belongs_to :user

  validates_presence_of :user_responsable

  def estado_descripcion
    if estado.to_s == '0.0'
      "PENDIENTE"
    elsif estado.to_s == '0.5'
      'EN PROCESO'
    elsif estado.to_s == '1.0'
      'COMPLETADO'
    end
  end

  def estado_descripcion_prueba
    if estado.to_s == '0.0'
      "PENDIENTE"
    else
      'COMPLETADO'
    end
  end

  def estadoepp
    if estado.to_f >= 3.53
      "SOBRESALIENTE"
    elsif estado.to_f >= 2.53
      "SATISFACTORIO"
    elsif estado.to_f <= 1.52
      "NO SATISFACTORIO"
    else
      "NECESITA MEJORAR REALIZAR PLAN DE ACCION"
    end
  end

  def nombre_empleado
    contratosperfecha = Contratosperfecha.find(self.contratosperfecha_id)
    return contratosperfecha.contratospersona.nombre_completo
  end
end
