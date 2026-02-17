class Encuestapreopcion < ApplicationRecord
  belongs_to :encuestapregunta

  validates_presence_of :respuesta, :clase
end
