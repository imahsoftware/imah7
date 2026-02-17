class Tiposmevaluacion < ApplicationRecord
  def detalle_esp
    detalle.html_safe
  end
end
