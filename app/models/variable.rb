class Variable < ApplicationRecord
  validates_presence_of :nombre, :campo, :segmento

  def descripcion_variable
    "#{nombre}"
  end

  def descripcion_variable_ori
    "#{nombre} - #{campo}"
  end

end
