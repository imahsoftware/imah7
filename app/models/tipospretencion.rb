class Tipospretencion < ApplicationRecord
  has_many :contratosretenciones

  def detalle
    codigo.to_s + ' - ' + descripcion.to_s
  end
end
