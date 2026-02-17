class Tiposevaluacion < ApplicationRecord

  def detalle_esp
    detalle.gsub("*","<br/>").html_safe
  end

  def detalle_esp2
    detalle.gsub("*",", ").html_safe
  end
end
