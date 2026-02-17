class Capacitacionevaopcion < ApplicationRecord
  belongs_to :capacitacionevaluacion

  validates_presence_of :respuesta, :descripcion

  has_attached_file :imagen, styles: { medium: '120x120!', thumb: '100x100!' }, whiny: false

  validates_attachment_content_type :imagen, content_type: /\Aimage\/.*\Z/
  validates_attachment_size :imagen, less_than: 25000.kilobytes, message: "El tamaño del archivo no puede ser superior a 25 Megabytes"
  do_not_validate_attachment_file_type :imagen

  def descripcion_respuesta
    if respuesta.to_i == 1
      "CORRECTO"
    elsif respuesta.to_i == 0
      "INCORRECTO"
    end
  end
end
