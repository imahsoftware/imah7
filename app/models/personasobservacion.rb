class Personasobservacion < ApplicationRecord
  belongs_to :persona

  validates_presence_of :observacion
end
