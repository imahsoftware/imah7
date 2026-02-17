class Contratospervacacion < ApplicationRecord
  belongs_to :contratospersona
  belongs_to :contratosperfecha
  belongs_to :user
  belongs_to :contrato

  validates_presence_of :fecha_inicio, :dias_disfrute, :jornada, message: "* Obligatorio"

end
