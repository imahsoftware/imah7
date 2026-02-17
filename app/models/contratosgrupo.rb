class Contratosgrupo < ApplicationRecord
  belongs_to :contrato

  validates_presence_of :descripcion, :termino
end
