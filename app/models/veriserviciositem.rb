class Veriserviciositem < ApplicationRecord
  belongs_to :veriservicio
  has_many :veriserviciosiimagenes, dependent: :destroy
  has_many :veriserviciosicompromisos, dependent: :destroy
  has_many :veriserviciosinotas, dependent: :destroy

  def ver_detalle_opciones
    if veriserviciosiimagenes.present? || veriserviciosicompromisos.present? || veriserviciosinotas.present?
      true
    else
      false
    end
  end

  def calificacion_descripcion
    case calificacion
    when 0
      'N/A'
    else
      calificacion
    end
  end
end
